//
//  HBSubscribeRecordCell.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HBSubscribeRecordModel, HBSubscribeRecordCell;

@protocol HBSubscribeRecordCellDelegate <NSObject>

- (void)subscribeRecordCell:(HBSubscribeRecordCell *)cell releseModel:(HBSubscribeRecordModel *)model;

- (void)subscribeRecordCell:(HBSubscribeRecordCell *)cell showReleseVCWithModel:(HBSubscribeRecordModel *)model;

@end

@interface HBSubscribeRecordCell : UITableViewCell

@property (nonatomic, weak) id<HBSubscribeRecordCellDelegate> delegate;

@property (nonatomic, strong) HBSubscribeRecordModel *model;

@end

NS_ASSUME_NONNULL_END
