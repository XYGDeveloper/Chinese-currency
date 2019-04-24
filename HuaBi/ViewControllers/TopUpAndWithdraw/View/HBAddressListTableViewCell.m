//
//  HBAddressListTableViewCell.m
//  HuaBi
//
//  Created by l on 2019/2/23.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBAddressListTableViewCell.h"
#import "HBAddressModel.h"
@implementation HBAddressListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pName.text = kLocat(@"HBTokenWithdrawViewController_huabi");
    [self.normalAddressButton setTitle:kLocat(@"HBTokenWithdrawViewController_changyongdizhi") forState:UIControlStateNormal];
    [self.editButton setTitle:kLocat(@"HBTokenWithdrawViewController_edit") forState:UIControlStateNormal];
    [self.delButton setTitle:kLocat(@"HBTokenWithdrawViewController_del") forState:UIControlStateNormal];
    
    [self.normalAddressButton setTitle:kLocat(@"HBTokenWithdrawViewController_address_normal") forState:UIControlStateNormal];
    [self.normalAddressButton setTitle:kLocat(@"HBTokenWithdrawViewController_address_normal") forState:UIControlStateSelected];
    [self.normalAddressButton setImage:[UIImage imageNamed:@"nomal_address"] forState:UIControlStateNormal];
    // Initialization code
}

- (void)refreshWithModel:(HBAddressModel *)model{
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@",kLocat(@"HBTokenWithdrawViewController_singleaddress"),model.qianbao_url];
    if ([model.is_default isEqualToString:@"1"]) {
        self.normalAddressButton.selected = YES;
    }else{
        self.normalAddressButton.selected = NO;
    }
}

- (IBAction)defaAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (self.defau) {
        self.defau(btn);
    }
}

- (IBAction)editAction:(UIButton *)sender {
    
    if (self.editor) {
        self.editor(sender);
    }
}


- (IBAction)delAction:(UIButton *)sender {
    
    if (self.delet) {
        self.delet(sender);
    }
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
