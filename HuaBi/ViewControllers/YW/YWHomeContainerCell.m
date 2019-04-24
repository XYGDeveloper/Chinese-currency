//
//  YWHomeContainerCell.m
//  ywshop
//
//  Created by 前海数交（ZJ） on 2018/8/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YWHomeContainerCell.h"

@interface YWHomeContainerCell () <UIScrollViewDelegate>



@end

@implementation YWHomeContainerCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.scrollView.scrollsToTop = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    CGFloat width = CGRectGetWidth(self.bounds);
//    width = kScreenW;
//
//    [_containeeVCs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj.view.frame = CGRectMake(idx * width, 0., width, CGRectGetHeight(self.contentView.bounds));
//    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(containerCellScrollViewDidEndDecelerating:)]) {
        [self.delegate containerCellScrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(containerCellScrollViewBeginDecelerating:)]) {
        [self.delegate containerCellScrollViewBeginDecelerating:scrollView];
    }
}

#pragma mark - Setters

- (void)setContaineeVCs:(NSArray<UIViewController *> *)containeeVCs {
    [_containeeVCs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.view removeFromSuperview];
    }];
    
    _containeeVCs = containeeVCs;
    
    
    [_containeeVCs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.view.frame = CGRectMake(idx * kScreenW, 0., kScreenW, CGRectGetHeight(self.contentView.bounds));
        [self.scrollView addSubview:obj.view];
    }];
    self.scrollView.contentSize = CGSizeMake(kScreenW * _containeeVCs.count, 0.);
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    [self.scrollView setContentOffset:CGPointMake(_selectedIndex * kScreenW, 0) animated:YES];
}

@end
