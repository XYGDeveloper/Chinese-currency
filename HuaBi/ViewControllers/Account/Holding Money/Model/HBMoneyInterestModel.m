//
//  HBMoneyInterestModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMoneyInterestModel.h"

@interface HBMoneyInterestSettingModel ()

@property (nonatomic, copy, readwrite) NSString *rateOfPrecent;

@end

@implementation HBMoneyInterestSettingModel

- (NSString *)name {
    return [NSString stringWithFormat:@"%@ %@", self.months ?: @"--", kLocat(@"Money Interest Months")];
}

- (NSString *)rateOfPrecent {
    if (!_rateOfPrecent) {
        _rateOfPrecent = [NSString stringWithFormat:@"%@%%", self.rate ?: @"--"];
    }
    return _rateOfPrecent;
}

- (NSString *)errorMessageWithCheckTransferNumber:(NSString *)number {
    
    NSString *result = nil;
    double d = [number doubleValue];
    BOOL lessThanMin = (self.min_num != 0 && d < self.min_num);
    BOOL greaterThanMax = (self.max_num != 0 && d > self.max_num);
    if (lessThanMin ) {
        result = [NSString stringWithFormat:@"%@%@", kLocat(@"Money Interest Not less than"), @(self.min_num)];
    } else if (greaterThanMax) {
        result = [NSString stringWithFormat:@"%@%@", kLocat(@"Money Interest Not greater than"), @(self.max_num)];
    }
    
    return result;
}

@end

@interface HBMoneyInterestModel ()

@property (nonatomic, copy, readwrite) NSString *numAndCurrency;

@end

@implementation HBMoneyInterestModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"setting" : @"HBMoneyInterestSettingModel",
             };
}

- (void)setSetting:(NSArray<HBMoneyInterestSettingModel *> *)setting {
    _setting = setting;
    [setting enumerateObjectsUsingBlock:^(HBMoneyInterestSettingModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.interestModel = self;
    }];
}

- (NSString *)numAndCurrency {
    if (!_numAndCurrency) {
        _numAndCurrency = [NSString stringWithFormat:@"%@ %@", self.user_num ?: @"--", self.currency_name ?: @""];
    }
    
    return _numAndCurrency;
}

- (BOOL)isEqual:(id)object {
    if (!self.currency_id || !object || ![object isKindOfClass:[HBMoneyInterestModel class]]) {
        return NO;
    }
    
    HBMoneyInterestModel *model = object;
    if ([self.currency_id isEqualToString:model.currency_id]) {
        return YES;
    }
    
    return NO;
}

@end
