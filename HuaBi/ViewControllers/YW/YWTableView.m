//
//  YWTableView.m
//  ywshop
//
//  Created by 前海数交（ZJ） on 2018/8/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YWTableView.h"


NSInteger const YWShouldRecognizeSimultaneouslyWithGestureRecognizerTag = 110;

@implementation YWTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (otherGestureRecognizer.view.tag == YWShouldRecognizeSimultaneouslyWithGestureRecognizerTag) {
        return YES;
    }
    
    return NO;
}

@end
