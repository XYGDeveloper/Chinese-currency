//
//  TPOTCPostDetailListCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCPostDetailListCell.h"

@implementation TPOTCPostDetailListCell

-(void)setType:(NSInteger)type
{
    _type = type;
    if (type) {
        self.infoLabel.textColor = [UIColor colorWithRed:0.60 green:0.73 blue:0.87 alpha:1.00];
    }else{
        self.infoLabel.textColor = kDarkGrayColor;
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor =  kColorFromStr(@"#0B132A");
    self.lineView.backgroundColor = kColorFromStr(@"171F34");
    
    self.itemLabel.textColor = kDarkGrayColor;
    self.itemLabel.font = PFRegularFont(13);
    
    self.infoLabel.textColor = kDarkGrayColor;
    self.infoLabel.font = PFRegularFont(13);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
