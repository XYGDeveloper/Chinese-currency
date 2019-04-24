//
//  HBSubscribeMenuViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^HBSubscribeMenuViewControllerOperatedDoneBlock)(void);

@class HBSubscribeModel;

@interface HBSubscribeMenuViewController : UIViewController

@property (nonatomic, strong) HBSubscribeModel *model;
@property (nonatomic, copy) HBSubscribeMenuViewControllerOperatedDoneBlock operatedDoneBlock;

+ (instancetype)fromStoryboard;

- (void)showInViewController:(UIViewController *)vc;

- (void)hideWithCompletion:(void(^)(void))completion;

- (void)hide;

@end

