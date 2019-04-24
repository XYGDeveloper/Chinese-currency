//
//  YWEMGroupInfoCollectionCell.m
//  ywshop
//
//  Created by 周勇 on 2017/12/8.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWEMGroupInfoCollectionCell.h"



@implementation YWEMGroupInfoCollectionCell



-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _nameLabel.textColor = kColorFromStr(@"525252");
    _nameLabel.font = PFRegularFont(12);
    
    kViewBorderRadius(_avatar, 22, 0, kRedColor);
}

@end



