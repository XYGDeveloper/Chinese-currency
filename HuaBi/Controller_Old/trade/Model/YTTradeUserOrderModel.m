//
//  YTTradeUserOrderModel.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTTradeUserOrderModel.h"

@implementation YTTradeUserOrderModel

- (UIColor *)typeColor {
    return [self.type isEqualToString:@"sell"] ? kOrangeColor : kGreenColor;
}

@end
