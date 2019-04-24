//
//  HBConfirmOrderCurrencyModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/10.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBConfirmOrderCurrencyModel.h"

@implementation HBConfirmOrderCurrencyModel

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[HBConfirmOrderCurrencyModel class]]) {
        return NO;
    }
    HBConfirmOrderCurrencyModel *model = object;
    return [self.currency_id isEqualToString:model.currency_id];
}

@end
