//
//  DrawingTool.m
//  StockLine
//
//  Created by Li Pan on 2016-02-08.
//  Copyright © 2016 Li Pan. All rights reserved.
//

#import "GraphTool.h"
#import "Stock.h"
#import "Coordinate.h"

@interface GraphTool ()

@property (nonatomic, assign) CGContextRef context;
@property (nonatomic, strong) Stock *stock;
@property (nonatomic, strong) NSMutableDictionary *dictOfCoordinates;



@end

@implementation GraphTool

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.stock = [[Stock alloc] initWithVolatility:10];
        self.stock.stockPrice = 1000;
        self.startingPrice = self.stock.stockPrice;
        _dictOfCoordinates = [[NSMutableDictionary alloc]init];
        _arrayOfCoordinates = [[NSMutableArray alloc]init];

    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(self.context);
    CGContextMoveToPoint(self.context, self.stock.timeVariable, self.stock.stockPrice);
    NSLog(@"Standard Deviation: %0.2f", self.stock.standardDeviation);
    NSLog(@"Volatility: %d", self.stock.volatility);
    NSLog(@"Company State: %0.2f", self.stock.companyState);
    NSLog(@"Value: %0.2f", self.stock.value);
    NSLog(@"Skewness %d", self.stock.skewness);
    NSLog(@"Distribution: 1sd%d, 2sd%d", self.stock.distribution1sd, self.stock.distribution2sd);
    
    for (int x; x < 5000; x += 5) {
        int f = arc4random_uniform(99);
        float distribution = (float) f;
        
        if (distribution <= self.stock.distribution1sd) {
            [self.stock simulateStockSkewnessWithStandardDeviation:1];
        }
        else if (distribution > self.stock.distribution1sd && distribution <= self.stock.distribution2sd) {
            [self.stock simulateStockSkewnessWithStandardDeviation:2];
        }
        else if (distribution > self.stock.distribution2sd && distribution < 100) {
            [self.stock simulateStockSkewnessWithStandardDeviation:3];
        }
        else {
            int randomeWalk = arc4random_uniform(2);
            if (randomeWalk == 1) {
                [self.stock simulateStockSkewnessWithStandardDeviation:1];
            }
        }
        self.stock.timeVariable = x;
        CGContextAddLineToPoint(self.context, self.stock.timeVariable, self.stock.stockPrice/2);

        [self.arrayOfCoordinates addObject:[[Coordinate alloc] initWithPrice:@(self.stock.stockPrice)]];
        
        //NSLog(@"$%0.2f", self.stock.stockPrice/200);
        //NSLog(@"count: %lu", (unsigned long)self.arrayOfCoordinates.count);
        //NSLog(@"%@", self.stock.arrayOfCoordinates.description);
        
    }
    CGContextAddLineToPoint(self.context, CGRectGetMaxX(rect)+10, CGRectGetHeight(rect)+10);
    CGContextAddLineToPoint(self.context, CGRectGetMinX(rect)-10, CGRectGetHeight(rect)+10);
    CGContextClosePath(self.context);
//    CGPathRef fillPath = CGContextCopyPath(self.context);
    //CGContextSetFillColorWithColor(self.context, [UIColor colorWithRed:29.0/255.0 green:82.0/255.0 blue:174.0/255.0 alpha:0.8].CGColor);
//    CGContextFillPath(self.context);
//    CGContextAddPath(self.context, fillPath);
    CGContextSetStrokeColorWithColor(self.context, [UIColor colorWithRed:255.0/255.0 green:94.0/255.0 blue:0.0/255.0 alpha:1.0].CGColor);
//    CGContextSetLineWidth(self.context, 5 * self.stock.standardDeviation);
    
    CGContextSetLineWidth(self.context, 10);
    CGContextSetLineCap(self.context, kCGLineCapRound);
    CGContextStrokePath(self.context);
}

- (void)updateStock {

        //NSLog(@"%@", self.stock.arrayOfCoordinates.description);
    
}


- (void)simulateStock {
    
}

@end
