//
//  YTTradeCancellationsCell.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YTTradeUserOrderModel, YTTradeCancellationsCell;

@protocol YTTradeCancellationsCellDelegate <NSObject>

- (void)tradeCancellationsCell:(YTTradeCancellationsCell *)cell deleteModel:(YTTradeUserOrderModel *)model;

@end

@interface YTTradeCancellationsCell : UITableViewCell

@property (nonatomic, strong) YTTradeUserOrderModel *model;

@property (nonatomic, weak) id<YTTradeCancellationsCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
