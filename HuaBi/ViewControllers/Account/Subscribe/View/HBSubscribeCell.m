//
//  HBSubscribeCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBSubscribeCell.h"
#import "UITableViewCell+HB.h"
#import "HBSubscribeModel.h"


@interface HBSubscribeCell ()

@property (weak, nonatomic) IBOutlet UIView *containerTopView;
@property (weak, nonatomic) IBOutlet UIView *containerBottomView;
@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;


//Values
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLowLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPeopleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *projectTitleLabel;

//Names
@property (weak, nonatomic) IBOutlet UILabel *priceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLowNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPeopleNameLabel;
@end

@implementation HBSubscribeCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.containerTopView.backgroundColor = kThemeColor;
    self.containerBottomView.backgroundColor = kThemeColor;
    [self _addSelectedBackgroundView];
    
    

    self.priceNameLabel.text = kLocat(@"Subscription price");
    self.numberOfLowNameLabel.text = kLocat(@"Minimum quantity");
    self.goalNameLabel.text = kLocat(@"Subscription Goal");
    self.progressNameLabel.text = kLocat(@"Subscription Progress");
    self.numberOfPeopleNameLabel.text = kLocat(@"Subscription Number of people");
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.subscribeButton.backgroundColor = self.model.statusColor;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.model = nil;
}

#pragma mark - Actions

- (IBAction)subscribeAction:(id)sender {
    if (self.model.status == HBSubscribeModelStatusCrowdfunding) {
        if (self.tappedSubscribeBlock) {
            self.tappedSubscribeBlock(self.model);
        }
    }
    
}

#pragma mark - Setters

- (void)setModel:(HBSubscribeModel *)model {
    _model = model;
    [self.iconImageView setImageURL:[NSURL URLWithString:model.logo]];
    self.projectTitleLabel.text = model.title;
    self.priceLabel.text = model.priceAndCurrency;
    self.numberOfLowLabel.text = model.min_limit;
    self.goalLabel.text = model.num;
    self.progressLabel.text = model.blAndPrecent;
    self.numberOfPeopleLabel.text = model.peoples;
    [self.subscribeButton setTitle:model.statusString forState:UIControlStateNormal];
    self.subscribeButton.backgroundColor = model.statusColor;

}

@end
