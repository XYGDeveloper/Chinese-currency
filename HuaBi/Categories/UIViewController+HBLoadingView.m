//
//  UIViewController+HBLoadingView.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/7.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "UIViewController+HBLoadingView.h"
#import "YWHomeLoadingView.h"
#import <objc/runtime.h>

@interface UIViewController ()

@property (nonatomic, strong) YWHomeLoadingView *loadingView;

@end

static char kYWHomeLoadingViewKey;

@implementation UIViewController (HBLoadingView)

- (YWHomeLoadingView *)loadingView {
    id loadingView = objc_getAssociatedObject(self,&kYWHomeLoadingViewKey);
    if (!loadingView) {
        loadingView = [YWHomeLoadingView loadFromNib];
        self.loadingView = loadingView;
    }
    
    return loadingView;
}

- (void)setLoadingView:(YWHomeLoadingView *)loadingView {
    objc_setAssociatedObject(self, &kYWHomeLoadingViewKey, loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showLoadingView {
    [self.loadingView showInView:self.view];
}

- (void)hideLoadingView {
    [self.loadingView hide];
    self.loadingView = nil;
}

@end
