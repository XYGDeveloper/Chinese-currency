//
//  passwordView.m
//  HuaBi
//
//  Created by l on 2019/2/22.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBPasswordOrVerifyInputView.h"
#import "UIView+RoundCorner.h"
#import "XLBKeyboardMan.h"
#import "UIButton+LSSmsVerification.h"

@interface HBPasswordOrVerifyInputView () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *textFieldContainerView;
@property (nonatomic, strong) XLBKeyboardMan *keyboardMan;

@end

@implementation HBPasswordOrVerifyInputView
-(void)awakeFromNib
{
    [super awakeFromNib];
    _desLabel.text = kLocat(@"Safety verification");
    [_closeButton setTitle:kLocat(@"net_alert_load_message_cancel") forState:UIControlStateNormal];
    _passwordLabel.text = kLocat(@"k_MyassetDetailViewController_alert_lin5");
    _passwordTextfield.keyboardType = UIKeyboardTypeNumberPad;
    _passwordTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTextfield.placeholder = kLocat(@"k_MyassetDetailViewController_alert_lin5_p");
    [_sureButton setTitle:kLocat(@"net_alert_load_message_sure") forState:UIControlStateNormal];
    _sureButton.backgroundColor = kColorFromStr(@"#6189C5");
    [_closeButton addTarget:self action:@selector(hideAction:) forControlEvents:UIControlEventTouchUpInside];
    [_sureButton addTarget:self action:@selector(submitAcion:) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton addTarget:self action:@selector(sendAcion:) forControlEvents:UIControlEventTouchUpInside];
    self.textFieldContainerView.layer.borderWidth = 1. / [UIScreen mainScreen].scale;
    self.textFieldContainerView.layer.borderColor = kCCCCCC_Color.CGColor;
    
    
}

-(void)hideAction:(UIButton *)button
{
    [self hide];
}

-(void)submitAcion:(UIButton *)button
{
    [self endEditing:YES];
    if (self.callBackBlock) {
        self.callBackBlock(button, self.passwordTextfield.text);
    }
    
}

-(void)sendAcion:(UIButton *)button
{
    if (self.sendBlock) {
         self.sendBlock(button);
    }
}

+ (instancetype)getVerifyCodeView {
    HBPasswordOrVerifyInputView *varcodeView = [HBPasswordOrVerifyInputView viewLoadNib];
   varcodeView.desLabel.text = kLocat(@"Safety verification");
    [varcodeView.closeButton setTitle:kLocat(@"net_alert_load_message_cancel") forState:UIControlStateNormal];
    if (kUserInfo.emailOrPhone.length == 11) {
        NSRange range = {3,4};
        NSString *phone =  [kUserInfo.emailOrPhone stringByReplacingCharactersInRange:range withString:@"****"];
        varcodeView.passwordLabel.text = phone;
    }else{
        varcodeView.passwordLabel.text = kUserInfo.emailOrPhone;
    }
    [varcodeView.sendButton setTitle:kLocat(@"k_BindphoneViewController_b0") forState:UIControlStateNormal];
    varcodeView.passwordTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    varcodeView.passwordTextfield.placeholder = kLocat(@"LEnterVerificationCode");
    [varcodeView.sureButton setTitle:kLocat(@"net_alert_load_message_sure") forState:UIControlStateNormal];
    varcodeView.sureButton.backgroundColor = kColorFromStr(@"#6189C5");
    varcodeView.frame = kRectMake(0, kScreenH - 300, kScreenW, 300);
    [varcodeView roundTopCornersRadius:8];
    return varcodeView;
}

+ (instancetype)getPasswordView {
    HBPasswordOrVerifyInputView *passwordView = [HBPasswordOrVerifyInputView viewLoadNib];
    passwordView.desLabel.text = kLocat(@"Safety verification");
    [passwordView.closeButton setTitle:kLocat(@"net_alert_load_message_cancel") forState:UIControlStateNormal];
    passwordView.passwordLabel.text = kLocat(@"k_MyassetDetailViewController_alert_lin5");
    passwordView.passwordTextfield.keyboardType = UIKeyboardTypeNumberPad;
    passwordView.sendButton.hidden = YES;
    passwordView.passwordTextfield.placeholder = kLocat(@"k_MyassetDetailViewController_alert_lin5_p");
    passwordView.passwordTextfield.secureTextEntry = YES;
    [passwordView.sureButton setTitle:kLocat(@"net_alert_load_message_sure") forState:UIControlStateNormal];
    passwordView.sureButton.backgroundColor = kColorFromStr(@"#6189C5");
    passwordView.frame = kRectMake(0, kScreenH - 300, kScreenW, 300);
    [passwordView roundTopCornersRadius:8];
    return passwordView;
}

- (void)showInWindow {
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.64];
    [bgView addSubview:self];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UITapGestureRecognizer  *_Nonnull sender) {
        [self hide];
    }];
    tapGR.delegate = self;
    [bgView addGestureRecognizer:tapGR];
    self.y = kScreenH;
    self.keyboardMan = [[XLBKeyboardMan alloc] initWithKeyboardAppearBlock:^(NSInteger appearPostIndex, CGFloat keyboardHeight, CGFloat keyboardIncrementHeight) {
        self.y -= keyboardIncrementHeight;
    } disappearBlock:^(CGFloat keyboardHeight) {
        self.y += keyboardHeight;
    }];
    [kKeyWindow addSubview:bgView];
    [UIView animateWithDuration:0.25 delay:0 options:(7 << 16) animations:^{
        self.y = kScreenH - 300;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    [self hideWithCompletion:nil];
}

- (void)hideWithCompletion:(void(^)(void))completion {
    self.keyboardMan = nil;
    [UIView animateWithDuration:0.25 delay:0 options:(6 << 16) animations:^{
        self.y = kScreenH;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
        [self.superview removeFromSuperview];
        [self removeFromSuperview];
       
    }];
}

- (void)startCountDownTime {
    [self.sendButton startTimeWithDuration:60 backgroundColor:[UIColor clearColor] titleColor:kCCCCCC_Color];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self]) {
        return NO;
    }
    return YES;
}

@end
