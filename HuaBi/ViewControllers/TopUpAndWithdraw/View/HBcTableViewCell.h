//
//  HBcTableViewCell.h
//  HuaBi
//
//  Created by l on 2019/2/24.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HBChongCurrencyRecorModel;

@interface HBcTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (void)refreshWithModel:(HBChongCurrencyRecorModel *)model;

@end

NS_ASSUME_NONNULL_END
