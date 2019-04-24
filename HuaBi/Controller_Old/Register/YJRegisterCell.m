//
//  YJRegisterCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/1/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJRegisterCell.h"

@implementation YJRegisterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _topLine.backgroundColor = kColorFromStr(@"434343");
    _bottomLine.backgroundColor = kColorFromStr(@"434343");
    _midLine.backgroundColor = kColorFromStr(@"f4f4f4f");
    _itemLabel.textColor = k323232Color;
    _itemLabel.font = PFRegularFont(16);
    _TF.textColor = kColorFromStr(@"7c7c7c");
    _TF.font = PFRegularFont(16);

    _codeButton.titleLabel.font = PFRegularFont(14);
    kViewBorderRadius(_codeButton, 1.5, 0, kRedColor);
    
    self.selectionStyle = 0;
    
    _codeButton.hidden = YES;
    _xiala.hidden = YES;
    _phoneButton.hidden = YES;
    _phoneTF.hidden = YES;
    _phoneTF.textColor = kColorFromStr(@"7c7c7c");

    [_codeButton setTitle:kLocat(@"LGetVerificationCode") forState:UIControlStateNormal];
    
//    _phoneButton.titleRect = kRectMake(15, 0, 50, 20);
//    _phoneButton.imageRect = kRectMake(58, 5, 8, 7);
    _phoneButton.titleLabel.font = PFRegularFont(16);
    [_phoneButton setTitleColor:kColorFromStr(@"7c7c7c") forState:UIControlStateNormal];
    [_phoneButton setTitle:@"86" forState:UIControlStateNormal];
    
    
    [_codeButton setTitleColor:kColorFromStr(@"7c7c7c") forState:UIControlStateNormal];
    _codeButton.backgroundColor = [UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1.00];
    _codeButton.titleLabel.font = PFRegularFont(12);
    kViewBorderRadius(_codeButton, 1.5, 0, kRedColor);
 
    self.contentView.backgroundColor = [UIColor colorWithRed:0.09 green:0.10 blue:0.14 alpha:1.00];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
