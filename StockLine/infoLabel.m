//
//  infoLabel.m
//  StockLine
//
//  Created by Li Pan on 2016-02-09.
//  Copyright © 2016 Li Pan. All rights reserved.
//

#import "infoLabel.h"

@implementation infoLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont systemFontOfSize:14];
        self.shadowColor = [UIColor colorWithWhite:1 alpha:0.1];
        self.shadowOffset = CGSizeMake(1,1);
        self.textColor = [UIColor colorWithRed:(76.0f/255.0f) green:(86.0f/255.0f) blue:(108.0f/255.0f) alpha:1.0f];
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
