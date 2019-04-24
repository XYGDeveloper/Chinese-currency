//
//  HBUserDefaults.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/21.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBUserDefaults.h"

static NSString *const kCurrentCurrencyKey = @"CurrentCurrencyKey";

@implementation HBUserDefaults

+ (NSString *)getCurrentCurrency {
    NSUserDefaults *userDefatults = [NSUserDefaults standardUserDefaults];
    NSString *result = [userDefatults stringForKey:kCurrentCurrencyKey];
    if (!result) {//设置一个默认值
        result = kCNY;
        [self setCurrentCurrency:result];
    }
        
    return result;
}

+ (void)setCurrentCurrency:(NSString *)currency {
    if (!currency) {
        return;
    }
    NSUserDefaults *userDefatults = [NSUserDefaults standardUserDefaults];
    [userDefatults setObject:currency forKey:kCurrentCurrencyKey];

}

@end
