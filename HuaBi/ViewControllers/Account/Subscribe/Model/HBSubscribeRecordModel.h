//
//  HBSubscribeRecordModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBSubscribeRecordModel : NSObject

@property (nonatomic ,copy)NSString * ID;


/**
 时间
 */
@property (nonatomic ,copy)NSString * add_time;

/**
 购买数量，冻结数量
 */
@property (nonatomic ,copy)NSString * num;


/**
 实际支付
 */
@property (nonatomic ,copy)NSString * count;//实际支付


/**
 实际币名标签
 */
@property (nonatomic ,copy)NSString * buy_name;

/**
 认购币名标签
 */
@property (nonatomic ,copy)NSString * currency_name;


@property (nonatomic ,assign)NSInteger is_forzen;//0显示释放，2不显示，1不显示

@property (nonatomic , assign)BOOL canShow;

@property (nonatomic, copy, readonly) NSString *numAndCurrencyName;
@property (nonatomic, copy, readonly) NSString *countAndBuyName;


@end

NS_ASSUME_NONNULL_END
