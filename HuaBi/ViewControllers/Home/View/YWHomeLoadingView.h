//
//  YWHomeLoadinView.h
//  ywshop
//
//  Created by 前海数交（ZJ） on 2018/8/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWHomeLoadingView : UIView

+ (instancetype)loadFromNib;

- (void)showInView:(UIView *)view;

- (void)hide;

@end
