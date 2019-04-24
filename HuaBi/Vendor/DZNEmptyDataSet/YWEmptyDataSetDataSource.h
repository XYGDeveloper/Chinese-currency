//
//  YWEmptyDataSetDataSource.h
//  ywshop
//
//  Created by 前海数交（ZJ） on 2018/9/6.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "UIScrollView+EmptyDataSet.h"

@interface YWEmptyDataSetDataSource : NSObject <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descriptionString;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat verticalyOffset;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                             title:(NSString *)aTitle;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                         imageName:(NSString *)anImageName
                             title:(NSString *)aTitle;

@end
