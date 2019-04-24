//
//  YTNewDetailTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/10/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YTDetailModel;
@interface YTNewDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbael1;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rimg;
@property (weak, nonatomic) IBOutlet UILabel *des;

- (void)refreshWithModel:(YTDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
