//
//  C2cModel.m
//  YJOTC
//
//  Created by XI YANGUI on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "C2cModel.h"

@implementation order_sellModel

@end

@implementation order_buyModel

@end

@implementation c2c_configModel

@end

@implementation C2cModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"order_buy" : @"order_buyModel",
             @"order_sell" : @"order_sellModel",
             @"c2c_config_all" : @"c2c_configModel",
             };
}

@end
