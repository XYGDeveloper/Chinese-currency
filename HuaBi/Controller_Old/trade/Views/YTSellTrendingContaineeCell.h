//
//  YTSellTrendingContaineeCell.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class Buy_list;
@interface YTSellTrendingContaineeCell : UITableViewCell

@property (nonatomic, strong) Buy_list *model;

- (void)configureWithModel:(Buy_list *)model index:(NSInteger)index color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
