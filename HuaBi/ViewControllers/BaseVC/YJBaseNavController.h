//
//  YJBaseNavController.h
//  YJOTC
//
//  Created by 周勇 on 2017/12/22.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJBaseNavController : UINavigationController

@property (strong ,nonatomic) NSMutableArray *arrayScreenshot;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic , assign) UIInterfaceOrientation interfaceOrientation;
@property (nonatomic , assign) UIInterfaceOrientationMask interfaceOrientationMask;

@end
