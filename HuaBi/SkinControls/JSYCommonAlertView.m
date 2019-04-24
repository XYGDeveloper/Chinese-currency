//
//  JSYCommonAlertView.m
//  jys
//
//  Created by 周勇 on 2017/5/8.
//  Copyright © 2017年 前海数交所. All rights reserved.
//

#import "JSYCommonAlertView.h"


@interface JSYCommonAlertView ()
{
    BOOL _firstDisplay;
}
@property(nonatomic,strong)UIView *dimView;
@property(nonatomic,strong)UIView *alertView;
@property(nonatomic,copy)NSString *title;

@end

@implementation JSYCommonAlertView

+(instancetype)sharedAlertView
{
    static JSYCommonAlertView *hud = nil;
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    hud = [JSYCommonAlertView new];
    //    });
    return hud;
}


-(void)showAlertViewWithTitle:(NSString *)title messsage:(NSString *)messsage
{
    _title = title;
    UIView *dimView = [[UIView alloc]initWithFrame:kScreenBounds];
    dimView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
    [kKeyWindow addSubview:dimView];
    dimView.userInteractionEnabled = YES;
    [dimView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeDimVeiw)]];

    
    UIView *alertView = [[UIView alloc]initWithFrame:kRectMake(43 * [Utilities stdScreenRatio], 282 * kScreenHeightRatio,580 / 2 * [Utilities stdScreenRatio], 140)];
    [dimView addSubview:alertView];
    alertView.userInteractionEnabled = YES;
    kViewBorderRadius(alertView, 5, 0, kWhiteColor);
    alertView.backgroundColor = kWhiteColor;
    _alertView = alertView;
    [self alertViewAnimation];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:kRectMake(kMargin, 20, alertView.width - 2 *kMargin, 18)];
    [alertView addSubview:titleLabel];
    
    titleLabel.textColor = k323232Color;
    if (title) {
        titleLabel.text = title;
    }else{
        titleLabel.text = kLocat(@"C_Tip");
    }
    titleLabel.font = PFRegularFont(18);
    titleLabel.textAlignment = NSTextAlignmentCenter;


    
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:kRectMake(kMargin, 50, alertView.width - 2 * kMargin, 14)];
    [alertView addSubview:messageLabel];
    messageLabel.textColor = titleLabel.textColor;
    messageLabel.text = messsage;
    messageLabel.font = PFLihgtFont(14);
    messageLabel.textAlignment = NSTextAlignmentCenter;
    
    messageLabel.adjustsFontSizeToFitWidth = YES;
    _alertView = alertView;
    _dimView = dimView;

    UIView *lineView = [[UIView alloc]initWithFrame:kRectMake(0, 84, alertView.width, 0.5)];
    lineView.backgroundColor = kColorFromStr(@"e6e6e6");
    [alertView addSubview:lineView];
    
    UILabel *confirmButton = [[UILabel alloc]initWithFrame:kRectMake(0, lineView.bottom, alertView.width, alertView.height - lineView.bottom)];
    confirmButton.textColor = kBlueColor;
    confirmButton.text = kLocat(@"Confirm");
    confirmButton.font = PFRegularFont(18);
    confirmButton.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:confirmButton];
    confirmButton.userInteractionEnabled = YES;
    [confirmButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeDimVeiw)]];
    
}
-(void)showAlertViewWithCancelButtonTitle:(NSString *)title messsage:(NSString *)messsage
{
    _title = title;
    UIView *dimView = [[UIView alloc]initWithFrame:kScreenBounds];
    dimView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
    [kKeyWindow addSubview:dimView];
    dimView.userInteractionEnabled = YES;
//    [dimView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeDimVeiw)]];
    
    
    UIView *alertView = [[UIView alloc]initWithFrame:kRectMake(43 * [Utilities stdScreenRatio], 282 * kScreenHeightRatio,580 / 2 * [Utilities stdScreenRatio], 140)];
    [dimView addSubview:alertView];
    alertView.userInteractionEnabled = YES;
    kViewBorderRadius(alertView, 5, 0, kWhiteColor);
    alertView.backgroundColor = kWhiteColor;
    _alertView = alertView;
    [self alertViewAnimation];
    
    CGFloat y;
    if (messsage.length < 2) {
        y = 35;
    }else{
        y = 20;
    }
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:kRectMake(kMargin, y, alertView.width - 2 *kMargin, 18)];
    [alertView addSubview:titleLabel];
    
    titleLabel.textColor = k323232Color;
    if (title) {
        titleLabel.text = title;
    }else{
        titleLabel.text = kLocat(@"C_Tip");
    }
    titleLabel.font = PFRegularFont(18);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:kRectMake(kMargin, 50, alertView.width - 2 * kMargin, 14)];
    [alertView addSubview:messageLabel];
    messageLabel.textColor = titleLabel.textColor;
    messageLabel.text = messsage;
    messageLabel.font = PFLihgtFont(14);
    messageLabel.textAlignment = NSTextAlignmentCenter;
    
    messageLabel.adjustsFontSizeToFitWidth = YES;
    _alertView = alertView;
    _dimView = dimView;
    
    UIView *lineView = [[UIView alloc]initWithFrame:kRectMake(0, 84, alertView.width, 0.5)];
    lineView.backgroundColor = kColorFromStr(@"e6e6e6");
    [alertView addSubview:lineView];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:kRectMake(0, lineView.bottom, alertView.width/2 , alertView.height - lineView.bottom)];
    [cancelButton setTitle:kLocat(@"Cancel") forState:UIControlStateNormal];
    [cancelButton setTitleColor:k323232Color forState:UIControlStateNormal];
    [alertView addSubview:cancelButton];
    cancelButton.titleLabel.font = PFRegularFont(18);
    [cancelButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeDimVeiw)]];


    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:kRectMake(alertView.width/2, lineView.bottom, alertView.width/2, alertView.height - lineView.bottom)];
    [confirmButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    [confirmButton setTitle:kLocat(@"Confirm") forState:UIControlStateNormal];
    confirmButton.titleLabel.font = PFRegularFont(18);
    [alertView addSubview:confirmButton];
    
    [confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.userInteractionEnabled = YES;
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:kRectMake(cancelButton.right, cancelButton.top, 0.5, cancelButton.height)];
    [alertView addSubview:bottomLine];
    bottomLine.backgroundColor = kColorFromStr(@"e6e6e6");
    
}
-(void)confirmAction
{
    if ([self.delegate respondsToSelector:@selector(didClickConfirmButton)]) {
        [self.delegate didClickConfirmButton];
    }
    [self removeDimVeiw];

 
}


-(void)alertViewAnimation
{
    //    __weak typeof(self)weakSelf = self;
    //    self.alertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    //    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
    //       weakSelf.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    //    } completion:^(BOOL finished) {
    //    }];
    
//    if (_firstDisplay) {
//        _firstDisplay = NO;
    
        _alertView.alpha = 0;
        _alertView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _alertView.transform = CGAffineTransformIdentity;
            _alertView.alpha = 1;
        } completion:nil];
        
//    }
}
-(void)removeDimVeiw
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _alertView.alpha = 0;
        _dimView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [weakSelf.alertView removeFromSuperview];
        [weakSelf.dimView removeFromSuperview];
        weakSelf.alertView = nil;
        weakSelf.dimView = nil;
        
    }];
    
    if ([self.title isEqualToString:@"邮箱设置成功"]) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kDidClickAlertViewButtonKey object:@(1)];
    }else{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kDidClickAlertViewButtonKey object:@(0)];
    }

}





@end
