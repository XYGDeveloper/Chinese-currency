//
//  ICNNationalityCell.m
//  icn
//
//  Created by 周勇 on 2018/1/31.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "ICNNationalityCell.h"

@implementation ICNNationalityCell

-(void)setModel:(ICNNationalityModel *)model
{
    _model = model;
    _nameLabel.text = model.name;
    _chooseButton.selected = model.isSelected;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _nameLabel.textColor = k323232Color;
    _nameLabel.font = PFRegularFont(12);
    _topLine.backgroundColor = kColorFromStr(@"f4f4f4");
    _bottomLine.backgroundColor = kColorFromStr(@"f4f4f4");
    
    [_chooseButton setImage:kImageFromStr(@"selectedbtn_default") forState:UIControlStateNormal];
    [_chooseButton setImage:kImageFromStr(@"selectedbtn_pre") forState:UIControlStateSelected];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
