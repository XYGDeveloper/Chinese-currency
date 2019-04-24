//
//  XNEffectListViewController.h
//  YJOTC
//
//  Created by l on 2018/7/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "SegmentScrollView.h"

@implementation SegmentScrollView
     
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint velocity = [pan velocityInView:self];
        if (velocity.x > 0) {
            CGPoint location = [pan locationInView:self];
            return location.x > [UIScreen mainScreen].bounds.size.width;
        }
    }
    
    return YES;
}

@end
