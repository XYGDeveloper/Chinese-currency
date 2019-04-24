//
//  HBLoginTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBLoginTableViewController.h"
#import "UITextField+ChangeClearButton.h"
#import "HBLoginRequest.h"
#import "NSObject+SVProgressHUD.h"
#import "UIButton+Style.h"
#import "BARegularExpression.h"
#import "XLBKeyboardMan.h"
#import "HBPasswordOrVerifyInputView.h"

@interface HBLoginTableViewController ()<NTESVerifyCodeManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *canbtn;
//取消
@property (weak, nonatomic) IBOutlet UILabel *LoginDes;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UILabel *regisDes;
@property (weak, nonatomic) IBOutlet UIButton *regisBtn;

@property(nonatomic,strong)NTESVerifyCodeManager *manager;

@property (nonatomic, strong) XLBKeyboardMan *keyboardMan;

@property (nonatomic, assign) BOOL isNeedVerifyCode;

@property (nonatomic, strong) HBPasswordOrVerifyInputView *verifyCodeInputView;

@property (nonatomic, assign) BOOL isSendSMSInProgress;

@end

@implementation HBLoginTableViewController

+ (instancetype)fromStoryboard {
    return [UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.phoneTextField _changeClearButton];
    [self.passwordTextField _changeClearButton];
    self.phoneTextField.placeholder = kLocat(@"R_EMailOrPhone");
    self.passwordTextField.placeholder = kLocat(@"HBLoginTableViewController_password_placehoder");
    [self.phoneTextField setValue:kColorFromStr(@"#37415C") forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTextField setValue:kColorFromStr(@"#37415C") forKeyPath:@"_placeholderLabel.textColor"];
    [self.canbtn setTitle:kLocat(@"net_alert_load_message_cancel") forState:UIControlStateNormal];
    self.LoginDes.text = kLocat(@"HBLoginTableViewController_des");
 
    [self.loginBtn setTitle:kLocat(@"HBLoginTableViewController_password_login") forState:UIControlStateNormal];
     [self.forgetBtn setTitle:kLocat(@"HBLoginTableViewController_password_forgetpwd") forState:UIControlStateNormal];
    self.regisDes.text = kLocat(@"HBLoginTableViewController_password_regisDes");
    [self.regisBtn setTitle:kLocat(@"HBLoginTableViewController_password_regis") forState:UIControlStateNormal];
    

    if ([kUserDefaults objectForKey:@"kUserLoginAccountKey"]) {
        self.phoneTextField.text = [kUserDefaults objectForKey:@"kUserLoginAccountKey"];
    }

    
    [self.loginBtn _setupStyle];
    self.loginBtn.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    __weak typeof(self) weakSelf = self;
    self.keyboardMan = [[XLBKeyboardMan alloc] initWithKeyboardAppearBlock:^(NSInteger appearPostIndex, CGFloat keyboardHeight, CGFloat keyboardIncrementHeight) {
        CGFloat distanceToBottom = kScreenH - [weakSelf.loginBtn convertPoint:CGPointMake(0, weakSelf.loginBtn.bottom) toView:weakSelf.view].y;
        CGFloat offsetY = keyboardHeight - distanceToBottom;
        if (offsetY > 0) {
            [weakSelf.tableView setContentOffset:CGPointMake(0, offsetY)];
        }
    } disappearBlock:^(CGFloat keyboardHeight) {
        [weakSelf.tableView setContentOffset:CGPointMake(0, 0)];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Private


-(void)showVerifyInfo
{
    if (self.phoneTextField.text.length == 0) {
        [self showTips:kLocat(@"LEnterPhoneNumber")];
        return;
    }
    
    [self.view endEditing:YES];
    
    [self.manager openVerifyCodeView:nil];
    
}

- (void)verifyCodeInitFailed:(NSString *)error {
    [self showErrorWithMessage:error];
}

- (void)verifyCodeNetError:(NSError *)error {
    [self showErrorWithMessage:error.localizedDescription];
}

- (void)verifyCodeValidateFinish:(BOOL)result
                        validate:(NSString *)validate
                         message:(NSString *)message
{

    if (result == YES) {
        if (self.isNeedVerifyCode) {
            [self _showGetVerifyCodeView];
        } else {
            [self _loginWithValidate:validate phoneCode:nil];
        }
    }else{
        [self showTips:@"验证码错误"];
    }
}


- (void)_showGetVerifyCodeView {
    self.verifyCodeInputView = [HBPasswordOrVerifyInputView getVerifyCodeView];
    self.verifyCodeInputView.passwordLabel.text = self.phoneTextField.text;
    [self.verifyCodeInputView showInWindow];
    __weak typeof(self) weakSelf = self;
    [self.verifyCodeInputView startCountDownTime];
    self.verifyCodeInputView.sendBlock = ^(UIButton * _Nonnull sendButton) {
        [weakSelf getVerifyCode];
    };
    self.verifyCodeInputView.callBackBlock = ^(UIButton * _Nonnull sureButton, NSString * _Nonnull text) {
        if (text.length <= 0) {
            return ;
        }
        [weakSelf _loginWithValidate:nil phoneCode:text];
    };
}

- (void)getVerifyCode {
    if (self.isSendSMSInProgress) {
        return;
    }
    self.isSendSMSInProgress = YES;
    NSDictionary *parameters = @{@"account" : (self.phoneTextField.text ?: @"")};
    kShowHud;
    [kNetwork_Tool objPOST:@"/Api/Account/sms_send" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        kHideHud;
        self.isSendSMSInProgress = NO;
        if (model.succeeded) {
            [self.verifyCodeInputView startCountDownTime];
        } else {
            [self showTips:model.message];
        }
    } failure:^(NSError *error) {
        self.isSendSMSInProgress = NO;
        kHideHud;
        [self showTips:error.localizedDescription];
    }];
}

static NSInteger const kNeedVerifyCodeValue = 11000;

- (void)_loginWithValidate:(NSString *)validate phoneCode:(NSString *)phoneCode {
    NSString *phone = self.phoneTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (phone.length == 0 || password.length == 0) {
        return;
    }
    
    [self.view endEditing:YES];
    kShowHud;
    [HBLoginRequest loginWithPhone:phone
                  isNeedVerifyCode:self.isNeedVerifyCode
                          password:password
                          validate:validate
                         phoneCode:phoneCode success:^(YWNetworkResultModel *model)
    {
        kHideHud;
        if ([model succeeded]) {
            [self.verifyCodeInputView hide];
            [self showSuccessWithMessage:model.message];
            [kUserDefaults setObject:phone forKey:@"kUserLoginAccountKey"];
            
            //保存数据
            YJUserInfo *userInfo = [YJUserInfo mj_objectWithKeyValues:model.result];
            [kUserDefaults setInteger:userInfo.uid forKey:kUserIDKey];
            [userInfo saveUserInfo];
            
            [kUserDefaults setObject:[NSDate date] forKey:@"kLastLoginTimeKey"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessKey object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self cancelAction:nil];
            });
        } else if (model.code == kNeedVerifyCodeValue) {
            self.isNeedVerifyCode = YES;
            [self _showGetVerifyCodeView];
        } else {
            [self showInfoWithMessage:model.message];
        }
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        [self showErrorWithMessage:error.localizedDescription];
    }];
    
}


#pragma mark - Actions

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginAction:(id)sender {
    [self showVerifyInfo];
}

- (NTESVerifyCodeManager *)manager {
    if (!_manager) {
        _manager = [NTESVerifyCodeManager sharedInstance];
        _manager.delegate = self;
        _manager.alpha = 0;
        _manager.frame = CGRectNull;
        NSString *captchaId = kVerifyKey;
        [_manager configureVerifyCode:captchaId timeout:7];
    }
    
    return _manager;
}

#pragma mark - Action

- (void)_textFieldDidChanged:(UITextField *)textField {
    NSString *phone = self.phoneTextField.text;
    NSString *pwd = self.passwordTextField.text;
    BOOL isPhone = [BARegularExpression ba_isAllNumber:phone] && phone.length >= 5;
    
    BOOL isPhoneOrEmail = isPhone || [BARegularExpression ba_isEmailQualified:phone];

    self.loginBtn.enabled = isPhoneOrEmail && pwd.length > 0;
}

@end
