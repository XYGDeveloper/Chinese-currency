//
//  HBConfirmOrderCurrencyModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/10.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBConfirmOrderCurrencyModel : NSObject

@property (nonatomic ,copy)NSString * currency_id;
@property (nonatomic ,copy)NSString * currency_name;
@property (nonatomic ,copy)NSString * amount;
@property (nonatomic ,copy)NSString * balance;

@end

NS_ASSUME_NONNULL_END
