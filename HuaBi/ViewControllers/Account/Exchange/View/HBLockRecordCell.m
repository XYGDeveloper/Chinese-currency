//
//  HBLockRecordCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBLockRecordCell.h"
#import "HBToLockModel.h"

@interface HBLockRecordCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeNameLabel;


@end

@implementation HBLockRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.statusNameLabel.text = kLocat(@"k_HBTradeJLViewController_status");
    self.numberNameLabel.text = kLocat(@"Number_of_locks");
    self.timeNameLabel.text = kLocat(@"Assert_detail_dealtime");
    self.containerView.backgroundColor = kThemeColor;
}


- (void)configWithModel:(HBToLockModel *)model {
    self.numberLabel.text = [NSString stringWithFormat:@"%@ %@", model.num ?: @"", model.currency_name ?: @""];
    self.statusLabel.text = model.statusString;
    self.timeLabel.text = model.add_time;
}

@end
