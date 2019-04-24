//
//  HBConfirmOrderPasswordView.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/11.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBConfirmOrderPasswordView.h"
#import "XLBKeyboardMan.h"

@interface HBConfirmOrderPasswordView () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (nonatomic, assign) BOOL isShowing;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (nonatomic, strong) XLBKeyboardMan *keyboardMan;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *passwordContainerView;

@end

@implementation HBConfirmOrderPasswordView


#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self hideWithCompletion:^{
            if (self.cancelBlock) {
                self.cancelBlock();
            }
        }];
    }];
    tapGR.delegate = self;
    [self addGestureRecognizer:tapGR];
    self.passwordContainerView.layer.borderColor = kCCCCCC_Color.CGColor;
    self.passwordContainerView.layer.borderWidth = 1;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.bottomContainerView]) {
        return NO;
    }
    
    return YES;
}


#pragma mark - Actions

- (IBAction)cancelAction:(id)sender {
    [self hideWithCompletion:^{
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }];
}

- (IBAction)sureAction:(id)sender {
    if (self.didSureBlock) {
        self.didSureBlock(self.passwordTextField.text);
    }
    
//    [self hide];
}

#pragma mark - Setters

- (void)setOrderNO:(NSString *)orderNO {
    _orderNO = orderNO;
    
    self.orderNoLabel.text = orderNO ?: @"--";
}

#pragma mark - Public

- (void)showInWindow {
    if (self.isShowing) {
        return;
    }
    self.isShowing = YES;
    self.frame = kKeyWindow.bounds;
    [kKeyWindow addSubview:self];
    self.bottomContainerView.bottom = kScreenH + 260;
    self.keyboardMan = [[XLBKeyboardMan alloc] initWithKeyboardAppearBlock:^(NSInteger appearPostIndex, CGFloat keyboardHeight, CGFloat keyboardIncrementHeight) {
        self.bottomContainerView.bottom -= keyboardIncrementHeight;
    } disappearBlock:^(CGFloat keyboardHeight) {
        self.bottomContainerView.bottom += keyboardHeight;
    }];
    [UIView animateWithDuration:0.25 delay:0 options:(7 << 16) animations:^{
        self.bottomContainerView.bottom = kScreenH;
    } completion:^(BOOL finished) {
        
    }];
}


- (void)hide {
    [self hideWithCompletion:nil];
}

- (void)hideWithCompletion:(void(^)(void))completion {
    if (!self.isShowing) {
        return;
    }
    
    self.isShowing = NO;
    [UIView animateWithDuration:0.25 delay:0 options:(6 << 16) animations:^{
        self.bottomContainerView.bottom = kScreenH + 260;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
        [self.superview removeFromSuperview];
        [self removeFromSuperview];
        
    }];
}

@end
