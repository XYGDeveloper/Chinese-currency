//
//  HBConfirmOrderBuyerMessageCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/9.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBConfirmOrderBuyerMessageCell.h"
#import "UITextView+Placeholder.h"

@implementation HBConfirmOrderBuyerMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.buyerMessageTextView.placeholder = @"选填，给卖家留言，说出您想说的（100字以内）。";
    self.buyerMessageTextView.placeholderColor = kCCCCCC_Color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
