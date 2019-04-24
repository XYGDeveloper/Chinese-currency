//
//  C2CHeaderTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "C2CHeaderTableViewCell.h"

@implementation C2CHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label1.text = kLocat(@"k_c2c_now_trade01");
    self.label2.text = kLocat(@"k_c2c_now_trade02");
    self.label3.text = kLocat(@"k_c2c_now_trade03");
    self.label4.text = kLocat(@"k_c2c_now_trade04");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
