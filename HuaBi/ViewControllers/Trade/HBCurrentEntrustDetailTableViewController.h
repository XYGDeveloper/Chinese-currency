//
//  HBCurrentEntrustTableViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/25.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class YTTradeUserOrderModel;

/**
 历史委托详情界面
 */
@interface HBCurrentEntrustDetailTableViewController : HBBaseTableViewController

@property (nonatomic, strong) YTTradeUserOrderModel *model;

+ (instancetype)fromStoryboard;

@end

NS_ASSUME_NONNULL_END
