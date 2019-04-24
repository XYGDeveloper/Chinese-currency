//
//  UIFont+KS.h
//
//  Created by 周勇 on 16/12/29.
//  Copyright © 2016年 周勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (KS)

/**  中黑  */
+(UIFont*)pingFangSC_MediumFontSize:(float)fontSz;

/**  常规  */
+(UIFont*)pingFangSC_RegularFontSize:(float)fontSz;

/**  细体  */
+(UIFont*)pingFangSC_LightFontSize:(float)fontSz;

/**  中粗  */
+(UIFont*)pingFangSC_SemiboldFontSize:(float)fontSz;


/**  Mono 字体 粗体  */
+(UIFont*)Mono_SemiboldFontSize:(float)fontSz;

/**  Mono 字体 常规  */
+(UIFont*)Mono_RegularFontSize:(float)fontSz;


//冬青黑体简体中文w3
+(UIFont*)HiraginoSansW3FontSize:(float)fontSz;


@end
