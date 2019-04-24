//
//  YWEmptyDataSetDataSource.m
//  ywshop
//
//  Created by 前海数交（ZJ） on 2018/9/6.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YWEmptyDataSetDataSource.h"

@interface YWEmptyDataSetDataSource ()



@end

@implementation YWEmptyDataSetDataSource

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    return [self initWithScrollView:scrollView title:nil];
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                             title:(NSString *)aTitle {
    return [self initWithScrollView:scrollView imageName:nil title:aTitle];
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                         imageName:(NSString *)anImageName
                             title:(NSString *)aTitle {
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        _imageName = anImageName ?: @"empty";
        _title = aTitle ?: kLocat(@"empty_msg");
        _descriptionString = kLocat(@"MJRefreshHeaderIdleText");
    }
    
    return self;
}


#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:self.imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:self.title attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18.]}];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:self.descriptionString];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return self.verticalyOffset;
}

#pragma mark - Setters

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.scrollView reloadEmptyDataSet];
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    [self.scrollView reloadEmptyDataSet];
}

@end
