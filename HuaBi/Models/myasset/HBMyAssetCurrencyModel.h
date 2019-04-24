//
//  HBMyAssetCurrencyModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/16.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HBMyAssetCurrencyModel : NSObject

@property (nonatomic, copy) NSString *currency_id;
@property (nonatomic, copy) NSString *currency_mark;
@property (nonatomic, copy) NSString *currency_name;
@property (nonatomic, assign) NSInteger exchange_switch;
@property (nonatomic, assign) NSInteger recharge_switch;
@property (nonatomic, assign) NSInteger release_switch;
@property (nonatomic, assign) NSInteger take_switch;
@property (nonatomic, assign) NSInteger release_switch_award;

- (BOOL)canExchange;

- (BOOL)canRecharge;

- (BOOL)canRelease;

- (BOOL)canTake;

- (BOOL)canReleaseOfAward;

@end


