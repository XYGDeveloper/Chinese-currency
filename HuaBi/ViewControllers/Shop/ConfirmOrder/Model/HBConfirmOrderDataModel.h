//
//  HBConfirmOrderDataModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/10.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HBShopGoodModel;
@interface HBStoreGoodsList : NSObject

@property (nonatomic, strong) NSArray<HBShopGoodModel *> *store_goods_list;

@end


@class HBMallAddressModel, HBConfirmOrderCurrencyModel;
@interface HBConfirmOrderDataModel : NSObject

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *kok;
@property (nonatomic, strong) HBMallAddressModel *address_info;
@property (nonatomic, strong) NSArray<HBConfirmOrderCurrencyModel *> *currency;
@property (nonatomic, strong) NSArray<HBStoreGoodsList *> *store_cart_list;

@property (nonatomic, strong) NSArray<HBShopGoodModel *> *goodsModels;
@end

