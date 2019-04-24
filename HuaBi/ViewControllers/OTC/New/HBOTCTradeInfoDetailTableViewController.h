//
//  HBOTCOrderStateTableViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/14.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const HBOTCTradeInfoDetailTableViewControllerNeedRefreshKey;
@interface HBOTCTradeInfoDetailTableViewController : HBBaseTableViewController

+ (instancetype)fromStoryboard;

@property (nonatomic, copy) NSString *tradeID;//交易ID

@end

NS_ASSUME_NONNULL_END
