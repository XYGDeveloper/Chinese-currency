//
//  HBSubscribeRecordCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBSubscribeRecordCell.h"
#import "HBSubscribeRecordModel.h"

@interface HBSubscribeRecordCell ()

// Values
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *frozenNumberLabel;

// Names
@property (weak, nonatomic) IBOutlet UILabel *numberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLocksNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *releaseButton;
@property (weak, nonatomic) IBOutlet UIButton *releseRecordButton;

@end

@implementation HBSubscribeRecordCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.containerView.backgroundColor = kThemeColor;

    self.releseRecordButton.layer.borderWidth = 1.;
    self.releseRecordButton.layer.borderColor = kColorFromStr(@"4173C8").CGColor;
    
    self.numberNameLabel.text = kLocat(@"Subscription Number");
    self.paymentNameLabel.text = kLocat(@"Subscription Payment");
    self.timeNameLabel.text = kLocat(@"Subscription Number of locks");
    self.numberOfLocksNameLabel.text = kLocat(@"Subscription Number of locks");
    [self.releaseButton setTitle:kLocat(@"Subscription release") forState:UIControlStateNormal];
    [self.releseRecordButton setTitle:kLocat(@"Subscription release records") forState:UIControlStateNormal];
}

#pragma mark - Actions

- (IBAction)releaseAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(subscribeRecordCell:releseModel:)]) {
        [self.delegate subscribeRecordCell:self releseModel:self.model];
    }
}

- (IBAction)showReleaseRecordVCAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(subscribeRecordCell:showReleseVCWithModel:)]) {
        [self.delegate subscribeRecordCell:self showReleseVCWithModel:self.model];
    }
}

#pragma mark - Setters

- (void)setModel:(HBSubscribeRecordModel *)model {
    _model = model;
    
    self.numberLabel.text = model.numAndCurrencyName;
    self.countLabel.text = model.countAndBuyName;
    self.timeLabel.text = model.add_time;
    self.frozenNumberLabel.text = model.numAndCurrencyName;
    self.releaseButton.hidden = !model.canShow;
    self.releseRecordButton.hidden = !model.canShow;
}



@end
