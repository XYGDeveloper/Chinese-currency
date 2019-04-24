//
//  YTBuyAndSellDetailTableViewController.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YTBuyAndSellDetailTableViewControllerOperateDoneBlock)(void);

@class ListModel, YTTradeIndexModel, YTTradeModel;
@interface YTBuyAndSellDetailTableViewController : UITableViewController

+ (instancetype)buyDetailTableViewController;

+ (instancetype)sellDetailTableViewController;

+ (instancetype)fromStoryboard;

@property (nonatomic, strong) ListModel *model;

@property (nonatomic, strong) YTTradeIndexModel *tradeIndexs;

@property (nonatomic, strong) YTTradeModel *tradeModel;

@property (nonatomic, copy) YTBuyAndSellDetailTableViewControllerOperateDoneBlock operateDoneBlock;

- (void)endRefresh;

@end

