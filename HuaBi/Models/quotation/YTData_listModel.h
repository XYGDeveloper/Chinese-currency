//
//  YTData_listModel.h
//  YJOTC
//
//  Created by l on 2018/10/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject
@property (nonatomic,copy)NSString *H24;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *price_usd_new;
@property (nonatomic,copy)NSString *price_cny_new;
@property (nonatomic,copy, readonly)NSString *price_current_currency;

@property (nonatomic, strong) NSDecimalNumber *perOfPriceOfUsd;

@property (nonatomic,copy)NSString *H24_change;
@property (nonatomic,copy)NSString *H24_down_num;
@property (nonatomic,copy)NSString *price_status;
@property (nonatomic,copy)NSString *buy_one_price;
@property (nonatomic,copy)NSString *sell_one_price;
@property (nonatomic,copy)NSString *trade_currency_mark;
@property (nonatomic,copy)NSString *H_change24;
@property (nonatomic,copy)NSString *H_change_price24;
@property (nonatomic,copy)NSString *D_change3;
@property (nonatomic,copy)NSString *H_done_num24;
@property (nonatomic,copy)NSString *H_done_money24;
@property (nonatomic,copy)NSString *min_price;
@property (nonatomic,copy)NSString *max_price;
@property (nonatomic,copy)NSString *currency_id;
@property (nonatomic,copy)NSString *currency_name;
@property (nonatomic,copy)NSString *change_price_24;
@property (nonatomic,copy)NSString *done_num_24H;


@property (nonatomic, assign)CGFloat currency_buy_fee;
@property (nonatomic, assign)CGFloat currency_sell_fee;

@property (nonatomic,copy)NSString *currency_logo;
@property (nonatomic,copy)NSString *currency_mark;
@property (nonatomic,copy)NSString *currency_content;
@property (nonatomic,copy)NSString *currency_all_money;
@property (nonatomic,copy)NSString *currency_url;
@property (nonatomic,copy)NSString *change_24;


@property (nonatomic,copy)NSString *trade_currency_id;
@property (nonatomic,copy)NSString *is_line;
@property (nonatomic,copy)NSString *is_lock;
@property (nonatomic,copy)NSString *port_number;
@property (nonatomic,copy)NSString *port_number1;
@property (nonatomic,copy)NSString *add_time;


@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *rpc_url;
@property (nonatomic,copy)NSString *rpc_url1;
@property (nonatomic,copy)NSString *rpc_pwd;
@property (nonatomic,copy)NSString *rpc_pwd1;
@property (nonatomic,copy)NSString *rpc_user;

@property (nonatomic,copy)NSString *rpc_user1;
@property (nonatomic,copy)NSString *currency_all_tibi;
@property (nonatomic,copy)NSString *detail_url;
@property (nonatomic,copy)NSString *qianbao_url;
@property (nonatomic,copy)NSString *qianbao_key;
@property (nonatomic,copy)NSString *qianbao_key1;


@property (nonatomic,copy)NSString *is_limit;
@property (nonatomic,copy)NSString *max_limit;
@property (nonatomic,copy)NSString *min_limit;
@property (nonatomic,copy)NSString *is_time;
@property (nonatomic,copy)NSString *max_time;
@property (nonatomic,copy)NSString *min_time;

@property (nonatomic,copy)NSString *sort;
@property (nonatomic,copy)NSString *cardinal_number;
@property (nonatomic,copy)NSString *limit_in;
@property (nonatomic,copy)NSString *num_number;
@property (nonatomic,copy)NSString *tcoin_fee;
@property (nonatomic,copy)NSString *limit_repeal;


@property (nonatomic,copy)NSString *is_qu;
@property (nonatomic,copy)NSString *trade_day6;
@property (nonatomic,copy)NSString *trade_day7;
@property (nonatomic,copy)NSString *first_price;
@property (nonatomic,copy)NSString *is_chongbi;
@property (nonatomic,copy)NSString *height;


@property (nonatomic,copy)NSString *is_tibi;
@property (nonatomic,copy)NSString *is_address_check;
@property (nonatomic,copy)NSString *qianbao_address;
@property (nonatomic,copy)NSString *is_autotrade;
@property (nonatomic,copy)NSString *num_auto_1;
@property (nonatomic,copy)NSString *num_auto_2;



@property (nonatomic,copy)NSString *num_auto_3;
@property (nonatomic,copy)NSString *num_auto_4;
@property (nonatomic,copy)NSString *num_auto_5;
@property (nonatomic,copy)NSString *num_auto_6;
@property (nonatomic,copy)NSString *num_auto_7;
@property (nonatomic,copy)NSString *num_auto_8;
@property (nonatomic,copy)NSString *num_auto_9;


@property (nonatomic,copy)NSString *num_auto_f_1;
@property (nonatomic,copy)NSString *num_auto_f_2;
@property (nonatomic,copy)NSString *num_auto_f_3;
@property (nonatomic,copy)NSString *num_auto_f_4;
@property (nonatomic,copy)NSString *num_auto_f_5;
@property (nonatomic,copy)NSString *num_to_int;
@property (nonatomic,copy)NSString *price_auto_1;

@property (nonatomic,copy)NSString *price_auto_2;
@property (nonatomic,copy)NSString *price_auto_3;
@property (nonatomic,copy)NSString *price_auto_4;
@property (nonatomic,copy)NSString *price_auto_5;
@property (nonatomic,copy)NSString *price_auto_6;
@property (nonatomic,copy)NSString *price_auto_7;
@property (nonatomic,copy)NSString *price_auto_8;

@property (nonatomic,copy)NSString *price_to_int;
@property (nonatomic,copy)NSString *bs_price_num;
@property (nonatomic,copy)NSString *buy_sell_record;
@property (nonatomic,copy)NSString *bs_or;
@property (nonatomic,copy)NSString *max_times;
@property (nonatomic,copy)NSString *action_time;
@property (nonatomic,copy)NSString *trade_log;

@property (nonatomic,copy)NSString *order_in_time;
@property (nonatomic,copy)NSString *rand_order_in_time;
@property (nonatomic,copy)NSString *tibi_address;
@property (nonatomic,copy)NSString *token_address;
@property (nonatomic,copy)NSString *currency_type;


@property (nonatomic,copy)NSString *inall;
@property (nonatomic,copy)NSString *inall_symbol;

@property (nonatomic, copy, readonly) NSString *comcurrencyName;
@property (nonatomic, copy, readonly) NSString *comcurrencyName1;
@property (nonatomic, copy, readonly) NSString *originalCurrency_id;
@property (nonatomic, strong, readonly) UIColor *statusColor;
@property (nonatomic, copy, readonly) NSString *change24String;



/**
 获取 手续费因子

 @param isBuy 是否为‘买’
 @return 手续费因子，如当 currency_buy_fee = 0.1， currency_sell_fee = 0.2 时，相应返回 1.001 ， 0.008
 */
- (NSString *)getFeeFactorStringByIsBuy:(BOOL)isBuy;

- (NSString *)getBuyFeeFactorString;

- (NSString *)getSellFeeFactorString;

@end

@interface YTData_listModel : NSObject <NSCopying>
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSArray<ListModel *> *data_list;
@property (nonatomic,copy)NSString *right_name;

//- (void)sortedBy

+ (NSArray<YTData_listModel *> *)sortArray:(NSArray<YTData_listModel *> *)array sortDescriptor:(NSSortDescriptor *)sortDescriptor;

@end

