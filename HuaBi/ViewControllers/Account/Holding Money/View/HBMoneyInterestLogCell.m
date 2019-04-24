//
//  HBMoneyInterestLogCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/4.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMoneyInterestLogCell.h"
#import "HBMoneyInterestLogModel.h"

@interface HBMoneyInterestLogCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *containerView;

//names
@property (weak, nonatomic) IBOutlet UILabel *directionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *peroidNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expridTimeNameLabel;


@end

@implementation HBMoneyInterestLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.containerView.backgroundColor = kThemeColor;
    self.currencyNameLabel.text = kLocat(@"Money Interest Menu Currency");
    self.directionNameLabel.text = kLocat(@"Money Interest Deposit Operation direction");
    self.peroidNameLabel.text = kLocat(@"Money Interest Menu Management period");
    self.numberNameLabel.text = kLocat(@"Money Interest Deposit Number");
    self.incomeNameLabel.text = kLocat(@"Money Interest Menu Expected annualized income");
    self.expridTimeNameLabel.text = kLocat(@"Money Interest Deposit Expire date");
}

#pragma mark - Setters

- (void)setModel:(HBMoneyInterestLogModel *)model {
    _model = model;
    
    self.timeLabel.text = model.add_time;
    self.currencyLabel.text = model.currency_name;
    self.monthsLabel.text = [NSString stringWithFormat:@"%@ %@", model.months ?: @"--", kLocat(@"Money Interest Months")];
    self.numberLabel.text = model.numAndCurrency;
    self.rateLabel.text = model.rateOfPrecent;
    self.endTimeLabel.text = model.end_time;
    self.statusLabel.text = model.statusString;
    self.statusLabel.textColor = model.statusColor;
}

@end
