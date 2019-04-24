//
//  FinModel.h
//  YJOTC
//
//  Created by l on 2018/10/10.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FinModel : NSObject

/**
 ** id              日志id
 ** member_id       会员id
 ** currency_id     币种id
 ** currency_field  帐户类型  1可用num 2冻结frozen 3锁仓lock 4互转exchange 5真实real
 ** amount          金额
 ** current         当前金额
 ** result          结果金额
 ** operation       增加或减少
 ** type            变动类型  0后台操作 10:充提币 20:币币交易 30:OTC 40:C2C 51:币币交易手续费 52:提币手续费 53:C2C手续费 60:手续费分润 71:注册奖励 72:推荐奖 73:领导奖 80:兑换 91:锁仓 92:锁仓赠送 93:释放
 ** serial_no       流水号
 ** ralation_id     关联id
 ** remark          备注
 ** create_time     日志时间
 */
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *currency_id;
@property (nonatomic,copy)NSString *currency_field;//currency_field_text
@property (nonatomic,copy)NSString *currency_field_text;
@property (nonatomic,copy)NSString *amount;
@property (nonatomic,copy)NSString *current;
@property (nonatomic,copy)NSString *result;
@property (nonatomic,copy)NSString *operation;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *serial_no;
@property (nonatomic,copy)NSString *ralation_id;
@property (nonatomic,copy)NSString *remark;
@property (nonatomic,copy)NSString *remark_text;
@property (nonatomic,copy)NSString *create_time;
@property (nonatomic,copy)NSString *type_text;

@end

NS_ASSUME_NONNULL_END
