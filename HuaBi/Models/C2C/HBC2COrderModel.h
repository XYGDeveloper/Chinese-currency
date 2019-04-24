//
//  HBC2COrderModel.h
//  HuaBi
//
//  Created by XI YANGUI on 2018/10/25.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface help_centerModel : NSObject
@property (nonatomic,copy)NSString *tip_title;
@property (nonatomic,copy)NSString *tip_1;
@property (nonatomic,copy)NSString *tip_2;
@property (nonatomic,copy)NSString *tip_3;
@property (nonatomic,copy)NSString *tip_4;
@property (nonatomic,copy)NSString *tip_5;
@property (nonatomic,copy)NSString *tip_6;

@end

@interface pay_infoModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *bankname;
@property (nonatomic,copy)NSString *truename;
@property (nonatomic,copy)NSString *bankadd;
@property (nonatomic,copy)NSString *bankcard;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *add_time;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *pay_type;
@property (nonatomic,copy)NSString *money;
@property (nonatomic,copy)NSString *order_sn;
@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *qrcode;
@property (nonatomic,copy)NSString *type;
@end

@interface _pay_infoModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *qrcode;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *add_time;
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *pay_type;
@property (nonatomic,copy)NSString *money;
@property (nonatomic,copy)NSString *order_sn;

@end

@interface HBC2COrderModel : NSObject
@property (nonatomic,strong)_pay_infoModel *_pay_info;
@property (nonatomic,strong)pay_infoModel *pay_info;
@property (nonatomic,strong)help_centerModel *help_center;

@end

