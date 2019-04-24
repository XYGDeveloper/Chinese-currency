//
//  YTTradeIndexModel.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBTradeLimitTimeModel.h"

NS_ASSUME_NONNULL_BEGIN
#pragma mark - buy_list -

@interface Buy_list: NSObject
@property (nonatomic ,copy)NSString * num;
@property (nonatomic ,copy)NSString * trade_num;
@property (nonatomic ,copy)NSString * price;
@property (nonatomic ,copy)NSString * type;
@property (nonatomic ,copy)NSString * status;
@property (nonatomic ,assign)CGFloat  bili;
@property (nonatomic ,assign)CGFloat  new_bili;
@property (nonatomic ,copy)NSString * cardinal_number;
@property (nonatomic, assign) BOOL isHolder;
@end

#pragma mark - trade_list -

@interface Trade_list: NSObject
@property (nonatomic ,copy)NSString * orders_id;
@property (nonatomic ,copy)NSString * currency_id;
@property (nonatomic ,copy)NSString * price;
@property (nonatomic ,copy)NSString * num;
@property (nonatomic ,copy)NSString * trade_num;
@property (nonatomic ,copy)NSString * status;
@property (nonatomic ,copy)NSString * add_time;
@property (nonatomic ,copy)NSString * trade_time;
@property (nonatomic ,copy)NSString * type;
- (UIColor *)typeColor;

@end

#pragma mark - YTTradeIndexModel -
@class ListModel;
@interface YTTradeIndexModel: NSObject

@property (nonatomic ,copy)NSArray<Buy_list *> * sell_list;
@property (nonatomic ,copy)NSArray<Buy_list *> * buy_list;
@property (nonatomic ,copy)NSArray<Trade_list *> * trade_list;
@property (nonatomic, strong) HBTradeLimitTimeModel *currency_limit;//newbuyprice
@property (nonatomic, strong) ListModel *newbuyprice;
@end

NS_ASSUME_NONNULL_END
