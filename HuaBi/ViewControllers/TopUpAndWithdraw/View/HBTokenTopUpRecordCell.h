//
//  HBTokenTopUpRecordCell.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/2/19.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HBChongCurrencyRecorModel;

@interface HBTokenTopUpRecordCell : UITableViewCell

- (void)refreshWithModel:(HBChongCurrencyRecorModel *)model;


@end

NS_ASSUME_NONNULL_END
