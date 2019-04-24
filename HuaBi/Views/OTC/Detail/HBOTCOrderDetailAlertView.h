//
//  HBOTCOrderDetailAlertView.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/4.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HBOTCOrderDetailAlertView;
@protocol HBOTCOrderDetailAlertViewDelegate <NSObject>

- (void)didSelectSureWithOrderDetailAlertView:(HBOTCOrderDetailAlertView *)view;

@end

@interface HBOTCOrderDetailAlertView : UIView

@property (nonatomic, weak) id<HBOTCOrderDetailAlertViewDelegate> delegate;

+ (instancetype)loadNibView;

- (void)showInWindow;

- (void)showInView:(UIView *)view;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
