//
//  introTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/9/13.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "introTableViewCell.h"

@implementation introTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.uiimg.layer.cornerRadius =7;
    self.uiimg.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
