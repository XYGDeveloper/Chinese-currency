//
//  HBNoticeTableViewCell.h
//  HuaBi
//
//  Created by l on 2018/10/18.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YTDetailModel;
@interface HBNoticeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)refreshWithMOdel:(YTDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
