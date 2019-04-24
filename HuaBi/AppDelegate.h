//
//  AppDelegate.h
//  YJOTC
//
//  Created by 周勇 on 2017/12/22.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
// Hang Sheng Technology Building,Gaoxin South Six Avenue,Nanshan D

#import <UIKit/UIKit.h>

//开启侧滑返回
#define kUseScreenShotGesture 1
#if kUseScreenShotGesture
#import "ScreenShotView.h"
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>
//
@property (assign , nonatomic) BOOL isForceLandscape;
@property (assign , nonatomic) BOOL isForcePortrait;
//
@property (strong, nonatomic) UIWindow *window;

#if kUseScreenShotGesture
@property (strong, nonatomic) ScreenShotView *screenshotView;
#endif



@end

