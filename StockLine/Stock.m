//
//  Stock.m
//  StockLine
//
//  Created by Li Pan on 2016-02-08.
//  Copyright © 2016 Li Pan. All rights reserved.
//

#import "Stock.h"

@interface Stock ()

@end

@implementation Stock

const int kNORMAL_DISTRIBUTION_1SD = 67;
const int kNORMAL_DISTRIBUTION_2SD = 95;

- (instancetype) initWithVolatility: (int)volatility {
    self = [super init];
    if (self) {
        _volatility = volatility;
        int r = arc4random_uniform(99);
        if ( r > 79 && r < 100) {
            _distribution1sd = 30 + arc4random() % (100 - 30);
            _distribution2sd = 100 - (arc4random_uniform(10)+1);
        }         else {
            _distribution1sd = kNORMAL_DISTRIBUTION_1SD;
            _distribution2sd = kNORMAL_DISTRIBUTION_1SD;
        }
        float companyStatePositive = (0 + arc4random() % (10))/100.0;
        _companyState = arc4random_uniform(2) == 1 ? 0 + companyStatePositive : 0 - companyStatePositive;
        _skewness = 7 - arc4random() % (4);
        _standardDeviation = (0.0 + arc4random() % (30))/100.0 * self.volatility;
        _value = self.companyState * self.standardDeviation;
    }
    return self;
}

- (void)simulateStockSkewnessWithStandardDeviation: (int)sd {
    int randomeWalk = arc4random_uniform(10);
    if (randomeWalk < self.skewness) {
        self.stockPrice += (sd * self.standardDeviation) * (1 + self.value);
    }
    else self.stockPrice -= (sd * self.standardDeviation) * (1 - self.value);
    
}

@end

