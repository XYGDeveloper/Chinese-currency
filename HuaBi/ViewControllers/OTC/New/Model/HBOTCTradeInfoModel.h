//
//  HBOTCTradeInfoModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/15.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBOTCTradeBankModel.h"

NS_ASSUME_NONNULL_BEGIN

    
typedef NS_ENUM(NSInteger, HBOTCTradeInfoModelStatus) {
    HBOTCTradeInfoModelStatusNotPay,
    HBOTCTradeInfoModelStatusPaid,
    HBOTCTradeInfoModelStatusAppeal,
    HBOTCTradeInfoModelStatusDone,
    HBOTCTradeInfoModelStatusCancel,

};

@interface HBOTCTradeInfoModel : NSObject

@property (nonatomic, copy) NSString *add_time;

/**
 申诉等待总时间(分)
 */
@property (nonatomic, copy) NSString *appeal_minute;

/**
 申诉倒计时
 */
@property (nonatomic, copy) NSString *appeal_wait;
@property (nonatomic, copy) NSString *currency_id;
@property (nonatomic, copy) NSString *currency_logo;
@property (nonatomic, copy) NSString *currency_name;

/**
 购买手续费百分比
 */
@property (nonatomic, copy) NSString *currency_otc_buy_fee;
@property (nonatomic, copy) NSString *currency_otc_sell_fee;
@property (nonatomic, copy) NSString *fee;

/**
 剩余的支付时间(秒)
 */
@property (nonatomic, copy) NSString *limit_time;
@property (nonatomic, copy) NSString *member_id;

/**
 总金额
 */
@property (nonatomic, copy) NSString *money;

/**
 收付方式
 */
@property (nonatomic, copy) NSString *money_type;


/**
  数量
 */
@property (nonatomic, copy) NSString *num;

/**
 订单号
 */
@property (nonatomic, copy) NSString *only_number;

/**
 付款参考号
 */
@property (nonatomic, copy) NSString *pay_number;

/**
 卖家ID
 */
@property (nonatomic, copy) NSString *other_member;
@property (nonatomic, copy) NSString *other_trade_id;

/**
 价格
 */
@property (nonatomic, copy) NSString *price;

/**
 实际扣除(sell) 实际到账(buy)
 */
@property (nonatomic, copy) NSString *real_num;
@property (nonatomic, copy) NSString *sell_orders;
@property (nonatomic, assign) HBOTCTradeInfoModelStatus status;
@property (nonatomic, copy) NSString *status_txt;

/**
 状态描述
 */
@property (nonatomic, copy) NSString *status_txt_des;


/**
 交易额描述
 */
@property (nonatomic, copy) NSString *status_txt_type;

/**
 当前用户的购买行为：buy:买入， sell:卖出
 buy:对方为卖家, sell:对方为买家
 */
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *update_time;

/**
 用户名
 */
@property (nonatomic, copy) NSString *username;

/**
 用户已选择的银行信息
 */
@property (nonatomic, copy) NSArray *banks;

/**
 卖家支持的支付方式
 */
@property (nonatomic, strong) NSArray<HBOTCTradeBankModel *> *bank_list;


/**
 卡号
 */
@property (nonatomic, copy) NSArray *cardnum;

/**
 开户行
 */
@property (nonatomic, copy) NSArray *bname;

/**
 开户支行
 */
@property (nonatomic, copy) NSArray *inname;


/**
 备注留言
 */
@property (nonatomic, copy) NSString *order_message;


/**
 申诉结果 1胜诉 0败诉 -1 其他
 */
@property (nonatomic, assign) NSInteger allege_status;

- (UIColor *)statusColor;

- (NSString *)moneyTypeString;

- (NSString *)sellerOrBuyerString;


/**
 type 字段是否为 buy

 @return type 字段是否为 buy
 */
- (BOOL)isTypeOfBuy;

- (NSString *)moneyTypeIconString;

@end

NS_ASSUME_NONNULL_END
