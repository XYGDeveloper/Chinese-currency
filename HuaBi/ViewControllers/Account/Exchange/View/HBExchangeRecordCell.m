//
//  HBExchangeRecordCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/19.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBExchangeRecordCell.h"
#import "HBExchangeModel.h"

@interface HBExchangeRecordCell ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation HBExchangeRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.containerView.backgroundColor = kThemeColor;
}

- (void)configureCellWithModel:(HBExchangeModel *)model {
    self.currencyLabel.text = model.currency_name;
    self.timeLabel.text = model.add_time;
    self.statusLabel.text = model.statusString;
    self.statusLabel.textColor = model.statusColor;
}

@end
