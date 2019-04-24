//
//  PayModel.m
//  YJOTC
//
//  Created by l on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "PayModel.h"


@implementation AlipayModel

@end

@implementation WechatModel

@end

@implementation bankModel

@end

@implementation PayModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"alipay" : @"AlipayModel",
             @"wechat" : @"WechatModel",
             @"yinhang" : @"bankModel",
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"yinhang": @"bank"};
}
@end
