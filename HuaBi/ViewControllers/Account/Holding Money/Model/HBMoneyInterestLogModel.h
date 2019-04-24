//
//  HBMoneyInterestLogModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/4.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface HBMoneyInterestLogModel : NSObject

@property (nonatomic ,copy)NSString * currency_id;
@property (nonatomic ,copy)NSString * num;
@property (nonatomic ,copy)NSString * months;
@property (nonatomic ,copy)NSString * days;
@property (nonatomic ,copy)NSString * day_num;
@property (nonatomic ,copy)NSString * rate;

/**
 操作方向 0定存转入 1到期转出
 */
@property (nonatomic ,assign) NSInteger status;


@property (nonatomic ,copy)NSString * add_time;
@property (nonatomic ,copy)NSString * end_time;
@property (nonatomic ,copy)NSString * currency_name;
@property (nonatomic ,copy)NSString * add_time2;
@property (nonatomic ,copy)NSString * end_time2;

@property (nonatomic ,copy, readonly) NSString *statusString;
@property (nonatomic ,strong, readonly) UIColor *statusColor;
@property (nonatomic, copy, readonly) NSString *rateOfPrecent;
@property (nonatomic, copy, readonly) NSString *numAndCurrency;
@end

NS_ASSUME_NONNULL_END
