//
//  TPOTCAppealViewController.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

@interface TPOTCAppealViewController : YJBaseViewController

@property(nonatomic,copy)NSString * trade_id;
/**  买家申诉  */
@property(nonatomic,assign)BOOL isBuy;

@property(nonatomic,strong)TPOTCTradeListModel *model;

@property (nonatomic, assign) NSInteger appealWait;
@property (nonatomic, assign) NSInteger appeal_minute;


@end
