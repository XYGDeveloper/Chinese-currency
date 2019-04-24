//
//  HBForgetTradePasswordViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/19.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBForgetTradePasswordViewController.h"
#import "UIViewController+HBLoadingView.h"
#import "NSObject+SVProgressHUD.h"
#import "UIButton+LSSmsVerification.h"
#import "NTESVerifyCodeManager+HB.h"
#import "HBLoginRequest.h"
#import "UITextField+ChangeClearButton.h"

@interface HBForgetTradePasswordViewController () <NTESVerifyCodeManagerDelegate>
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray<UIView *> *containerViews;
@property (weak, nonatomic) IBOutlet UITextField *phoneOrEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic, assign) BOOL isEmail;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation HBForgetTradePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocat(@"Find transaction password");
    [self.containerViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kThemeColor;
    }];
    [self.phoneOrEmailTextField _changeClearButton];
    [self.codeTextField _changeClearButton];
    [self _requestUserAccount];
    
    [self.nextButton setTitle:kLocat(@"OTC_post_next") forState:UIControlStateNormal];
    self.codeTextField.placeholder = kLocat(@"HBForgetPasswordTableViewController_valcode_placehoder");
    [self.sendCodeButton setTitle:kLocat(@"E_LocationSend") forState:UIControlStateNormal];
    self.nameLabel.text = kLocat(@"Safety verification");
}



#pragma mark - Private

- (void)_requestUserAccount {
    [self showLoadingView];
    [kNetwork_Tool objPOST:@"/Api/Account/get_user_account" parameters:nil success:^(YWNetworkResultModel *model, id responseObject) {
        [self hideLoadingView];
        if ([model succeeded]) {
            NSString *phone = [model.result ksObjectForKey:@"phone"];
            self.phoneOrEmailTextField.text = phone;
            NSInteger type = [[model.result ksObjectForKey:@"type"] integerValue];
            self.isEmail = type != 2;
        } else {
            [self showInfoWithMessage:model.message];
        }
    } failure:^(NSError *error) {
        [self hideLoadingView];
        [self showInfoWithMessage:error.localizedDescription];
    }];
}



#pragma mark - Action

- (IBAction)nextAction:(UIButton *)sender {
    
    NSString *phoneOrEmail = self.phoneOrEmailTextField.text;
    
    if (phoneOrEmail.length == 0) {
        return;
    }
    
    NSString *code = self.codeTextField.text;
    if (code.length == 0) {
        [self showInfoWithMessage:kLocat(@"LEnterVerificationCode")];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"phone" : phoneOrEmail ?: @"",
                                 @"phone_code" : code ?: @"",
                                 @"type" : @"findtradepwd",
                                 };
    
    kShowHud;
    sender.enabled = NO;
    [kNetwork_Tool objPOST:@"/Api/Account/checkSmsCaptcha1" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        sender.enabled = YES;
        if ([model succeeded]) {
            kHideHud;
            [self performSegueWithIdentifier:@"showStepTwoOfFindTradePasswrdVC" sender:nil];
        } else {
            [self showInfoWithMessage:model.message];
        }
    } failure:^(NSError *error) {
        sender.enabled = YES;
        [self showInfoWithMessage:error.localizedDescription];
    }];
}

- (IBAction)sendCodeAction:(UIButton *)sender {
    if (self.phoneOrEmailTextField.text.length == 0) {
        return;
    }
    NTESVerifyCodeManager *manager = [NTESVerifyCodeManager getHBManager];
    manager.delegate = self;
    [manager openVerifyCodeView];
}

#pragma mark - NTESVerifyCodeManagerDelegate

- (void)verifyCodeValidateFinish:(BOOL)result
                        validate:(NSString *)validate
                         message:(NSString *)message
{
    
    if (result == YES) {
        NSString *userName = self.phoneOrEmailTextField.text;
        if (self.phoneOrEmailTextField.text.length == 0) {
            return;
        }
        
        void(^success)(YWNetworkResultModel *model) = ^(YWNetworkResultModel *model) {
            if ([model succeeded]) {
                [self showSuccessWithMessage:model.message];
                [self.sendCodeButton startTimeWithDuration:60 backgroundColor:[UIColor clearColor] titleColor:kColorFromStr(@"#999999")];
            } else {
                [self showInfoWithMessage:model.message];
            }
        };
        
        void(^failure)(NSError *error) = ^(NSError *error) {
            [self showErrorWithMessage:error.localizedDescription];
        };
        
        kShowHud;
        if (self.isEmail) {
            [HBLoginRequest sendFindtradepwdEmail:userName validate:validate success:success failure:failure];
        } else {
            [HBLoginRequest sendFindtradepwdSMSWithPhone:userName validate:validate success:success failure:failure];
        }
    }
}

@end

