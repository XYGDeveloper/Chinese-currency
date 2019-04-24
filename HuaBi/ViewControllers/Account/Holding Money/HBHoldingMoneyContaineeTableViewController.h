//
//  HBHoldingMoneyContaineeTableViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/30.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HBMoneyInterestWarpperModel, HBMoneyInterestSettingModel;
@interface HBHoldingMoneyContaineeTableViewController : UITableViewController


@property (nonatomic, strong) HBMoneyInterestWarpperModel *warpperModel;
@property (nonatomic, strong, readonly) HBMoneyInterestSettingModel *selectedSettingModel;


@end

NS_ASSUME_NONNULL_END
