//
//  TPOTCPostDetailPayCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCPostDetailPayCell.h"

@implementation TPOTCPostDetailPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kColorFromStr(@"#0B132A");
    
    self.lineView.backgroundColor = kColorFromStr(@"#171F34");
    
    self.payNameLabel.textColor = kDarkGrayColor;
    self.payNameLabel.font = PFRegularFont(14);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
