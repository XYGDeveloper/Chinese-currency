//
//  HBShopCartModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/8.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBShopCartModel : NSObject

@property (nonatomic ,copy)NSString * cart_id;
@property (nonatomic ,copy)NSString * goods_spec_id;
@property (nonatomic ,copy)NSString * goods_name;
@property (nonatomic ,copy)NSString * goods_id;
@property (nonatomic ,copy)NSString * goods_thumb;
@property (nonatomic ,copy)NSString * shop_price;
@property (nonatomic ,copy)NSString * price_kok;
@property (nonatomic ,copy)NSString * goods_number;
@property (nonatomic ,assign) BOOL isSelected;

- (NSString *)caculateTotalMoney;

+ (NSString *)caculateTotalMoneyWithModels:(NSArray<HBShopCartModel *> *)models;

+ (NSString *)getParameterOfCartIDsForModels:(NSArray<HBShopCartModel *> *)models;

@end

NS_ASSUME_NONNULL_END
