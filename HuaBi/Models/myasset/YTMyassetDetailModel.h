//
//  YTMyassetDetailModel.h
//  YJOTC
//
//  Created by XI YANGUI on 2018/10/7.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface currency_Model : NSObject

@property (nonatomic,copy)NSString *currency_content;
@property (nonatomic,copy)NSString *price_auto_4;
@property (nonatomic,copy)NSString *buy_sell_record;
@property (nonatomic,copy)NSString *currency_type;
@property (nonatomic,copy)NSString *tibi_address;
@property (nonatomic,copy)NSString *num_auto_4;
@property (nonatomic,copy)NSString *num_auto_f_4;
@property (nonatomic,copy)NSString *currency_name;
@property (nonatomic,copy)NSString *num_auto_3;
@property (nonatomic,copy)NSString *cardinal_number;
@property (nonatomic,copy)NSString *action_time;
@property (nonatomic,copy)NSString *qianbao_key1;
@property (nonatomic,copy)NSString *currency_mark;
@property (nonatomic,copy)NSString *order_in_time;
@property (nonatomic,copy)NSString *num_auto_2;
@property (nonatomic,copy)NSString *num_auto_1;
@property (nonatomic,copy)NSString *num_number;
@property (nonatomic,copy)NSString *is_qu;
@property (nonatomic,copy)NSString *is_line;
@property (nonatomic,copy)NSString *rpc_url1;
@property (nonatomic,copy)NSString *currency_id;

@end

@interface curreny_userModel : NSObject
@property (nonatomic,copy)NSString *chongzhi_url;
@property (nonatomic,copy)NSString *sum_award;
@property (nonatomic,copy)NSString *lock_num;
@property (nonatomic,copy)NSString *real_num;
@property (nonatomic,copy)NSString *cu_id;
@property (nonatomic,copy)NSString *num;
@property (nonatomic,copy)NSString *currency_id;
@property (nonatomic,copy)NSString *forzen_num;
@property (nonatomic,copy)NSString *num_award;
@property (nonatomic,copy)NSString *trade_time;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *sum;

@end

@interface user_order : NSObject
@property (nonatomic,copy)NSString *orders_id;
@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *currency_id;
@property (nonatomic,copy)NSString *currency_trade_id;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *num;
@property (nonatomic,copy)NSString *trade_num;
@property (nonatomic,copy)NSString *fee;
@property (nonatomic,copy)NSString *add_time;
@property (nonatomic,copy)NSString *trade_time;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *bili;
@property (nonatomic,copy)NSString *cardinal_number;
@property (nonatomic,copy)NSString *type_name;
@property (nonatomic,copy)NSString *price_usd;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *currency_mark;
@property (nonatomic,copy)NSString *currency_name;

@end

@interface YTMyassetDetailModel : NSObject
@property (nonatomic,strong)currency_Model *currency;
@property (nonatomic,strong)NSArray *user_orders;
@property (nonatomic,strong)curreny_userModel *currency_user;
@end

