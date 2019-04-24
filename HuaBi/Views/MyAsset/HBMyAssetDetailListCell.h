//
//  HBMyAssetDetailListCell.h
//  HuaBi
//
//  Created by Roy on 2018/11/8.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FinModel;

@interface HBMyAssetDetailListCell : UITableViewCell

- (void)refreshWithModel:(FinModel *)model;


@end

NS_ASSUME_NONNULL_END
