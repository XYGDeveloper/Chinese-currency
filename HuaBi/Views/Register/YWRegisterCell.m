//
//  YWRegisterCell.m
//  ywshop
//
//  Created by 周勇 on 2017/10/29.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWRegisterCell.h"

@implementation YWRegisterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _TF.font = PFRegularFont(16);
    _TF.textColor = kBlackColor;
    
    kViewBorderRadius(_senderCodeButton, 1.5, 1, kColorFromStr(@"d8d8d8"));
    _senderCodeButton.titleLabel.font = PFRegularFont(14);
    [_senderCodeButton setTitleColor:kColorFromStr(@"9e9e9e") forState:UIControlStateNormal];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
