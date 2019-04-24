//
//  HBMoneyInterestWarpperModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMoneyInterestWarpperModel.h"

@implementation HBMoneyInterestInfoModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"advantage" : @"NSString",
             };
}

@end

@implementation HBMoneyInterestWarpperModel


+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"currency_setting" : @"HBMoneyInterestModel",
             };
}

@end
