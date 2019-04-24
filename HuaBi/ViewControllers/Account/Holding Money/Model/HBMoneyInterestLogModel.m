//
//  HBMoneyInterestLogModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/4.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMoneyInterestLogModel.h"

@interface HBMoneyInterestLogModel ()

@property (nonatomic ,copy, readwrite) NSString *statusString;
@property (nonatomic ,strong, readwrite) UIColor *statusColor;
@property (nonatomic, copy, readwrite) NSString *rateOfPrecent;
@property (nonatomic, copy, readwrite) NSString *numAndCurrency;

@end

@implementation HBMoneyInterestLogModel

- (NSString *)statusString {
    if (!_statusString) {
        switch (self.status) {
            case 0:
                _statusString = kLocat(@"Money Interest Deposit Operation direction in");
                break;
            case 1:
                _statusString = kLocat(@"Money Interest Deposit Operation direction out");
                break;
            default:
                break;
        }
    }
    return _statusString;
}

- (UIColor *)statusColor {
    if (!_statusColor) {
        switch (self.status) {
            case 0:
                _statusColor = kGreenColor;
                break;
            case 1:
                _statusColor = kOrangeColor;
                break;
            default:
                break;
        }
    }
    return _statusColor;
}

- (NSString *)rateOfPrecent {
    if (!_rateOfPrecent) {
        _rateOfPrecent = [NSString stringWithFormat:@"%@%%", self.rate ?: @"--"];
    }
    return _rateOfPrecent;
}

- (NSString *)numAndCurrency {
    if (!_numAndCurrency) {
        _numAndCurrency = [NSString stringWithFormat:@"%@ %@", self.num ?: @"--", self.currency_name ?: @""];
    }
    
    return _numAndCurrency;
}


@end
