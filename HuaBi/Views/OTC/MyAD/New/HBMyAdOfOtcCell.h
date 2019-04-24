//
//  HBMyAdOfOtcCell.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/3.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TPOTCMyADModel;
@interface HBMyAdOfOtcCell : UITableViewCell

@property (nonatomic, strong) TPOTCMyADModel *model;

- (void)configureCellWithModel:(TPOTCMyADModel *)model isHistory:(BOOL)isHistory;

@end

NS_ASSUME_NONNULL_END
