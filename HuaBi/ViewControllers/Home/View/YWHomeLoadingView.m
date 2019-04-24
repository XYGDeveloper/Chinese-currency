//
//  YWHomeLoadinView.m
//  ywshop
//
//  Created by 前海数交（ZJ） on 2018/8/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YWHomeLoadingView.h"

@implementation YWHomeLoadingView

+ (instancetype)loadFromNib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = kThemeBGColor;
}

- (void)showInView:(UIView *)view {
    self.frame = view.bounds;
    self.layer.zPosition = 1.;
    [view addSubview:self];
}

- (void)hide {
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
