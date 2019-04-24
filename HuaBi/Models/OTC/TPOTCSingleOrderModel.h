//
//  TPOTCSingleOrderModel.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/30.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPOTCSingleOrderModel : NSObject


@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * member_id;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,copy)NSString * num;
@property(nonatomic,copy)NSString * pay_number;
@property(nonatomic,copy)NSString * add_time;
@property(nonatomic,copy)NSString * status;
@property(nonatomic,copy)NSString * email;
@property(nonatomic,copy)NSString * status_txt;
@property(nonatomic,copy)NSString * currency_name;
@property(nonatomic,copy)NSString * money;
@property(nonatomic,copy)NSString * trade_id;
@property(nonatomic,copy)NSString * name;



@end

/**
 price价格
 
 num数量
 
 pay_number付款参考号
 
 add_time 时间
 
 status_txt 状态描述
 
 currency_name 货币名称
 
 email 用户名称
 
 type 类型

 status 0未付款 1已付款 2申诉中 3已完成 4已取消
 */
