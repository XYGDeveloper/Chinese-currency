//
//  YTSellTrendingContaineeViewController.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YTSellTrendingContaineeViewControllerCellDidSelectBlock)(NSString *price);

NS_ASSUME_NONNULL_BEGIN
@class Buy_list;
@interface YTSellTrendingContaineeViewController : UIViewController

@property (nonatomic, assign) BOOL isTypeOfBuy;

@property (nonatomic, strong) NSArray<Buy_list *> *models;

@property (nonatomic, copy) YTSellTrendingContaineeViewControllerCellDidSelectBlock didSelectCellBlock;

@end

NS_ASSUME_NONNULL_END
