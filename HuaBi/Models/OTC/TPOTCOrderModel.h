//
//  TPOTCOrderModel.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPOTCOrderModel : NSObject

@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * orders_id;
@property(nonatomic,copy)NSString * member_id;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,copy)NSString * num;
@property(nonatomic,copy)NSString * min_money;
@property(nonatomic,copy)NSString * max_money;
@property(nonatomic,copy)NSString * head;
@property(nonatomic,copy)NSString * email;
@property(nonatomic,strong)NSArray * money_type;
@property(nonatomic,copy)NSString * trade_allnum;
@property(nonatomic,copy)NSString * evaluate_num;
@property(nonatomic,copy)NSString * trust_num;
@property(nonatomic,copy)NSString * avail;
@property(nonatomic,copy)NSString * money;
@property(nonatomic,copy)NSString * currencyName;
@property(nonatomic,copy)NSString * repeal_time;
@property(nonatomic,copy)NSString * order_message;
@property(nonatomic,copy)NSString * currency_logo;
@property(nonatomic,copy)NSString * trade_num;
@property(nonatomic,copy)NSString * name;

@property(nonatomic,copy)NSString * add_time;

- (BOOL)isTypeOfBuy;



@end
