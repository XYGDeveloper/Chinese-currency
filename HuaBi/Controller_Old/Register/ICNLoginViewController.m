//
//  ICNLoginViewController.m
//  icn
//
//  Created by 周勇 on 2018/1/31.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "ICNLoginViewController.h"

@interface ICNLoginViewController ()

@property(nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong)UITextField *pwdTF;

@end

@implementation ICNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)setupUI
{
    self.view.backgroundColor = kWhiteColor;
    UIImageView *topView = [[UIImageView alloc] initWithFrame:kScreenBounds];
    topView.image = kImageFromStr(@"bg");
    [self.view addSubview:topView];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:kRectMake(0, 44 *kScreenHeightRatio,95 * kScreenHeightRatio , 113 * kScreenHeightRatio)];
    logo.image = kImageFromStr(@"logo");
    [topView addSubview:logo];
    [logo alignHorizontal];
    
//    UIImageView *logo1 = [[UIImageView alloc] initWithFrame:kRectMake(0, logo.bottom + 15 *kScreenHeightRatio,94 * kScreenHeightRatio , 22 * kScreenHeightRatio)];
//    logo1.image = kImageFromStr(@"guojiyunwang");
//    [topView addSubview:logo1];
//    [logo1 alignHorizontal];
    
    self.view.backgroundColor = kWhiteColor;
//    self.titleWithNoNavgationBar = kLocat(@"LUserLogin");
    self.titleWithNoNavgationBar = @"";

    [self.backBtn setImage:kImageFromStr(@"close_login") forState:UIControlStateNormal];
    self.backBtn.frame = kRectMake(20, 35, 18, 18);
    
    UIView *bgView = [[UIView alloc] initWithFrame:kRectMake(19, 324 / 2 * kScreenHeightRatio, kScreenWidth - 38, 342   * kScreenHeightRatio)];
    
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithRed:0.09 green:0.10 blue:0.14 alpha:1.00];
    bgView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    bgView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    bgView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    bgView.layer.shadowRadius = 3;//阴影半径，默认3
    //    kViewBorderRadius(bgView, 15, 0, kRedColor);
    bgView.layer.cornerRadius = 15;
    
    
    UITextField *loginTF = [[UITextField alloc] initWithFrame:kRectMake(42, 57*kScreenHeightRatio, bgView.width - 84, 34 *kScreenHeightRatio)];
    [bgView addSubview:loginTF];
    loginTF.backgroundColor = kColorFromStr(@"e5e5e5");
    kViewBorderRadius(loginTF, 0, 0.5, kColorFromStr(@"f4f1f4"));
    loginTF.font = PFRegularFont(14);
    loginTF.textColor = k323232Color;
    loginTF.keyboardType = UIKeyboardTypeASCIICapable;
    loginTF.leftViewMode = UITextFieldViewModeAlways ;
    loginTF.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //关闭联想和大写
    [loginTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    [loginTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    loginTF.text = [kUserDefaults objectForKey:@"kUserLoginAccountKey"];
    loginTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:kRectMake(loginTF.x, loginTF.top - 14 - 10, loginTF.width, 18) text:kLocat(@"R_EMailOrPhone") font:PFRegularFont(14) textColor:kColorFromStr(@"4b4b4b") textAlignment:0 adjustsFont:YES];
    [bgView addSubview:topLabel];
    
    
    UITextField *pwdTF = [[UITextField alloc] initWithFrame:kRectMake(42, 133*kScreenHeightRatio, bgView.width - 84, 34 *kScreenHeightRatio)];
    [bgView addSubview:pwdTF];
    pwdTF.backgroundColor = kColorFromStr(@"e5e5e5");
    kViewBorderRadius(pwdTF, 0, 0.5, kColorFromStr(@"f4f1f4"));
    pwdTF.font = PFRegularFont(14);
    pwdTF.textColor = k323232Color;
    pwdTF.keyboardType = UIKeyboardTypeASCIICapable;
    pwdTF.leftViewMode = UITextFieldViewModeAlways ;
    pwdTF.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    pwdTF.secureTextEntry = YES;
    pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;

    UILabel *topLabel1 = [[UILabel alloc] initWithFrame:kRectMake(pwdTF.x, pwdTF.top - 14 - 10, pwdTF.width, 18) text:kLocat(@"LPassword") font:PFRegularFont(14) textColor:kColorFromStr(@"4b4b4b") textAlignment:0 adjustsFont:YES];
    [bgView addSubview:topLabel1];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:kRectMake(0, pwdTF.bottom + 28 * kScreenHeightRatio, 472 / 2 * kScreenWidthRatio, 104 / 2 *kScreenHeightRatio) title:kLocat(@"LLogin") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:1];
    [bgView addSubview:loginButton];
    [loginButton alignHorizontal];
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundImage:kImageFromStr(@"btn_bg") forState:UIControlStateNormal];
    
    UIButton *forgetButton = [[UIButton alloc] initWithFrame:kRectMake(loginButton.x, pwdTF.bottom + 9 * kScreenHeightRatio, 120, 14) title:kLocat(@"LForgetPWD") titleColor:kColorFromStr(@"4b4b4b") font:PFRegularFont(12) titleAlignment:0];
    forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    forgetButton.right = pwdTF.right;
    [bgView addSubview:forgetButton];
    [forgetButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@/Mobile/Account/forgot_password",kBasePath]];
//        vc.titleString = @"找回密码";
//        vc.showNaviBar = NO;
        
//        vc.urlStr = ;
        kNavPush(vc);
    }];
    
    
    
