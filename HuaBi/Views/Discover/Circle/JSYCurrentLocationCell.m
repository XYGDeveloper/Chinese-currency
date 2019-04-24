//
//  JSYCurrentLocationCell.m
//  jys
//
//  Created by 周勇 on 2017/7/31.
//  Copyright © 2017年 前海数交所. All rights reserved.
//

#import "JSYCurrentLocationCell.h"

@implementation JSYCurrentLocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _lineView.backgroundColor = kGrayLineColor;
    _nameLabel.textColor = k323232Color;
    _addressLabel.textColor = kColorFromStr(@"#8b8b8b");
    
    _addressLabel.font = PFRegularFont(12);
    _nameLabel.font = PFRegularFont(16);
    
    _addressLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
