//
//  BCBitemTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class order_sellModel;
@class order_buyModel;

@interface BCBitemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

- (void)refreshWithModel:(order_sellModel *)model;

- (void)refreshWithModel1:(order_buyModel *)model;

@end

NS_ASSUME_NONNULL_END
