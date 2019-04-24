//
//  HBExchangeCurrencysModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/19.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBExchangeCurrencyModel: NSObject

@property (nonatomic, copy)NSString * cny;
@property (nonatomic, copy)NSString * currency_id;
@property (nonatomic, copy)NSString * currency_name;
@property (nonatomic, copy)NSString * currency_logo;
@property (nonatomic, copy)NSString * num;
@property (nonatomic, copy) NSString *fee;

@end

@interface HBExchangeCurrencysModel : NSObject

@property (nonatomic ,copy)NSArray<HBExchangeCurrencyModel *> *from;
@property (nonatomic ,copy)NSArray<HBExchangeCurrencyModel *> *to;

@end

NS_ASSUME_NONNULL_END
