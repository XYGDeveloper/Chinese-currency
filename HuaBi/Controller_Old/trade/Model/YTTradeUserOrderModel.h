//
//  YTTradeUserOrderModel.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTTradeUserOrderModel : NSObject

@property (nonatomic ,copy)NSString * orders_id;
@property (nonatomic ,copy)NSString * member_id;
@property (nonatomic ,copy)NSString * currency_id;
@property (nonatomic ,copy)NSString * currency_trade_id;
@property (nonatomic ,copy)NSString * price;
@property (nonatomic ,copy)NSString * num;
@property (nonatomic ,copy)NSString * trade_num;
@property (nonatomic ,copy)NSString * fee;
@property (nonatomic ,copy)NSString * type;
@property (nonatomic ,copy)NSString * add_time;
@property (nonatomic ,copy)NSString * trade_time;
@property (nonatomic ,copy)NSString * status;
@property (nonatomic ,assign)NSInteger  bili;
@property (nonatomic ,copy)NSString * cardinal_number;
@property (nonatomic ,copy)NSString * type_name;
@property (nonatomic ,copy)NSString * price_usd;

- (UIColor *)typeColor;

@end

NS_ASSUME_NONNULL_END
