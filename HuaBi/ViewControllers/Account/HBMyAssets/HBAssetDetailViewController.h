//
//  HBAssetDetailViewController.h
//  HuaBi
//
//  Created by l on 2018/11/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class FinModel;

@interface HBAssetDetailViewController : UITableViewController
+ (instancetype)fromStoryboard;

@property (nonatomic,strong)FinModel *model;

@end

NS_ASSUME_NONNULL_END
