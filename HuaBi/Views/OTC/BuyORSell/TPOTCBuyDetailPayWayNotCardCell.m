//
//  TPOTCBuyDetailPayWayNotCardCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyDetailPayWayNotCardCell.h"

@implementation TPOTCBuyDetailPayWayNotCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = kColorFromStr(@"#0B132A");
    self.selectionStyle  = 0;
    self.wayLabel.textColor = kColorFromStr(@"#CDD2E3");
    self.wayLabel.font = PFRegularFont(16);
    
    self.wayButton.userInteractionEnabled = NO;
    
    [self.wayButton setImage:kImageFromStr(@"gmxq_icon_wxz") forState:UIControlStateNormal];
    [self.wayButton setImage:kImageFromStr(@"gmxq_icon_xz") forState:UIControlStateSelected];

    self.lineView.backgroundColor = kColorFromStr(@"#707589");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
