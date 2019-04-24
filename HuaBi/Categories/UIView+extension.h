//
//  UIView+extension.h
//  XYLScaningCode
//
//  Created by 薛银亮 on 16/2/23.
//  Copyright © 2016年 薛银亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

+(instancetype)viewLoadNib;
// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen;

/** 垂直方向上居中  x*/
- (void)alignHorizontal;

/** 水平方向上居中 y*/
- (void)alignVertical;

@end
