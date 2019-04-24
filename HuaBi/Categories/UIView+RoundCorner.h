//
//  UIView+RoundedCorner.h
//  xfj
//
//  Created by ZhangJing on 16/10/9.
//  Copyright © 2016年 xlbyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RoundCorner)


- (void)roundWithRadius:(CGFloat)radius;

/**
 *  切顶部圆角，不带边框
 *
 *  @param radius 圆角大小
 */
- (void)roundTopCornersRadius:(CGFloat)radius;

/**
 *  切底部圆角，不带边框
 *
 *  @param radius 圆角大小
 */
- (void)roundBottomCornersRadius:(CGFloat)radius;

/**
 *  切顶部圆角，自定义边框颜色
 *
 *  @param radius 圆角大小
 */

/**
 *  切顶部圆角，自定义边框颜色
 *
 *  @param radius 圆角大小
 *  @param color  自定义边框颜色
 */
- (void)roundTopCornersRadius:(CGFloat)radius
                  borderColor:(UIColor *)color;

/**
 *  切底部圆角，自定义边框颜色
 *
 *  @param radius 圆角大小
 *  @param color  自定义边框颜色
 */
- (void)roundBottomCornersRadius:(CGFloat)radius
                     borderColor:(UIColor *)color;

- (void)roundRightCornersRadius:(CGFloat)radius;

- (void)roundLeftCornersRadius:(CGFloat)radius;


/**
 *  自定义圆角，不带边框
 *
 *  @param corners 自定义圆角
 *  @param radius  圆角大小
 */
- (void)roundCorners:(UIRectCorner)corners
              radius:(CGFloat)radius;

/**
 *  自定义圆角，自定义边框颜色
 *
 *  @param corners 自定义圆角
 *  @param radius  圆角大小
 *  @param color   自定义边框颜色
 */
- (void)roundCorners:(UIRectCorner)corners
              radius:(CGFloat)radius
         borderColor:(UIColor *)color;

@end
