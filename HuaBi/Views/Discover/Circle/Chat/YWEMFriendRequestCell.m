


//
//  YWEMFriendRequestCell.m
//  ywshop
//
//  Created by 周勇 on 2017/12/5.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWEMFriendRequestCell.h"

@implementation YWEMFriendRequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = kWhiteColor;
    
    _topLine.backgroundColor = kGrayLineColor;
    _bottomLine.backgroundColor = kGrayLineColor;
    self.selectionStyle = 0;
    
    _nameLabel.textColor = k323232Color;
    _nameLabel.font = PFRegularFont(14);
    _msgLabel.textColor = kColorFromStr(@"8c8c8c");
    _msgLabel.font = PFRegularFont(12);
    
    
    kViewBorderRadius(_avatar, 22, 0, kRedColor);
    
    _confirmButton.titleLabel.font = PFRegularFont(12);
    
    [_confirmButton setTitle:LocalizedString(@"Dis_Agree") forState:UIControlStateNormal];
    [_confirmButton setTitle:LocalizedString(@"Dis_Agreed") forState:UIControlStateSelected];
    [_confirmButton setTitleColor:k323232Color forState:UIControlStateNormal];
    [_confirmButton setTitleColor:kColorFromStr(@"c8c8c8") forState:UIControlStateSelected];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
