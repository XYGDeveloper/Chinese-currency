//
//  HBSubscribeRecordModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBSubscribeRecordModel.h"

@interface HBSubscribeRecordModel ()

@property (nonatomic, copy, readwrite) NSString *numAndCurrencyName;
@property (nonatomic, copy, readwrite) NSString *countAndBuyName;

@end

@implementation HBSubscribeRecordModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"ID" : @"id" };
}

- (NSString *)numAndCurrencyName {
    if (!_numAndCurrencyName) {
        _numAndCurrencyName = [NSString stringWithFormat:@"%@ %@", self.num ?: @"--", self.currency_name];
    }
    
    return _numAndCurrencyName;
}

- (NSString *)countAndBuyName {
    if (!_countAndBuyName) {
        _countAndBuyName = [NSString stringWithFormat:@"%@ %@", self.count ?: @"--", self.buy_name];
    }
    
    return _countAndBuyName;
}

- (BOOL)canShow {
    return self.is_forzen == 0;
}

@end
