//
//  YTTradeIndexModel.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTTradeIndexModel.h"
#import "MJExtension.h"

@implementation YTTradeIndexModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"sell_list" : @"Buy_list",
             @"buy_list" : @"Buy_list",
             @"trade_list" : @"Trade_list",
             };
}
@end


#pragma mark - buy_list -

@implementation Buy_list

@end

#pragma mark - trade_list -

@implementation Trade_list

- (UIColor *)typeColor {
    return [self.type isEqualToString:@"sell"] ? kOrangeColor : kGreenColor;
}

@end
