//
//  YTLatestDealContaineeTableViewController.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class  Trade_list;

/**
 最新成交（K线图子界面）
 */
@interface YTLatestDealContaineeTableViewController : UITableViewController

@property (nonatomic, strong) NSArray<Trade_list *> *models;

+ (CGFloat)getHeightWithModels:(NSArray<Trade_list *> *)models;

@end

NS_ASSUME_NONNULL_END
