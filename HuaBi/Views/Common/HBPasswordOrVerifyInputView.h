//
//  passwordView.h
//  HuaBi
//
//  Created by l on 2019/2/22.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ConfirmBlcok) (UIButton *sureButton, NSString *text);
typedef void(^sendBlcok) (UIButton *sendButton);

@interface HBPasswordOrVerifyInputView : UIView
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property(nonatomic,copy)ConfirmBlcok callBackBlock;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property(nonatomic,copy)sendBlcok sendBlock;

+ (instancetype)getVerifyCodeView;

+ (instancetype)getPasswordView;

- (void)showInWindow;

- (void)hide;

- (void)hideWithCompletion:(void(^)(void))completion;

- (void)startCountDownTime;

@end

