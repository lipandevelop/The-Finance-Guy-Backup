//
//  OpeningScreen.m
//  StockLine
//
//  Created by Li Pan on 2016-02-10.
//  Copyright © 2016 Li Pan. All rights reserved.
//

#import "OpeningScreen.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "ViewController.h"

@interface OpeningScreen ()
@property (nonatomic, strong) AVPlayerViewController *backgroundVideoController;

@end

@implementation OpeningScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"OpenScene" ofType:@"mp4"];
    NSURL *gif = [NSURL fileURLWithPath:filePath];
    
        UIWebView *webViewBG = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        [webViewBG loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        webViewBG.userInteractionEnabled = NO;
        [self.view addSubview:webViewBG];
    
//    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:video]];
//    player.view.frame = CGRectMake(184, 200, 400, 300);
//    [self.view addSubview:player.view];
//    [player play];
    
    //    UIView *filter = [[UIView alloc] initWithFrame:self.view.frame];
    //    filter.backgroundColor = [UIColor blackColor];
    //    filter.alpha = 0.05;
    //    [self.view addSubview:filter];
    
//    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 100)];
//    welcomeLabel.text = @"WELCOME";
//    welcomeLabel.textColor = [UIColor whiteColor];
//    welcomeLabel.font = [UIFont systemFontOfSize:50];
//    welcomeLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:welcomeLabel];
    
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 360, 240, 40)];
    playButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    playButton.layer.borderWidth = 2.0;
    playButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [playButton setTintColor:[UIColor whiteColor]];
    [playButton setTitle:@"PLAY" forState:UIControlStateNormal];
    [self.view addSubview:playButton];
    
//    UIButton *signUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 420, 240, 40)];
//    signUpBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
//    signUpBtn.layer.borderWidth = 2.0f;
//    signUpBtn.titleLabel.font = [UIFont systemFontOfSize:24];
//    [signUpBtn setTintColor:[UIColor whiteColor]];
//    [signUpBtn setTitle:@"Sign Up" forState:UIControlStateNormal];
//    [self.view addSubview:signUpBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)presentGameController {
    ViewController *viewController = [[ViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
