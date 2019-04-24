//
//  TPOTCPayWayAddTFCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCPayWayAddTFCell.h"

@implementation TPOTCPayWayAddTFCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kColorFromStr(@"#0B132A");
    _lineView.backgroundColor = kColorFromStr(@"#535A69");
    _tf.font = PFRegularFont(16);
    _tf.textColor = kLightGrayColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
