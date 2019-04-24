//
//  HBKlineResumeTableViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/19.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HBIconInfoModel;

/**
 币种简介（K线图子界面）
 */
@interface HBKlineResumeTableViewController : UITableViewController

@property (nonatomic, strong) HBIconInfoModel *iconInfoModel;

- (CGFloat)getHeight;

@end

NS_ASSUME_NONNULL_END
