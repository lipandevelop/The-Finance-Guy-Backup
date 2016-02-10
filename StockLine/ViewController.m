//
//  ViewController.m
//  StockLine
//
//  Created by Li Pan on 2016-02-08.
//  Copyright © 2016 Li Pan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "GraphTool.h"
#import "Stock.h"
#import "Coordinate.h"

@interface ViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) GraphTool *graphTool;
@property (nonatomic, strong) Coordinate *currentCoordinate;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureTool;
@property (nonatomic, strong) UITapGestureRecognizer *buy;
@property (nonatomic, strong) UITapGestureRecognizer *sell;
@property (nonatomic, strong) UISwipeGestureRecognizer *initiateShortSelling;
@property (nonatomic, strong) UITapGestureRecognizer *shortSell;

@property (nonatomic, strong) UILabel *firstBlock;
@property (nonatomic, strong) UILabel *pointBlock;
@property (nonatomic, strong) UITextField *infoLabel;

@property (nonatomic, assign) int timeIndex;
@property (nonatomic, assign) float currentPrice;

@property (nonatomic, assign) float boughtPrice;
@property (nonatomic, assign) float netGainLoss;

@property (nonatomic, assign) float shortPrice;

@property (nonatomic, assign) CFTimeInterval startTime;
@property (nonatomic, strong) CADisplayLink *displaylink;

@property (nonatomic, assign) BOOL scrollEnabled;
@property (nonatomic, assign) BOOL bought;
@property (nonatomic, assign) BOOL shorted;

@end

@implementation ViewController

static const float kTotalTime = 49.9;
static const float kUITransitionTime= 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadContent];
}

- (void)loadContent {
    
#pragma mark time
    //    NSLog(@"%f", self.startTime);
    self.displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [self.displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
#pragma mark graph
    self.view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:155.0/255.0 blue:64.0/255.0 alpha:1.0];
    self.graphTool = [[GraphTool alloc] initWithFrame:CGRectMake(0, 0, 2500, 800)];
    self.graphTool.backgroundColor = self.view.backgroundColor;
    self.scrollView.backgroundColor = self.view.backgroundColor;
    self.graphTool.userInteractionEnabled = YES;
    self.startTime = CACurrentMediaTime();
    
#pragma mark blocking
    self.pointBlock = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, CGRectGetHeight(self.graphTool.frame))];
    self.pointBlock.backgroundColor = [UIColor blackColor];
    self.pointBlock.alpha = 0.15;
    [UIView animateWithDuration:kTotalTime animations:^{
        self.pointBlock.frame = CGRectMake(CGRectGetWidth(self.graphTool.frame), 0, 1, CGRectGetHeight(self.graphTool.frame));
    }];
    self.timeIndex = self.pointBlock.frame.origin.x;
    self.firstBlock = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.graphTool.frame), CGRectGetHeight(self.graphTool.frame))];
    self.firstBlock.backgroundColor = self.graphTool.backgroundColor;
    [UIView animateWithDuration:kTotalTime animations:^{
        self.firstBlock.frame = CGRectMake(CGRectGetWidth(self.graphTool.frame), 0, CGRectGetWidth(self.graphTool.frame), CGRectGetHeight(self.graphTool.frame));
    }];
    
#pragma mark label
    
    self.infoLabel = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, CGRectGetHeight(self.graphTool.frame))];
    
#pragma mark userActions
    
    self.buy = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buyAction:)];
    [self.buy setNumberOfTapsRequired:1];
    self.buy.enabled = YES;
    
    self.sell = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sellAction:)];
    [self.sell setNumberOfTapsRequired:2];
    self.sell.enabled = NO;
    
    self.initiateShortSelling = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(shortSellingActionInitiated:)];
    [self.initiateShortSelling setDirection:UISwipeGestureRecognizerDirectionDown];
    self.initiateShortSelling.enabled = YES;
    
    self.shortSell = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shortSell:)];
    [self.shortSell setNumberOfTapsRequired:1];
    self.shortSell.enabled = NO;
    
