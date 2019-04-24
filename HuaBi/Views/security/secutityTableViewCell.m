//
//  secutityTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/10/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "secutityTableViewCell.h"

@implementation secutityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.modifyBtn.layer.cornerRadius = 4;
    self.modifyBtn.layer.masksToBounds = YES;
    
    // Initialization code
}

- (IBAction)todetail:(id)sender {
    
    if (self.detail) {
        self.detail();
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
