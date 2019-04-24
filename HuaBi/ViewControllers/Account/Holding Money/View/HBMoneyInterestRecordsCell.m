//
//  HBMoneyInterestRecordsCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/4.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMoneyInterestRecordsCell.h"
#import "HBMoneyInterestRecordsModel.h"

@interface HBMoneyInterestRecordsCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation HBMoneyInterestRecordsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.containerView.backgroundColor = kThemeColor;
}


#pragma mark - Setters

- (void)setModel:(HBMoneyInterestRecordsModel *)model {
    _model = model;
    
    self.timeLabel.text = model.add_time;
    self.currencyNameLabel.text = model.currency_name;
    self.numberLabel.text = model.num;
}
@end
