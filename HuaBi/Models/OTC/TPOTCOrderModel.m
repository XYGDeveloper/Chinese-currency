//
//  TPOTCOrderModel.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCOrderModel.h"

@implementation TPOTCOrderModel


+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"currencyName" :@"currency_name"};
}

- (BOOL)isTypeOfBuy {
    return [self.type isEqualToString:@"sell"];
}


@end