//    UILabel *registerLabel = [[UILabel alloc] initWithFrame:kRectMake(loginButton.x, forgetButton.y, 200, 14)];
//    registerLabel.userInteractionEnabled = YES;
//    [bgView addSubview:registerLabel];
//    registerLabel.right = loginButton.right;
//    NSString *registerStr = kLocat(@"R_NOCount?");
//    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:registerStr];
//
//    if (![[LocalizableLanguageManager userLanguage] containsString:@"?"]) {
//        [attributedStr addAttribute:NSForegroundColorAttributeName
//                              value:kRedColor
//                              range:NSMakeRange(0, registerStr.length)];
//    }else{
//
//        [attributedStr addAttribute:NSForegroundColorAttributeName
//                              value:kColorFromStr(@"666666")
//                              range:NSMakeRange(0, registerStr.length)];
//        NSRange range = [registerStr rangeOfString:@"?"];
//        [attributedStr addAttribute:NSForegroundColorAttributeName
//                              value:kRedColor
//                              range:NSMakeRange(range.location + 1, registerStr.length - range.location - 1)];
//    }
//    [attributedStr addAttribute:NSFontAttributeName
//                          value:PFRegularFont(12)
//                          range:NSMakeRange(0, registerStr.length)];
//
//
//    registerLabel.attributedText = attributedStr;
//    registerLabel.textAlignment = 2;
//    [registerLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registerAction)]];
    
    
    _nameTF = loginTF;
    _pwdTF = pwdTF;
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(0, pwdTF.bottom+40 * kScreenHeightRatio,bgView.width - 110 *kScreenWidthRatio, 40 *kScreenHeightRatio)];
    [bgView addSubview:button];
    [button alignHorizontal];
    [button setTitle:kLocat(@"LLogin") forState:UIControlStateNormal];
    [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
    //    [button setBackgroundImage:kImageFromStr(@"btn_bg") forState:UIControlStateNormal];
    button.backgroundColor = kColorFromStr(@"dbb668");
    button.titleLabel.font = PFRegularFont(16);
    [button addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    kViewBorderRadius(button, button.height/2.0, 0, kColorFromStr(@"434343"));
    
    
    UIButton *registerButton = [[UIButton alloc] initWithFrame:kRectMake(button.x, button.bottom + 15 *kScreenHeightRatio, button.width, button.height)];
    [bgView addSubview:registerButton];
    kViewBorderRadius(registerButton, button.height/2.0, 0.5, kColorFromStr(@"434343"));
    
    NSString *registerStr = kLocat(@"R_NOCount?");
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:registerStr];
  
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:kColorFromStr(@"7c7c7c")
                          range:NSMakeRange(0, registerStr.length)];
    NSRange range = [registerStr rangeOfString:@"?"];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:kColorFromStr(@"dbb668")
                          range:NSMakeRange(range.location + 1, registerStr.length - range.location - 1)];
    [attributedStr addAttribute:NSFontAttributeName
                          value:PFRegularFont(16)
                          range:NSMakeRange(0, registerStr.length)];
    
    [registerButton setAttributedTitle:attributedStr forState:UIControlStateNormal];
    registerButton.titleLabel.font = PFRegularFont(16);
    [registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
}



-(void)loginAction
{
    [self hideKeyBoard];
    
    if (_nameTF.text.length == 0) {
        
        return;
    }
    if (_pwdTF.text.length == 0) {
        
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if ([_nameTF.text containsString:@" "]) {
        _nameTF.text = [_nameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    param[@"username"] = _nameTF.text;
    param[@"password"] = _pwdTF.text;
    param[@"platform"] = @"ios";
    
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
    param[@"uuid"] = [Utilities randomUUID];
    [BQActivityView showActiviTy];
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kUserLogin] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [BQActivityView hideActiviTy];
        if (success) {
            kLOG(@"%@",responseObj);
            [self showTips:kLocat(@"LLoginSuccess")];
            [kUserDefaults setObject:_nameTF.text forKey:@"kUserLoginAccountKey"];
            //            NSArray *dic = [responseObj ksObjectForKey:kResult];
            
            //保存数据
            YJUserInfo *model = [YJUserInfo modelWithJSON:[responseObj ksObjectForKey:kResult]];
            [kUserDefaults setInteger:model.uid forKey:kUserIDKey];
            [model saveUserInfo];
            //发通知
            //保存当前登录时间
            [kUserDefaults setObject:[NSDate date] forKey:@"kLastLoginTimeKey"];
            
            kLOG(@"===%@",[kUserDefaults objectForKey:@"kLastLoginTimeKey"]);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessKey object:nil];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self backAction];
            });
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
            return ;
            NSInteger code = [[responseObj ksObjectForKey:kCode] integerValue];
            NSString *tips = @"";
            switch (code) {
                case 10100:
                    tips = kLocat(@"LUserNameError");
                    break;
                case 10102:
                    tips = kLocat(@"LUserNameError");
                case 10103:
                    tips = kLocat(@"LUserNameError");
                    break;
                case 10104:
                    tips = kLocat(@"LAccoutLocked");
                    break;
                default:
                    tips = kLocat(@"LLoginFail");
                    break;
            }
            [self showTips:tips];
        }
    }];
    
}

-(void)registerAction
{
    if (self.navigationController.viewControllers.count == 1) {
        
        [self.navigationController pushViewController:[ICNRegisterViewController new] animated:YES];
    }else{
        kNavPop;
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
