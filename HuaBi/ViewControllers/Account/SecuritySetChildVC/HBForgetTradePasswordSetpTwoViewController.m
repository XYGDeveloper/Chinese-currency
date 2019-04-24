//
//  HBForgetTradePasswordSetpTwoViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/19.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBForgetTradePasswordSetpTwoViewController.h"
#import "UITextField+ChangeClearButton.h"
#import "NSObject+SVProgressHUD.h"

@interface HBForgetTradePasswordSetpTwoViewController ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation HBForgetTradePasswordSetpTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.title = kLocat(@"Find transaction password");
    [self.containerViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kThemeColor;
    }];
    [self.passwordTextField _changeClearButton];
    [self.repasswordTextField _changeClearButton];
    self.nameLabel.text = kLocat(@"Please set a new transaction password");
    [self.sureButton setTitle:kLocat(@"Find transaction password submit") forState:UIControlStateNormal];
    self.passwordTextField.placeholder = kLocat(@"New password_6-digit number");
    self.repasswordTextField.placeholder = kLocat(@"Confirm password_6-digit number");
}

#pragma mark - Action

- (IBAction)submitAction:(UIButton *)sender {
    NSString *pwd = self.passwordTextField.text;
    NSString *repwd = self.repasswordTextField.text;
    
    if (pwd.length == 0 || repwd.length == 0) {
        [self showInfoWithMessage:kLocat(@"LEnterTransactionPWD")];
        return;
    }
    
    if (![pwd isEqualToString:repwd]) {
        [self showInfoWithMessage:kLocat(@"modifyPassword_same")];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"pwd" : pwd ?: @"",
                                 @"repwd" : repwd ?: @"",
                                 };
    
    kShowHud;
    sender.enabled = NO;
    [kNetwork_Tool objPOST:@"/Api/Account/update_trade_pwd" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        sender.enabled = YES;
        if ([model succeeded]) {
            [self showSuccessWithMessage:model.message];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            [self showInfoWithMessage:model.message];
        }
    } failure:^(NSError *error) {
        sender.enabled = YES;
        [self showInfoWithMessage:error.localizedDescription];
    }];
}

@end
