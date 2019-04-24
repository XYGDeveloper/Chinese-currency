//
//  YWMyCircleFansCell.m
//  ywshop
//
//  Created by 周勇 on 2017/11/25.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWMyCircleFansCell.h"


@interface YWMyCircleFansCell ()



@end


@implementation YWMyCircleFansCell


-(void)setModel:(YWFansModel *)model
{
    _model = model;
    
    _nameLabel.text = model.usernick;
    _timeLabel.text = model.add_time;
    [_avatar setImageWithURL:model.userhead.ks_URL placeholder:nil
     ];
    
    
    if (model.is_follow.boolValue) {
        _attentionButton.selected = YES;
        kViewBorderRadius(_attentionButton, 12, 0.5, kColorFromStr(@"999999"));
    }else{
        _attentionButton.selected = NO;
        kViewBorderRadius(_attentionButton, 12, 0.5, kColorFromStr(@"6496d6"));
    }
    
    
    
    
    
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    _timeLabel.textColor = kColorFromStr(@"8c8c8c");
    _nameLabel.textColor = kColorFromStr(@"080808");
    _nameLabel.font = PFRegularFont(16);
    _timeLabel.font = PFRegularFont(12);
    _nickNameLabel.textColor = kColorFromStr(@"080808");
    _nickNameLabel.font = PFRegularFont(16);
    
    
    kViewBorderRadius(_avatar, 25, 0, kRedColor);
    _topLine.backgroundColor = kColorFromStr(@"e6e6e6");
    _bottomLine.backgroundColor = kColorFromStr(@"e6e6e6");

    [_attentionButton setTitleColor:kColorFromStr(@"6496d6") forState:UIControlStateNormal];
    [_attentionButton setTitleColor:kColorFromStr(@"999999") forState:UIControlStateSelected];
    [_attentionButton setTitle:kLocat(@"Dis_AddAttention") forState:UIControlStateNormal];

    [_attentionButton setTitle:kLocat(@"Dis_AttentionEd") forState:UIControlStateSelected];
    _attentionButton.titleLabel.font = PFRegularFont(12);
    
    _tipsLabel.textColor = k323232Color;
    _tipsLabel.font = PFRegularFont(12);
    _tipsLabel.text = kLocat(@"EReceiveRequest");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
