//
//  HBRegisterTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBRegisterTableViewController.h"
#import "UITextField+ChangeClearButton.h"
#import "ICNNationalityModel+Request.h"
#import "HBLoginRequest.h"
#import "UIButton+LSSmsVerification.h"
#import "HBSelectCodeOfCountryView.h"
#import "HMSegmentedControl.h"
#import "NSObject+SVProgressHUD.h"

@interface HBRegisterTableViewController () <HBSelectCodeOfCountryViewDelegate,NTESVerifyCodeManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *countryOfCodeButton;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (nonatomic, strong) NSArray<ICNNationalityModel *> *codesOfCountry;

@property (weak, nonatomic) IBOutlet UILabel *codeOfCountryLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendSMSButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *password2TextField;
@property (weak, nonatomic) IBOutlet UITextField *tradePasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *tradePassword2TextField;
@property (weak, nonatomic) IBOutlet UITextField *inviteTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkboxButton;

@property (nonatomic, strong) UITableView *nationalityTableview;
@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property(nonatomic,copy)NSString *verifyStr;

@property (weak, nonatomic) IBOutlet UILabel *registerDes;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@property (weak, nonatomic) IBOutlet UILabel *readDes;
@property (weak, nonatomic) IBOutlet UIButton *valcodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *codeDes;
@property (weak, nonatomic) IBOutlet UITextField *defaultCounBtn;
@property (weak, nonatomic) IBOutlet UILabel *encouragingLabel;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
@property (nonatomic, assign) NSInteger selectedSegmentedIndex;
@property (nonatomic, assign) BOOL isEmail;

@end

@implementation HBRegisterTableViewController

-(void)initVerifyConfigure
{
    // sdk调用
    self.manager = [NTESVerifyCodeManager sharedInstance];
    self.manager.delegate = self;
    
    // 设置透明度
    self.manager.alpha = 0;
    
    // 设置frame
    self.manager.frame = CGRectNull;
    
    // captchaId从云安全申请，比如@"a05f036b70ab447b87cc788af9a60974"
    NSString *captchaId = kVerifyKey;
    [self.manager configureVerifyCode:captchaId timeout:7];
}

-(void)showVerifyInfo
{
    if (self.phoneTextField.text.length == 0) {
        [self showTips:kLocat(@"LEnterPhoneNumber")];
        return;
    }
    
    [self.phoneTextField resignFirstResponder];
    
    [self.manager openVerifyCodeView:nil];
    
}

- (void)verifyCodeValidateFinish:(BOOL)result
                        validate:(NSString *)validate
                         message:(NSString *)message
{
    NSLog(@"%d  %@  %@ %@",result,validate,message,self.codeOfCountryLabel.text);
    // App添加自己的处理逻辑
    if (result == YES) {
        _verifyStr = validate;
        kShowHud;
        BOOL isEmail = self.selectedSegmentedIndex == 1;
        [HBLoginRequest getRegisterVerifyCodeWithUserName:self.phoneTextField.text
                                                  isEmail:isEmail
                                             codeOfContry:self.codeOfCountryLabel.text
                                                 validate:validate
                                                  success:^(YWNetworkResultModel * _Nonnull model)
        {
            kHideHud;
            if ([model succeeded]) {
                [self.sendSMSButton startTimeWithDuration:60];
            }
            [self showInfoWithMessage:model.message];
        } failure:^(NSError * _Nonnull error) {
            kHideHud;
            [self showErrorWithMessage:error.localizedDescription];
        }];
    }else{
        _verifyStr = @"";
        [self showErrorWithMessage:@"验证码错误"];
    }
}





- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVerifyConfigure];
    [self.textFields enumerateObjectsUsingBlock:^(UITextField  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj _changeClearButton];
    }];
    self.countryOfCodeButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    
    [ICNNationalityModel requestCountryListWithSuccess:^(NSArray<ICNNationalityModel *> * _Nonnull array, YWNetworkResultModel * _Nonnull model) {
        self.codesOfCountry = array;
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    [self _setupSegemntedControl];
    
    self.registerDes.text = kLocat(@"HBRegisterTableViewController_registerdes");
    self.readDes.text = kLocat(@"HBRegisterTableViewController_read");
    [self.agreeBtn setTitle:kLocat(@"HBRegisterTableViewController_agree") forState:UIControlStateNormal];
    [self.loginBtn setTitle:kLocat(@"HBLoginTableViewController_password_login") forState:UIControlStateNormal];
    [self.registerBtn setTitle:kLocat(@"HBLoginTableViewController_password_regis") forState:UIControlStateNormal];
    [self.sendSMSButton setTitle:kLocat(@"HBRegisterTableViewController_getvalcode") forState:UIControlStateNormal];
    self.phoneTextField.placeholder = kLocat(@"HBForgetPasswordTableViewController_forgetPhone_placehoder");
    self.codeTextField.placeholder = kLocat(@"HBRegisterTableViewController_valcode");
    self.passwordTextField.placeholder = kLocat(@"HBRegisterTableViewController_1loginpwd");
    self.password2TextField.placeholder = kLocat(@"HBRegisterTableViewController_2loginpwd");
    self.tradePasswordTextField.placeholder = kLocat(@"HBRegisterTableViewController_1tradepwd");
    self.tradePassword2TextField.placeholder = kLocat(@"HBRegisterTableViewController_2tradepwd");
    self.inviteTextField.placeholder = kLocat(@"HBRegisterTableViewController_invitecode");
    [self.countryOfCodeButton setTitle:kLocat(@"HBRegisterTableViewController_defaultCountry") forState:UIControlStateNormal];
    self.codeDes.text = kLocat(@"HBRegisterTableViewController_defaultdes");
    [self.cancelBtn setTitle:kLocat(@"net_alert_load_message_cancel") forState:UIControlStateNormal];
    self.encouragingLabel.text = kLocat(@"HBRegisterTableViewController_encouraging");
}

#pragma mark - Private

- (void)_setupSegemntedControl {
    self.selectedSegmentedIndex = 0;
    self.segmentedControl.sectionTitles = @[kLocat(@"Phone"), kLocat(@"eMail")];
    self.segmentedControl.backgroundColor = kThemeColor;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionIndicatorHeight = 2;
    self.segmentedControl.selectionIndicatorColor = kColorFromStr(@"#FFD400");
    NSDictionary *attributesNormal = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Regular" size:18],NSFontAttributeName, [UIColor colorWithHexString:@"7582A4"], NSForegroundColorAttributeName,nil];
    NSDictionary *attributesSelected = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Semibold" size:18],NSFontAttributeName, kColorFromStr(@"#FFD400"), NSForegroundColorAttributeName,nil];
    self.segmentedControl.titleTextAttributes = attributesNormal;
    self.segmentedControl.selectedTitleTextAttributes = attributesSelected;
    
    __weak typeof(self) weakSelf = self;
    self.segmentedControl.indexChangeBlock = ^(NSInteger index) {
        weakSelf.selectedSegmentedIndex = index;
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        if (self.selectedSegmentedIndex == 1) {
            return 0.;
        } else {
            return 44.;
        }
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
}

#pragma mark - HBSelectCodeOfCountryViewDelegate

- (void)selectCodeOfCountryView:(HBSelectCodeOfCountryView *)view didSelectModel:(ICNNationalityModel *)model {
    [self.countryOfCodeButton setTitle:[NSString stringWithFormat:@"%@ ", model.name] forState:UIControlStateNormal];
    self.codeOfCountryLabel.text = model.countrycode;
}

#pragma mark - Actions

- (IBAction)selectCodeOfCountryAction:(id)sender {
    HBSelectCodeOfCountryView *view = [HBSelectCodeOfCountryView viewLoadNib];
    view.codesOfCountry = self.codesOfCountry;
    view.delegate = self;
    [view showInWindow];
}

- (IBAction)sendSMSAction:(UIButton *)sender {
    
    
    if (self.phoneTextField.text.length == 0) {
         NSString *key = self.isEmail ? @"LEnterEamil" : @"LEnterPhoneNumber";
        [self showErrorWithMessage:kLocat(key)];
        return;
    }
    
    
    [self  showVerifyInfo];
    
}

- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)agreeTheProtocolAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)registerAction:(UIButton *)sender {
    [self.view endEditing:YES];
    BOOL isEmail = self.selectedSegmentedIndex == 1;
    if (self.phoneTextField.text.length == 0) {
        NSString *key = self.isEmail ? @"LEnterEamil" : @"LEnterPhoneNumber";
        [self showTips:kLocat(key)];
        return;
    }
    if (self.codeTextField.text.length == 0) {
        [self showTips:kLocat(@"LEnterVerificationCode")];
        return;
    }
    
    if (self.passwordTextField.text.length == 0 || self.password2TextField.text.length == 0) {
        [self showTips:kLocat(@"LEnterPWD")];
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.password2TextField.text]) {
        [self showTips:kLocat(@"LLoginPWDNotSame")];
        return;
    }
    if (self.passwordTextField.text.length < 6) {
        [self showTips:kLocat(@"LPWDLengthLessThan6")];
        return;
    }
    
    if (self.tradePasswordTextField.text.length == 0||self.tradePassword2TextField.text.length == 0) {
        [self showTips:kLocat(@"LEnterTransactionPWD")];
        return;
    }
    if (self.tradePasswordTextField.text.length < 6 || self.tradePassword2TextField.text.length < 6) {
        [self showTips:kLocat(@"LPWDLengthLessThan6")];
        return;
    }
    if (![self.tradePasswordTextField.text isEqualToString:self.tradePasswordTextField.text]) {
        [self showTips:kLocat(@"LPayPWDNotSame")];
        return;
    }
    
