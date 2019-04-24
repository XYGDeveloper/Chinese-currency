

//
//  YWSearchFriendCell.m
//  ywshop
//
//  Created by 周勇 on 2017/11/30.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWSearchFriendCell.h"

@implementation YWSearchFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _nameLabel.textColor = kColorFromStr(@"080808");
    _nameLabel.font = PFRegularFont(16);
    
    kViewBorderRadius(_avatar, 25, 0, kRedColor);
    kViewBorderRadius(_addButton, 12, 0.5, kColorFromStr(@"6496d6"));
    _addButton.titleLabel.font = PFRegularFont(12);
    [_addButton setTitleColor:kColorFromStr(@"6496d6") forState:UIControlStateNormal];
    [_addButton setTitleColor:kColorFromStr(@"8e8e8e") forState:UIControlStateSelected];
    [_addButton setTitle:kLocat(@"EAddFriend") forState:UIControlStateNormal];
    [_addButton setTitle:kLocat(@"EFriendAdded") forState:UIControlStateSelected];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
