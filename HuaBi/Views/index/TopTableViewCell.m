//
//  TopTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TopTableViewCell.h"

@implementation TopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.l1.layer.borderWidth = 1;
    self.l1.layer.borderColor = kColorFromStr(@"#51526F").CGColor;
    self.l2.layer.borderWidth = 1;
    self.l2.layer.borderColor = kColorFromStr(@"#51526F").CGColor;
    self.l3.layer.borderWidth = 1;
    self.l3.layer.borderColor = kColorFromStr(@"#51526F").CGColor;
    self.l4.layer.borderWidth = 1;
    self.l4.layer.borderColor = kColorFromStr(@"#51526F").CGColor;
    self.l1.alpha = 0;
    self.l2.alpha = 0;
    self.l3.alpha = 0;
    self.l4.alpha = 0;
    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.l1.alpha = 1;
        self.l2.alpha = 1;
        self.l3.alpha = 1;
        self.l4.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
