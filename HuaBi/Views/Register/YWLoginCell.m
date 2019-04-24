
//
//  YWLoginCell.m
//  ywshop
//
//  Created by 周勇 on 2017/10/30.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWLoginCell.h"

@implementation YWLoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _itemLabel.textColor = kBlackColor;
    _itemLabel.font = PFRegularFont(16);
    
    _TF.font = PFRegularFont(16);
    _TF.textColor = kBlackColor;
    
    self.selectionStyle = 0;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