//    if (self.inviteTextField.text.length == 0) {
//        [self showTips:kLocat(@"k_PleaseEnerInviiteCode")];
//        return;
//    }
    if ([self.passwordTextField.text isEqualToString:self.tradePasswordTextField.text]) {
        [self showTips:kLocat(@"k_PayLoginPWDSame")];
        return;
    }
    
    if (!self.checkboxButton.selected) {
        [self showTips:kLocat(@"OTC_post_pleaseacceptpro")];
        return;
    }

    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *userNameKey = isEmail ? @"email" : @"phone";
    NSString *codeKey = isEmail ? @"email_code" : @"phone_code";
    param[userNameKey] = _phoneTextField.text;
    param[codeKey] = _codeTextField.text;
    param[@"pwd"] = _passwordTextField.text;
    param[@"repwd"] = _password2TextField.text;
    param[@"pwdtrade"] = _tradePasswordTextField.text;
    param[@"repwdtrade"] = _tradePassword2TextField.text;
    param[@"countrycode"] = self.codeOfCountryLabel.text;//TODO
    param[@"platform"] = @"ios";
    param[@"pid"] = _inviteTextField.text;
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
    kShowHud;
    sender.enabled = NO;
    [HBLoginRequest registerWithParameters:param isEmail:isEmail success:^(YWNetworkResultModel * _Nonnull model) {
        kHideHud;
        sender.enabled = YES;
    
        if ([model succeeded]) {
            [self showSuccessWithMessage:model.message];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self loginAction:nil];
            });
        } else {
            [self showInfoWithMessage:model.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        sender.enabled = YES;
        [self showErrorWithMessage:error.localizedDescription];
    }];
    
}

- (IBAction)registerAgreement:(id)sender {
    
    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@?ts=%@",kBasePath,register_agreement,[Utilities dataChangeUTC]]];
    //                vc.showNaviBar = YES;
    kNavPush(vc);
    
}


#pragma mark - Setters && Getters

- (void)setCodesOfCountry:(NSArray<ICNNationalityModel *> *)codesOfCountry {
    _codesOfCountry = codesOfCountry;
}

- (void)setSelectedSegmentedIndex:(NSInteger)selectedSegmentedIndex {
    _selectedSegmentedIndex = selectedSegmentedIndex;
    self.codeOfCountryLabel.hidden = (selectedSegmentedIndex == 1);
    NSString *userNamePlaceholder = (selectedSegmentedIndex == 0) ?  kLocat(@"HBForgetPasswordTableViewController_forgetPhone_placehoder") : kLocat(@"HBForgetPasswordTableViewController_forgetEmail_placehoder");
    self.phoneTextField.placeholder = userNamePlaceholder;
    self.phoneTextField.keyboardType = (selectedSegmentedIndex == 0) ? UIKeyboardTypePhonePad : UIKeyboardTypeEmailAddress;
    [self.tableView reloadData];
}

- (BOOL)isEmail {
    return self.selectedSegmentedIndex == 1;
}

@end
