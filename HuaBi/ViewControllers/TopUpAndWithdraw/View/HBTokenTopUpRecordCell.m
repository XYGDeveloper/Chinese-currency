//
//  HBTokenTopUpRecordCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/2/19.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBTokenTopUpRecordCell.h"
#import "HBChongCurrencyRecorModel.h"
@interface HBTokenTopUpRecordCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

// Names
@property (weak, nonatomic) IBOutlet UILabel *numberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeNameLabel;

@end

@implementation HBTokenTopUpRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.containerView.backgroundColor = kThemeColor;
    
    self.numberNameLabel.text = kLocat(@"Relase Number");
    self.statusNameLabel.text = kLocat(@"Relase Status");
    self.timeNameLabel.text = kLocat(@"Relase Time");
}

- (void)refreshWithModel:(HBChongCurrencyRecorModel *)model{
    self.numberLabel.text = model.num;
    if ([model.status isEqualToString:@"-1"]) {
        self.statusLabel.text = kLocat(@"HBTokenWithdrawViewController_token_reve");
    }else if ([model.status isEqualToString:@"-2"]){
        self.statusLabel.text = kLocat(@"HBTokenWithdrawViewController_token_resolve");
    }else if ([model.status isEqualToString:@"3"]){
        self.statusLabel.text = kLocat(@"HBTokenWithdrawViewController_token_chongbi");
    }else{
        self.statusLabel.text = kLocat(@"HBTokenWithdrawViewController_token_scuess");
    }
    self.timeLabel.text = model.add_time;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
