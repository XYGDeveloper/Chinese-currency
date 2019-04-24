//
//  HBReceiveAwardCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/19.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBReceiveAwardCell.h"
#import "UITableViewCell+HB.h"
#import "HBReceiveAwardModel.h"

@interface HBReceiveAwardCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *awardTypeLabel;

//names
@property (weak, nonatomic) IBOutlet UILabel *numberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *receiveButton;


@end

@implementation HBReceiveAwardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.containerView.backgroundColor = kThemeColor;
    [self _addSelectedBackgroundView];
 
    self.numberNameLabel.text = kLocat(@"Receive award number");
    self.typeNameLabel.text = kLocat(@"Receive award type");
    self.timeNameLabel.text = kLocat(@"Receive award time");
    self.numberNameLabel.text = kLocat(@"Receive award number");
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIColor *color = self.model.canReceive ? kColorFromStr(@"#4173C8") : kColorFromStr(@"#CCCCCC");
    self.receiveButton.backgroundColor = color;
}

#pragma mark - Actions

- (IBAction)receiveAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(receiveAwardWithReceiveAwardCell:model:)]) {
        [self.delegate receiveAwardWithReceiveAwardCell:self model:self.model];
    }
}

#pragma mark - Setters

- (void)setModel:(HBReceiveAwardModel *)model {
    _model = model;
    self.awardTypeLabel.text = model.type;
    self.numberLabel.text = model.num_award;
    self.typeLabel.text = model.currency_id;
    self.timeLabel.text = model.add_time;
    NSString *titleOfReciveButton = model.canReceive ? kLocat(@"Receive award receive") : kLocat(@"Receive award received");
    self.receiveButton.enabled = model.canReceive;
    [self.receiveButton setTitle:titleOfReciveButton forState:UIControlStateNormal];
}

@end
