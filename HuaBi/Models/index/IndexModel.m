//
//  IndexModel.m
//  YJOTC
//
//  Created by l on 2018/9/13.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "IndexModel.h"


@implementation articleModel

@end



@implementation configModel

@end




@implementation itemModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"price": @"new_price",
             @"price_usd": @"new_price_usd",
             @"price_status": @"new_price_status",
             };
}
@end

@implementation flashModel

@end


@implementation IndexModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"currency" : @"itemModel",
             @"flash" : @"flashModel",
             };
}

@end
