//
//  UIFont+KS.m
//
//  Created by 周勇 on 16/12/29.
//  Copyright © 2016年 周勇. All rights reserved.
//

#import "UIFont+KS.h"

@implementation UIFont (KS)

+(UIFont*)pingFangSC_RegularFontSize:(float)fontSz
{
    if (kScreenW < 321) {
        fontSz = fontSz * 0.92;
    }
    
    UIFont *ft = [UIFont fontWithName: kPFRegularFtName size: (int)fontSz];
    if (ft == nil) {
        ft = [UIFont systemFontOfSize: fontSz];
    }
    return ft;
}

+(UIFont*)pingFangSC_MediumFontSize:(float)fontSz
{
    if (kScreenW <321) {
        fontSz = fontSz * 0.92;
    }
    UIFont *ft = [UIFont fontWithName: kPFMediumFtName size: (int)fontSz];
    if (ft == nil) {
        ft = [UIFont systemFontOfSize: fontSz];
    }
    return ft;
}
+(UIFont*)pingFangSC_LightFontSize:(float)fontSz
{
    if (kScreenW <321) {
        fontSz = fontSz * 0.92;
    }
    UIFont *ft = [UIFont fontWithName: kPFLightFtName size: (int)fontSz];
    if (ft == nil) {
        ft = [UIFont systemFontOfSize: fontSz];
    }
    return ft;
}
//中粗
+(UIFont*)pingFangSC_SemiboldFontSize:(float)fontSz
{
    if (kScreenW < 321) {
        fontSz = fontSz * 0.92;
    }
    UIFont *ft = [UIFont fontWithName: kPFSemiboldFtName size: (int)fontSz];
    if (ft == nil) {
        ft = [UIFont systemFontOfSize: fontSz];
    }
    return ft;
}

/**  Mono 字体 粗体  */
+(UIFont*)Mono_SemiboldFontSize:(float)fontSz
{
    UIFont *ft = [UIFont fontWithName: @"PTMono-Bold" size: (int)fontSz];
    if (ft == nil) {
        ft = [UIFont systemFontOfSize: fontSz];
    }
    return ft;
}

/**  Mono 字体 常规  */
+(UIFont*)Mono_RegularFontSize:(float)fontSz
{
    UIFont *ft = [UIFont fontWithName: @"PTMono-Regular" size: (int)fontSz];
    if (ft == nil) {
        ft = [UIFont systemFontOfSize: fontSz];
    }
    return ft;
}
//冬青黑体简体中文w3      HiraginoSans-W3   HiraginoSans-W6
+(UIFont*)HiraginoSansW3FontSize:(float)fontSz
{
    UIFont *ft = [UIFont fontWithName: @"HiraginoSansGB-W3" size: (int)fontSz];
    if (ft == nil) {
        ft = [UIFont systemFontOfSize: fontSz];
    }
    return ft;
}

@end
