//
//  HBShopCartModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/8.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBShopCartModel.h"
#import "NSString+Operation.h"

@implementation HBShopCartModel

- (NSString *)caculateTotalMoney {
    
    return [self.price_kok resultByMultiplyingByNumber:self.goods_number];
}

+ (NSString *)caculateTotalMoneyWithModels:(NSArray<HBShopCartModel *> *)models {
    
    __block NSString *sum = @"0";
    [models enumerateObjectsUsingBlock:^(HBShopCartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        sum = [sum resultByAddingByNumber:[obj caculateTotalMoney]];
    }];
    return sum;
}

+ (NSString *)getParameterOfCartIDsForModels:(NSArray<HBShopCartModel *> *)models {
    
    NSMutableArray *cartIDs = @[].mutableCopy;
    [models enumerateObjectsUsingBlock:^(HBShopCartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *value = [NSString stringWithFormat:@"%@|%@", obj.cart_id, obj.goods_number];
        [cartIDs addObject:value];
    }];
    
    NSString *result = [cartIDs componentsJoinedByString:@","];
    return result;
}

@end
