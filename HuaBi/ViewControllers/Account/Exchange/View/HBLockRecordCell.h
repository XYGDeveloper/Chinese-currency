//
//  HBLockRecordCell.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HBToLockModel;
@interface HBLockRecordCell : UITableViewCell

- (void)configWithModel:(HBToLockModel *)model;

@end

NS_ASSUME_NONNULL_END
