//
//  HBTradeButton.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBTradeButton.h"

@implementation HBTradeButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    [self bringSubviewToFront:self.titleLabel];
}

@end