#pragma mark addingViews
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView setContentOffset:CGPointMake(0, self.graphTool.startingPrice - 600)];
    
    //    if ((self.scrollEnabled == YES && (self.displaylink.timestamp - self.startTime) >= 10)) {
    //        [UIView animateWithDuration:kTotalTime animations:^{
    //            self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.graphTool.frame) - 500, self.currentprice + 500);
    //    }];
    //    }
    [self.scrollView setZoomScale:1.5];
    self.view.opaque = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.clipsToBounds = YES;
    
    [self.scrollView setMaximumZoomScale:4.0];
    [self.scrollView setMinimumZoomScale:1.0];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.graphTool.frame), CGRectGetHeight(self.graphTool.frame));
    [self.view addSubview:self.scrollView];
    self.scrollView.clipsToBounds = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    [self.scrollView addSubview:self.graphTool];
    [self.graphTool addSubview:self.firstBlock];
    [self.graphTool addSubview:self.pointBlock];
    
    [self.graphTool addGestureRecognizer:self.buy];
    [self.graphTool addGestureRecognizer:self.sell];
    [self.graphTool addGestureRecognizer:self.initiateShortSelling];
    [self.graphTool addGestureRecognizer:self.shortSell];
    //    [self.graphTool addSubview:self.infoLabel];
    
#pragma mark constraints
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1000]];
    
    
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    //
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    //
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200]];
    //
    //    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:300]];
}

#pragma mark methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.graphTool;
}

- (void)update {
    self.timeIndex = ((self.displaylink.timestamp - self.startTime)/0.1);
    if (self.displaylink.timestamp - self.startTime >= kTotalTime) {
        self.displaylink.paused = YES;
    }
    self.currentCoordinate = [self.graphTool.arrayOfCoordinates objectAtIndex:self.timeIndex];
    self.currentPrice = [(self.currentCoordinate.price)floatValue];
//    NSLog(@"Time:%d, %f, $%0.2f" ,self.timeIndex, self.displaylink.timestamp - self.startTime, self.currentPrice);
}

- (void)buyAction:(UITapGestureRecognizer *)sender {
    self.boughtPrice = self.currentPrice;
    NSLog(@"%f, %d, %f, Bought At: $%f", CACurrentMediaTime() - self.startTime, self.timeIndex, self.displaylink.timestamp - self.startTime, self.currentPrice);
    
    self.buy.enabled = NO;
    self.sell.enabled = YES;
    self.infoLabel.text = [NSString stringWithFormat:@"Bought at Time%f\nPrice: $0.2%f", CACurrentMediaTime() - self.startTime, self.currentPrice];
    self.infoLabel.alpha = 0.3;
    [UIView animateWithDuration:kUITransitionTime animations:^{
        self.infoLabel.alpha = 1.0;
    }];
}
- (void)sellAction:(UITapGestureRecognizer *)sender {
    self.netGainLoss =  self.boughtPrice - self.currentPrice;
    
    NSLog(@"%f, %d, Sold At: $%f, Net: %0.2f", CACurrentMediaTime() - self.startTime, self.timeIndex, self.currentPrice, self.netGainLoss);
    
    self.sell.enabled = NO;
    self.buy.enabled = YES;
    
}
- (void)shortSellingActionInitiated:(UITapGestureRecognizer *)sender {
    self.shortPrice = self.currentPrice;
    
    NSLog(@"%f, %d, Short At: $%f", CACurrentMediaTime() - self.startTime, self.timeIndex, self.currentPrice);
    
    self.initiateShortSelling.enabled = NO;
    self.shortSell.enabled = YES;
    self.buy.enabled = NO;
}
- (void)shortSell:(UITapGestureRecognizer *)sender {
    self.netGainLoss = -(self.shortPrice - self.currentPrice);
    self.initiateShortSelling.enabled = YES;
    
    NSLog(@"%f, %d, Shorted At: $%f, Net: %0.2f", CACurrentMediaTime() - self.startTime, self.timeIndex, self.currentPrice, self.netGainLoss);
    
    self.shortSell.enabled = NO;
    self.buy.enabled = YES;
    
}

@end

