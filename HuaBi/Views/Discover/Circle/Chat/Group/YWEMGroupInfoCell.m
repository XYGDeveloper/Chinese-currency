


//
//  YWEMGroupInfoCell.m
//  ywshop
//
//  Created by 周勇 on 2017/12/8.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWEMGroupInfoCell.h"

@interface YWEMGroupInfoCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

@end

@implementation YWEMGroupInfoCell


-(void)setIsOwner:(BOOL)isOwner
{
    _isOwner = isOwner;
    
    if (_isOwner) {
        _leftMargin.constant = 12 + 8 + 10;
        _arrow.hidden = NO;
    }else{
        _leftMargin.constant = 12;
        _arrow.hidden = YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _itemLabel.textColor = kColorFromStr(@"080808");
    _itemLabel.font = PFRegularFont(16);
    
    
    _bottomLine.backgroundColor = kColorFromStr(@"e6e6e6");
    _topLine.backgroundColor = kColorFromStr(@"e6e6e6");
    
    _infoLabel.textColor = kColorFromStr(@"080808");
    _infoLabel.font = PFRegularFont(16);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
