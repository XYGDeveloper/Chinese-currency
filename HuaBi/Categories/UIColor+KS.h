//
//  UIColor+KS.h
//  TEST
//
//  Created by 周勇 on 16/12/29.
//  Copyright © 2016年 周勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KS)

+ (UIColor*)colorWighR:(float)rValue
               GValue:(float)gValue
               BValue:(float)bValue
               AValue:(float)aValue;

+ (UIColor*)colorFromStr:(NSString *)str;

+ (void)getRGBAFromUIColor:(UIColor*)color
                   rValue:(float*)r
                   gValue:(float*)g
                   bValue:(float*)b
                   aValue:(float*)a;


@end
