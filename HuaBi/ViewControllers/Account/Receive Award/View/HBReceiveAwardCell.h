//
//  HBReceiveAwardCell.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/19.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HBReceiveAwardCell, HBReceiveAwardModel;
@protocol HBReceiveAwardCellDelegate <NSObject>

- (void)receiveAwardWithReceiveAwardCell:(HBReceiveAwardCell *)cell model:(HBReceiveAwardModel *)model;

@end

@interface HBReceiveAwardCell : UITableViewCell

@property (nonatomic, strong) HBReceiveAwardModel *model;

@property (nonatomic, weak) id<HBReceiveAwardCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
