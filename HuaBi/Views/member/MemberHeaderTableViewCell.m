//
//  MemberHeaderTableViewCell.m
//  HuaBi
//
//  Created by XI YANGUI on 2018/10/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MemberHeaderTableViewCell.h"

@implementation MemberHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avater.layer.cornerRadius = 35/2;
    self.avater.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
