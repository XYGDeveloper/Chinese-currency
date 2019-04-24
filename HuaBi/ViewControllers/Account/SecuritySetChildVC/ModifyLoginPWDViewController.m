//
//  ModifyLoginPWDViewController.m
//  YJOTC
//
//  Created by l on 2018/10/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "ModifyLoginPWDViewController.h"
#import "HBLoginTableViewController.h"
#import "NSObject+SVProgressHUD.h"

@interface ModifyLoginPWDViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPWD;

@property (weak, nonatomic) IBOutlet UITextField *modiPwd;

@property (weak, nonatomic) IBOutlet UITextField *surePWD;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;

@end

@implementation ModifyLoginPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_ModifyLoginsetViewController_title");
    self.view.backgroundColor = kRGBA(24, 30, 50, 1);
    self.commitBtn.layer.cornerRadius = 8;
    self.commitBtn.layer.masksToBounds = YES;
    self.oldPWD.placeholder = kLocat(@"k_ModifyLoginsetViewController_t1");
    self.modiPwd.placeholder = kLocat(@"k_ModifyLoginViewController_t2");
    self.surePWD.placeholder = kLocat(@"k_ModifyLoginViewController_t3");
    [self.commitBtn setTitle:kLocat(@"k_ModifyLoginViewController_b1") forState:UIControlStateNormal];
    [self.oldPWD setValue:kColorFromStr(@"#7582A4") forKeyPath:@"_placeholderLabel.textColor"];
    [self.modiPwd setValue:kColorFromStr(@"#7582A4") forKeyPath:@"_placeholderLabel.textColor"];
    [self.surePWD setValue:kColorFromStr(@"#7582A4") forKeyPath:@"_placeholderLabel.textColor"];
    // Do any additional setup after loading the view from its nib.
    
    [self.containerViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kThemeColor;
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.oldPWD becomeFirstResponder];
}

- (IBAction)commitAction:(id)sender {
    
    //提交
    if (self.oldPWD.text.length <= 0) {
        [self showTips:kLocat(@"modifyLoginPassword_ori")];
        return;
    }
    if (self.modiPwd.text.length <= 0) {
        [self showTips:kLocat(@"modifyLoginPassword_new")];
        return;
    }
    if (self.surePWD.text.length <= 0) {
        [self showTips:kLocat(@"modifyLoginPassword_connew")];
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
    param[@"oldpwd"] = self.oldPWD.text;
    param[@"pwd"] = self.modiPwd.text;
    param[@"repwd"] = self.surePWD.text;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Account/repass"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        if (error) {
            [self showErrorWithMessage:error.localizedDescription];
            return ;
        }
        kHideHud;
        NSString *msg = [responseObj ksObjectForKey:kMessage];
        if (success) {
            [self showSuccessWithMessage:msg];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
//                [self gotoLoginVC];
            });
        }else{
            [self showInfoWithMessage:msg];
        }
    }];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
