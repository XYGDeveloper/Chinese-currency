//
//  MyAssetModel.h
//  YJOTC
//
//  Created by l on 2018/9/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface current_userModel : NSObject
@property (nonatomic,copy)NSString *cu_id;
@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *currency_id;
@property (nonatomic,copy)NSString *forzen_num;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *chongzhi_url;
@property (nonatomic,copy)NSString *num_award;
@property (nonatomic,copy)NSString *sum_award;
@property (nonatomic,copy)NSString *publickey;
@property (nonatomic,copy)NSString *secret;
@property (nonatomic,copy)NSString *address_pic;
@property (nonatomic,copy)NSString *lock_num;
@property (nonatomic,copy)NSString *count;
@property (nonatomic,copy)NSString *currency_name;
@property (nonatomic,copy)NSString *currency_mark;
@property (nonatomic,copy)NSString *trade_fee;
@property (nonatomic,copy)NSString *red_packets;
@property (nonatomic,copy)NSString *num;
@property (nonatomic,copy)NSString *sum;
@property (nonatomic,copy)NSString *exchange_num;

@property (nonatomic, assign) NSInteger exchange_switch;
@property (nonatomic, assign) NSInteger recharge_switch;
@property (nonatomic, assign) NSInteger release_switch;
@property (nonatomic, assign) NSInteger take_switch;
@property (nonatomic, assign) NSInteger release_switch_award;//only for KOK

- (BOOL)shouldShowTips;

- (BOOL)canExchange;

- (BOOL)canRecharge;

- (BOOL)canRelease;

- (BOOL)canTake;

- (NSString *)tipsMessage;

@end

@interface sumModel : NSObject
@property (nonatomic,copy)NSString *idc;
@property (nonatomic,copy)NSString *cny;
@property (nonatomic,copy)NSString *usd;
@property (nonatomic,copy,readonly)NSString *currentCurrencyPrice;
@end

@interface u_infoModel : NSObject
@property (nonatomic,copy)NSString *rmb;
@property (nonatomic,copy)NSString *forzen_rmb;
@end

@interface MyAssetModel : NSObject
@property (nonatomic,copy)NSString *allmoneys;
@property (nonatomic,strong)sumModel *sum;
@property (nonatomic,strong)NSArray *currency_user;
@property (nonatomic,strong)u_infoModel *u_info;

@end

