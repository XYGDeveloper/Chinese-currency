//
//  HBCurrencyTypeModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/21.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 计价方式 Model
 */
@interface HBPricingMethodModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy, readonly) NSString *displayName;
@property (nonatomic, copy) NSString *currencyString;
@property (nonatomic, assign, setter = setSelected:) BOOL isSelected;

+ (NSArray<HBPricingMethodModel *> *)allModels;

@end

NS_ASSUME_NONNULL_END
