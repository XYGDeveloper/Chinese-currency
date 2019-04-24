//
//  TPOTCTradeListModel.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

//交易记录列表

@interface TPOTCTradeListModel : NSObject

@property(nonatomic,copy)NSString * add_time;
/**  0未付款 1已付款 2已取消 3已完成 4申诉  */
@property(nonatomic,copy)NSString * status;

/**
 allege_status  申诉结果 1胜诉， 0败诉， -1取 status
 */
@property(nonatomic,assign)NSInteger allege_status;
@property(nonatomic,copy)NSString * money;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,copy)NSString * num;
@property(nonatomic,copy)NSString * currency_name;
@property(nonatomic,copy)NSString * currency_id;
@property(nonatomic,copy)NSString * username;
@property(nonatomic,copy)NSString * status_txt;
@property(nonatomic,copy)NSString * trade_id;

@property(nonatomic,copy)NSString * type;



@end

