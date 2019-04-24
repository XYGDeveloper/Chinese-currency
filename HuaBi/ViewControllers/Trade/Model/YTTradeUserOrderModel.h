//
//  YTTradeUserOrderModel.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 交易状态

 - YTTradeUserOrderModelStatusCancel: 撤单
 - YTTradeUserOrderModelStatusPending: 挂单
 - YTTradeUserOrderModelStatusDoneOfPart: 部分成交
 - YTTradeUserOrderModelStatusDone: 成交
 */
typedef NS_ENUM(NSInteger, YTTradeUserOrderModelStatus) {
    YTTradeUserOrderModelStatusCancel = -1,
    YTTradeUserOrderModelStatusPending = 0,
    YTTradeUserOrderModelStatusDoneOfPart = 1,
    YTTradeUserOrderModelStatusDone = 2,
};

@interface YTTradeUserOrderModel : NSObject

@property (nonatomic ,copy)NSString * orders_id;
@property (nonatomic ,copy)NSString * member_id;
@property (nonatomic ,copy)NSString * currency_id;
@property (nonatomic ,copy)NSString * currency_trade_id;
@property (nonatomic ,copy)NSString * price;
@property (nonatomic ,copy)NSString * num;
@property (nonatomic ,copy)NSString * trade_num;
@property (nonatomic ,copy)NSString * fee;
@property (nonatomic ,copy)NSString * totalfee;
@property (nonatomic ,copy)NSString * type;
@property (nonatomic ,copy)NSString * add_time;
@property (nonatomic ,copy)NSString * trade_time;
@property (nonatomic ,assign)YTTradeUserOrderModelStatus status;
@property (nonatomic ,assign)NSInteger  bili;
@property (nonatomic ,copy)NSString * cardinal_number;
@property (nonatomic ,copy)NSString * type_name;
@property (nonatomic ,copy)NSString * price_usd;//
@property (nonatomic ,copy)NSString * totalMeney;
@property (nonatomic ,copy)NSString * avgcPrice;
@property (nonatomic ,copy)NSString * totalNum;//
@property (nonatomic ,copy)NSString * currenc_mark;
@property (nonatomic ,copy)NSString * trade_currency_mark;

@property (nonatomic ,copy, readonly) NSString *statusString;
@property (nonatomic ,copy, readonly) NSString *comMarkName;

- (BOOL)isDone;

- (UIColor *)typeColor;

@end

NS_ASSUME_NONNULL_END
