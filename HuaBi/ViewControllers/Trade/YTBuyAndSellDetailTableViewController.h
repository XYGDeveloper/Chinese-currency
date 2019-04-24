//
//  YTBuyAndSellDetailTableViewController.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBBaseTableViewController.h"

typedef void(^YTBuyAndSellDetailTableViewControllerOperateDoneBlock)(void);

@class ListModel, YTTradeIndexModel, YTMyassetDetailModel, HBTradeLimitTimeModel;

/**
 交易 子控制器
 */
@interface YTBuyAndSellDetailTableViewController : HBBaseTableViewController

+ (instancetype)buyDetailTableViewController;

+ (instancetype)sellDetailTableViewController;

+ (instancetype)fromStoryboard;

@property (nonatomic, assign) BOOL isTypeOfBuy;

@property (nonatomic, strong) ListModel *model;

@property (nonatomic, strong) YTTradeIndexModel *tradeIndexs;

@property (nonatomic, strong) YTMyassetDetailModel *assetModel;
@property (nonatomic, strong) YTMyassetDetailModel *tradeAssetModel;
@property (nonatomic, strong) HBTradeLimitTimeModel *limitTimeModel;
@property (nonatomic, copy) YTBuyAndSellDetailTableViewControllerOperateDoneBlock operateDoneBlock;

- (void)endRefresh;

- (void)tapButtonWithIsBuy:(BOOL)isbuy;

@end

