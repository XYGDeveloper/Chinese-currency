//
//  HBCurrentEntrustViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

FOUNDATION_EXTERN NSString *const HBCurrentEntrustViewControllerDeleteModelNotificationName;

NS_ASSUME_NONNULL_BEGIN
@class ListModel;

/**
 当前委托 与 历史委托 共用界面
 */
@interface HBCurrentEntrustViewController : YJBaseViewController

@property (nonatomic, strong) ListModel *model;

@property (nonatomic, assign) BOOL isHistoryVC;

@end

NS_ASSUME_NONNULL_END
