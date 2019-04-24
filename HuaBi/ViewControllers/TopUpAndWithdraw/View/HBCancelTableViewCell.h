//
//  HBCancelTableViewCell.h
//  HuaBi
//
//  Created by l on 2019/2/23.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HBChongCurrencyRecorModel;
typedef void (^todetail)(void);
@interface HBCancelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong)todetail detail;

- (void)refreshWithModel:(HBChongCurrencyRecorModel *)model;

@end

