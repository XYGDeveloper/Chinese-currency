//
//  HBNonomalTableViewCell.m
//  HuaBi
//
//  Created by l on 2019/2/23.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBNonomalTableViewCell.h"
#import "HBChongCurrencyRecorModel.h"

@implementation HBNonomalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.numberNameLabel.text = kLocat(@"Relase Number");
    self.statusNameLabel.text = kLocat(@"Relase Status");
    self.timeNameLabel.text = kLocat(@"Relase Time");
    [self.cancelAction setTitle:kLocat(@"k_popview_select_paywechat_edit_cancel") forState:UIControlStateNormal];
    // Initialization code
    self.cancelAction.layer.cornerRadius = 4;
    self.cancelAction.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)refreshWithModel:(HBChongCurrencyRecorModel *)model{
    self.nameLabel.text = model.num;
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

- (IBAction)cAction:(id)sender {
    
    if (self.cancel) {
        self.cancel();
    }
    
}

- (IBAction)todet:(id)sender {
    if (self.detail) {
        self.detail();
    }
}




@end
