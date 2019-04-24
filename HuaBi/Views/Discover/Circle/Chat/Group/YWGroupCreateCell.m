//
//  YWGroupCreateCell.m
//  ywshop
//
//  Created by 周勇 on 2017/12/7.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWGroupCreateCell.h"

@implementation YWGroupCreateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    
    kViewBorderRadius(_avatar, 25, 0, kRedColor);
    
    _nameLabel.textColor = kColorFromStr(@"080808");
    _nameLabel.font = PFRegularFont(16);
    
    
    _topLine.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    _bottomLine.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    [_selectedButton setImage:kImageFromStr(@"selectedbtn_default") forState:UIControlStateNormal];
    [_selectedButton setImage:kImageFromStr(@"selectedbtn_pre") forState:UIControlStateSelected];
    _selectedButton.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
