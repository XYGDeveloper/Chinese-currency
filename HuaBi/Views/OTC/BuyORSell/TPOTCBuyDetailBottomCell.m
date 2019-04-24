//
//  TPOTCBuyDetailBottomCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyDetailBottomCell.h"

@implementation TPOTCBuyDetailBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];



    self.selectionStyle = 0;
    self.contentView.backgroundColor = kColorFromStr(@"#0B132A");
    self.itemLabel.textColor = kColorFromStr(@"#707589");
    self.itemLabel.font = PFRegularFont(14);
    
    self.infoLabel.font = PFRegularFont(14);
    
    self.cpyLabel.font = PFRegularFont(14);
    
    _cpyLabel.textColor = kColorFromStr(@"#CDD2E3");
    _infoLabel.textColor = kColorFromStr(@"#CDD2E3");
    _lineView.backgroundColor = kColorFromStr(@"#2C303C");
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
