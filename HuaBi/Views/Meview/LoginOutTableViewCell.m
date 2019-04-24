//
//  LoginOutTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/9/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "LoginOutTableViewCell.h"

@implementation LoginOutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.loginButton.layer.cornerRadius = 8;
    self.loginButton.layer.masksToBounds = YES;
    [self.loginButton setTitle:kLocat(@"k_MymineViewController_top_label_tcdl") forState:UIControlStateNormal];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}


- (IBAction)loginOutAction:(id)sender {
    if (self.lout) {
        self.lout();
    }
}

@end
