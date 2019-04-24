//
//  HBcTableViewCell.m
//  HuaBi
//
//  Created by l on 2019/2/24.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBcTableViewCell.h"
#import "HBChongCurrencyRecorModel.h"

@implementation HBcTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.numberNameLabel.text = kLocat(@"Relase Number");
    self.statusNameLabel.text = kLocat(@"Relase Status");
    self.timeNameLabel.text = kLocat(@"Relase Time");
    self.contentView.backgroundColor = kColorFromStr(@"171F34");
    
    // Initialization code
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
