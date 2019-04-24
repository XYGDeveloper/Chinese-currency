//
//  C2cModel.h
//  YJOTC
//
//  Created by XI YANGUI on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface c2c_configModel : NSObject

@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *currency_id;
@property (nonatomic,copy)NSString *min_volume;
@property (nonatomic,copy)NSString *max_volume;
@property (nonatomic,copy)NSString *buy_price;
@property (nonatomic,copy)NSString *sell_price;
@property (nonatomic,copy)NSString *c2c_introduc;
@property (nonatomic,copy)NSString *currency_mark;
@property (nonatomic,copy)NSString *user_forzen_num;
@property (nonatomic,copy)NSString *user_num;

@end

@interface order_sellModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *order_sn;
@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *currency_id;
@property (nonatomic,copy)NSString *number;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *money;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *add_time;
@property (nonatomic,copy)NSString *admin_time;
@property (nonatomic,copy)NSString *pay_type;
@property (nonatomic,copy)NSString *pay_id;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *currency_mark;

@end

@interface order_buyModel : NSObject

@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *order_sn;
@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *currency_id;
@property (nonatomic,copy)NSString *currency_mark;
@property (nonatomic,copy)NSString *number;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *money;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *add_time;
@property (nonatomic,copy)NSString *admin_time;
@property (nonatomic,copy)NSString *pay_type;
@property (nonatomic,copy)NSString *pay_id;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *phone;

@end

@interface C2cModel : NSObject

@property (nonatomic,strong)NSArray<c2c_configModel *> *c2c_config_all;

@property (nonatomic,strong)NSArray *order_sell;

@property (nonatomic,strong)NSArray *order_buy;

@end
