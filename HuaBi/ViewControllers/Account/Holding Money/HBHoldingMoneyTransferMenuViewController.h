//
//  HBHoldingMoneyTransferMenuViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HBHoldingMoneyTransferMenuViewControllerOperatedDoneBlock)(void);

@class HBMoneyInterestSettingModel;
@interface HBHoldingMoneyTransferMenuViewController : UIViewController

@property (nonatomic, strong) HBMoneyInterestSettingModel *model;
@property (nonatomic, copy) HBHoldingMoneyTransferMenuViewControllerOperatedDoneBlock operatedDoneBlock;

+ (instancetype)fromStoryboard;

- (void)showInViewController:(UIViewController *)vc;

- (void)hideWithCompletion:(void(^)(void))completion;

- (void)hide;

@end

