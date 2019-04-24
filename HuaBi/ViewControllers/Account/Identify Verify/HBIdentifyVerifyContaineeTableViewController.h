//
//  HBIdentifyVerifyContaineeTableViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HBCardModel;
@interface HBIdentifyVerifyContaineeTableViewController : UITableViewController

+ (instancetype)fromStoryboard;

- (void)showWithCardModel:(HBCardModel *)model;

- (void)submitAction;

@end

NS_ASSUME_NONNULL_END
