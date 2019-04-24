//
//  HBCurrentEntrustContaineeTableViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBBaseTableViewController.h"


typedef void(^HBCurrentEntrustContaineeTableViewControllerHeightChangedBlock)(void);

@class YTTradeUserOrderModel, ListModel;

/**
  当前委托 交易界面嵌套子界面
 */
@interface HBCurrentEntrustContaineeTableViewController : HBBaseTableViewController

@property (nonatomic, strong) NSArray<YTTradeUserOrderModel *> *orders;

@property (nonatomic, copy) HBCurrentEntrustContaineeTableViewControllerHeightChangedBlock heightChangedBlock;

+ (CGFloat)getHeightWithModels:(NSArray<YTTradeUserOrderModel *> *)models;

- (CGFloat)getHeight;

@property (nonatomic, strong) ListModel *model;
@property (nonatomic, assign) BOOL isTypeOfBuy;

@end


