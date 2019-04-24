//
//  HBExchangeModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBExchangeModel : NSObject

@property (nonatomic ,copy)NSString * log_id;
@property (nonatomic ,copy)NSString * currency_id;
@property (nonatomic ,copy)NSString * to_currency_id;
@property (nonatomic ,copy)NSString * fee;
@property (nonatomic ,copy)NSString * ratio;
@property (nonatomic ,copy)NSString * currency_name;
@property (nonatomic ,copy)NSString * to_name;
@property (nonatomic ,copy)NSString * from_num;
@property (nonatomic ,copy)NSString * num;
@property (nonatomic ,copy)NSString * actual;
@property (nonatomic ,assign)NSInteger status;
@property (nonatomic ,copy)NSString * add_time;
@property (nonatomic ,copy)NSString * update_time;

@property (nonatomic, copy, readonly) NSString *statusString;
@property (nonatomic, strong, readonly) UIColor *statusColor;
@end

NS_ASSUME_NONNULL_END
