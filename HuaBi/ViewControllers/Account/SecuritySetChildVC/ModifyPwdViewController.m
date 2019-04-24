//
//  ModifyPwdViewController.m
//  YJOTC
//
//  Created by l on 2018/10/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "ModifyPwdViewController.h"
#import "NSObject+SVProgressHUD.h"

@interface ModifyPwdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPwd;

@property (weak, nonatomic) IBOutlet UITextField *cuPwd;

@property (weak, nonatomic) IBOutlet UITextField *conPwd;

@property (weak, nonatomic) IBOutlet UIButton *comBtn;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswrdButton;


@end

@implementation ModifyPwdViewController


- (IBAction)commitAction:(id)sender {
    //提交
    if (self.oldPwd.text.length <= 0) {
        [self showTips:kLocat(@"modifyPassword_ori")];
        return;
    }
    if (self.cuPwd.text.length <= 0) {
        [self showTips:kLocat(@"modifyPassword_new")];
        return;
    }
    
    if (self.conPwd.text.length <= 0) {
        [self showErrorWithMessage:kLocat(@"modifyPassword_connew")];
        return;
    }
    if (![self.cuPwd.text isEqualToString:self.conPwd.text]) {
        [self showErrorWithMessage:kLocat(@"modifyPassword_same")];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    NSString *lang = nil;
    if ([currentLanguage containsString:@"en"]) {//英文
        lang = @"en-us";
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
        lang = @"zh-tw";
    }else if ([currentLanguage containsString:@"ko"]){//繁体
        lang = KoreanLanage;
    }else if ([currentLanguage containsString:Japanese]){//繁体
        lang = Japanese;
    }else{//泰文
        lang = ThAI;
    }
    param[@"language"] = lang;
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = kUserInfo.user_id;
    param[@"oldpwd"] = self.oldPwd.text;
    param[@"pwd"] = self.cuPwd.text;
    param[@"repwd"] = self.conPwd.text;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Account/retradepass"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        NSString *msg = [responseObj ksObjectForKey:kMessage];
        if (success) {
            [self showSuccessWithMessage:msg];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kNavPop;
            });
        }else{
            [self showInfoWithMessage:msg];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_ModifysetViewController_title");
    self.view.backgroundColor = kRGBA(24, 30, 50, 1);

    self.comBtn.layer.cornerRadius = 8;
    self.comBtn.layer.masksToBounds = YES;
    self.oldPwd.placeholder = kLocat(@"k_ModifysetViewController_t1");
    self.cuPwd.placeholder = kLocat(@"k_ModifysetViewController_t2");
    self.conPwd.placeholder = kLocat(@"k_ModifysetViewController_t3");
    [self.oldPwd setValue:kColorFromStr(@"#7582A4") forKeyPath:@"_placeholderLabel.textColor"];
    [self.cuPwd setValue:kColorFromStr(@"#7582A4") forKeyPath:@"_placeholderLabel.textColor"];
    [self.conPwd setValue:kColorFromStr(@"#7582A4") forKeyPath:@"_placeholderLabel.textColor"];
    [self.forgotPasswrdButton setTitle:kLocat(@"Forgot the original transaction password") forState:UIControlStateNormal];
    [self.comBtn setTitle:kLocat(@"k_ModifysetViewController_b1") forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
    
    [self.containerViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kThemeColor;
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.oldPwd becomeFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Action

- (IBAction)forgetAction:(id)sender {
    UIViewController *vc = [UIStoryboard storyboardWithName:@"Security" bundle:nil].instantiateInitialViewController;
    kNavPush(vc);
}


@end
