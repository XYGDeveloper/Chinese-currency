//
//  UIColor+KS.m
//  TEST
//
//  Created by 周勇 on 16/12/29.
//  Copyright © 2016年 周勇. All rights reserved.
//

#import "UIColor+KS.h"

@implementation UIColor (KS)


+ (UIColor*)colorWighR:(float)rValue
               GValue:(float)gValue
               BValue:(float)bValue
               AValue:(float)aValue;
{
    return [UIColor colorWithRed: rValue/255.0 green: gValue/255.0 blue: bValue/255.0 alpha: aValue];
}

// 16进制颜色值
+ (UIColor*)colorFromStr:(NSString *)str;
{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    if (![str containsString:@"#"]) {
        str = [NSString stringWithFormat:@"#%@",str];
    }
    
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}

+ (void)getRGBAFromUIColor:(UIColor*)color
                   rValue:(float*)r
                   gValue:(float*)g
                   bValue:(float*)b
                   aValue:(float*)a;
{
    CGFloat components[4];
    
    if (color) {
        // Get the color's RGBA components.
        [color getRed:&components[0] green:&components[1] blue:&components[2] alpha:&components[3]];
        *r = components[0];
        *g = components[1];
        *b = components[2];
        *a = components[3];
    } else {
        *r = 0;
        *g = 0;
        *b = 0;
        *a = 1;
    }
}


@end
