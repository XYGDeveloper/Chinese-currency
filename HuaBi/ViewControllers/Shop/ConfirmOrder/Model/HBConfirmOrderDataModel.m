//
//  HBConfirmOrderDataModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/10.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBConfirmOrderDataModel.h"

@implementation HBStoreGoodsList

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"store_goods_list" : @"HBShopGoodModel",
             };
}

@end

@implementation HBConfirmOrderDataModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"currency" : @"HBConfirmOrderCurrencyModel",
             @"store_cart_list" : @"HBStoreGoodsList",
             };
}

- (NSArray<HBShopGoodModel *> *)goodsModels {
    NSMutableArray *tmp = @[].mutableCopy;
    [self.store_cart_list enumerateObjectsUsingBlock:^(HBStoreGoodsList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.store_goods_list.count > 0) {
            [tmp addObjectsFromArray:obj.store_goods_list];
        }
    }];
    
    return tmp.copy;
}

@end
