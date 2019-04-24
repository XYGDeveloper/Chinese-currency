//
//  HBSubscribeModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBSubscribeModel.h"

@interface HBSubscribeModel ()

@property (nonatomic, copy, readwrite)NSString *statusString;
@property (nonatomic, strong, readwrite) UIColor *statusColor;
@property (nonatomic, copy, readwrite) NSString *priceAndCurrency;
@property (nonatomic, copy, readwrite) NSString *blAndPrecent;

@end

@implementation HBSubscribeModel

#pragma mark -

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"ID" : @"id" };
}

#pragma mark - Getters


- (NSString *)statusString {
 
    if (!_statusString) {
        switch (self.status) {
            case HBSubscribeModelStatusComingSoon:
                _statusString = kLocat(@"Subscription Coming soon");
                break;
              
            case HBSubscribeModelStatusCrowdfunding:
                _statusString = kLocat(@"Subscription Subscribe");
                break;
                
            case HBSubscribeModelStatusDone:
                _statusString = kLocat(@"Subscription End");
                break;
                
            case HBSubscribeModelStatusCancel:
                _statusString = kLocat(@"Subscription Cancel");
                break;
        }
    }
    
    
    
    return _statusString;
}

- (UIColor *)statusColor {
    if (!_statusColor) {
        
    }
    switch (self.status) {
        case HBSubscribeModelStatusCrowdfunding:
            _statusColor = kColorFromStr(@"#4173C8");
            break;
        default:
            _statusColor = kColorFromStr(@"#CCCCCC");
            break;
    }
    return _statusColor;
}

- (NSString *)priceAndCurrency {
    if (!_priceAndCurrency) {
        _priceAndCurrency = [NSString stringWithFormat:@"%@ %@", self.price ?: @"--", self.buy_name];
    }
    
    return _priceAndCurrency;
}

- (NSString *)blAndPrecent {
    if (!_blAndPrecent) {
        _blAndPrecent = [NSString stringWithFormat:@"%@%%", self.bl ?: @"--"];
    }
    
    return _blAndPrecent;
}

@end
