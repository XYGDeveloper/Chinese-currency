//
//  HBMyAssetExchangeController.m
//  HuaBi
//
//  Created by Roy on 2018/11/8.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMyAssetExchangeController.h"
#import "HBMyAssetExchangeRecordController.h"
#import "NSObject+SVProgressHUD.h"
#import "HBPasswordOrVerifyInputView.h"

@interface HBMyAssetExchangeController ()<UITextFieldDelegate,NTESVerifyCodeManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *aviLabel;

@property (weak, nonatomic) IBOutlet UILabel *volume;

@property (weak, nonatomic) IBOutlet UILabel *receiveIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UITextField *volumeTF;

@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *recevieTF;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *nameActivityIndicatorView;

@property(nonatomic,strong)NTESVerifyCodeManager *manager;

@property(nonatomic,copy)NSString *verifyStr;

@property (nonatomic, assign) BOOL isTypingOfUID;
@property (nonatomic, strong) NSTimer *timerOfTyping;

@property (nonatomic, strong) HBPasswordOrVerifyInputView *verifyCodeInputView;

@end

@implementation HBMyAssetExchangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVerifyConfigure];

    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    
}
-(void)setupUI
{
    self.title = kLocat(@"Assert_detail_exchange");
    self.view.backgroundColor = kThemeBGColor;
    _aviLabel.textColor = kColorFromStr(@"#DEE5FF");
    _aviLabel.font = PFRegularFont(14);
    _volume.textColor = kColorFromStr(@"#DEE5FF");
    _volume.font = PFRegularFont(14);
    _receiveIDLabel.textColor = kColorFromStr(@"#DEE5FF");
    _receiveIDLabel.font = PFRegularFont(14);
    _nameLabel.textColor = kColorFromStr(@"#DEE5FF");
    _nameLabel.font = PFRegularFont(14);
    _pwdLabel.textColor = kColorFromStr(@"#DEE5FF");
    _pwdLabel.font = PFRegularFont(14);
    
    _volumeTF.textColor = kColorFromStr(@"#DEE5FF");
    _volumeTF.font = PFRegularFont(14);
    
    _recevieTF.textColor = kColorFromStr(@"#DEE5FF");
    _recevieTF.font = PFRegularFont(14);
    
    _nameTF.textColor = kColorFromStr(@"#DEE5FF");
    _nameTF.font = PFRegularFont(14);
    
    _pwdTF.textColor = kColorFromStr(@"#DEE5FF");
    _pwdTF.font = PFRegularFont(14);
    
    _volumeTF.leftView = [[UIView alloc] initWithFrame:kRectMake(0, 0, 10, 40)];
    _volumeTF.leftViewMode = UITextFieldViewModeAlways;
    
    _recevieTF.leftView = [[UIView alloc] initWithFrame:kRectMake(0, 0, 10, 40)];
    _recevieTF.leftViewMode = UITextFieldViewModeAlways;
    
    _nameTF.leftView = [[UIView alloc] initWithFrame:kRectMake(0, 0, 10, 40)];
    _nameTF.leftViewMode = UITextFieldViewModeAlways;
    
    _pwdTF.leftView = [[UIView alloc] initWithFrame:kRectMake(0, 0, 10, 40)];
    _pwdTF.leftViewMode = UITextFieldViewModeAlways;
    
    _nameTF.userInteractionEnabled = NO;
    
    _volumeTF.placeholder = kLocat(@"Assert_detail_100");
    _volumeTF.keyboardType = UIKeyboardTypeNumberPad;
    _recevieTF.keyboardType = UIKeyboardTypeNumberPad;
    _pwdTF.keyboardType = UIKeyboardTypeNumberPad;
    _pwdTF.secureTextEntry = YES;
    _volumeTF.backgroundColor = kThemeBGColor;
    _recevieTF.backgroundColor = kThemeBGColor;
    _pwdTF.backgroundColor = kThemeBGColor;
    _recevieTF.placeholder = kLocat(@"Assert_detail_enteruserID");
    _pwdTF.placeholder = kLocat(@"LEnterTransactionPWD");
    
    
    
    [_actionButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#CCCCCC")] forState:UIControlStateDisabled];
    [_actionButton setTitleColor:kColorFromStr(@"#FFFFFF") forState:UIControlStateDisabled];
    
    [_actionButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#4173C8")] forState:UIControlStateNormal];
    [_actionButton setTitleColor:kColorFromStr(@"#FFFFFF") forState:UIControlStateNormal];
    
    [_actionButton setTitle:kLocat(@"Assert_detail_exchange") forState:UIControlStateNormal];
//    _actionButton.enabled = NO;
    [_actionButton addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    [rightbBarButton setTitle:kLocat(@"Assert_detail_exchangedetail") forState:(UIControlStateNormal)];
    [rightbBarButton setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    rightbBarButton.titleLabel.font = PFRegularFont(16);
    [rightbBarButton addTarget:self action:@selector(recordListAction) forControlEvents:(UIControlEventTouchUpInside)];
    rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth/375.0)];
    rightbBarButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
    
   

    
    _aviLabel.text = [NSString stringWithFormat:@"%@:%@KOK",kLocat(@"k_MyassetViewController_tableview_list_cell_middle_label"),_dataDic[@"exchange_num"]];
    _volume.text = kLocat(@"k_HBTradeJLViewController_count");
    _receiveIDLabel.text = kLocat(@"Assert_detail_changeintoid");
    _nameLabel.text = kLocat(@"Assert_detail_name");
    _pwdLabel.text = kLocat(@"k_MyassetDetailViewController_alert_lin5");
    _pwdTF.placeholder = kLocat(@"k_MyassetDetailViewController_alert_lin5_p");
    _pwdLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    
    kTextFieldPlaceHoldColor(_volumeTF, kColorFromStr(@"#6A7586"));
    kTextFieldPlaceHoldColor(_recevieTF, kColorFromStr(@"#6A7586"));
    kTextFieldPlaceHoldColor(_pwdTF, kColorFromStr(@"#6A7586"));
    _recevieTF.delegate = self;
    _volumeTF.delegate = self;
    _pwdTF.delegate = self;
}
-(void)recordListAction
{
    HBMyAssetExchangeRecordController *VC= [HBMyAssetExchangeRecordController new];
    kNavPush(VC);
}
-(void)showAlertView
{
    
    if (self.volumeTF.text.length == 0) {
        [self showInfoWithMessage:kLocat(@"Assert_detail_100")];
        [self.volumeTF becomeFirstResponder];
        return;
    }
    
    if (self.recevieTF.text.length == 0) {
        [self showInfoWithMessage:kLocat(@"Assert_detail_enteruserID")];
        [self.recevieTF becomeFirstResponder];
        return;
    }

    
    if (self.pwdTF.text.length == 0) {
        [self showInfoWithMessage:kLocat(@"LEnterTransactionPWD")];
        [self.pwdTF becomeFirstResponder];
        return;
    }
    
    if (self.nameTF.text.length == 0) {
        [self showInfoWithMessage:kLocat(@"Assert_detail_noidentify")];
        [self.nameTF becomeFirstResponder];
        return;
    }
    
    [self hideKeyBoard];
    
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.6];
    [kKeyWindow addSubview:bgView];
    
    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(33, 175 *kScreenHeightRatio, kScreenW - 66, 150)];
    [bgView addSubview:midView];
    midView.backgroundColor = kWhiteColor;
    [midView alignVertical];
    kViewBorderRadius(midView, 8, 0, kRedColor);
    
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(10, 10, midView.width - 20, 95) text:[NSString stringWithFormat:@"%@%@KOK%@ID:%@",kLocat(@"Assert_detail_sureexchange"),_volumeTF.text,kLocat(@"Assert_detail_to"),_recevieTF.text] font:PFRegularFont(14) textColor:k323232Color textAlignment:1 adjustsFont:YES];
    [midView addSubview:tipsLabel];
    tipsLabel.numberOfLines = 0;
        
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(0, 105, midView.width/2, 45) title:kLocat(@"net_alert_load_message_cancel") titleColor:kColorFromStr(@"#FFFFFF") font:PFRegularFont(16) titleAlignment:1];
    [midView addSubview:cancelButton];
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:kRectMake(midView.width/2, 105, midView.width/2, 45) title:kLocat(@"net_alert_load_message_sure") titleColor:kColorFromStr(@"#FFFFFF") font:PFRegularFont(16) titleAlignment:1];
    [midView addSubview:confirmButton];
    cancelButton.backgroundColor = kColorFromStr(@"#CCCCCC");
    confirmButton.backgroundColor = kColorFromStr(@"#4173C8");
    [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton* sender) {
        [sender.superview.superview removeFromSuperview];
    }];
    __weak typeof(self)weakSelf = self;

    [confirmButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton* sender) {
        [sender.superview.superview removeFromSuperview];
        [weakSelf validateTakenCoin];
        
    }];
}

#pragma mark - textfield代理 f通知
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _recevieTF) {
        
        if ([BARegularExpression ba_isAllNumber:textField.text]) {
            [self getuserInfoWith:_recevieTF.text isEnd:YES];
        }else{
            [self showInfoWithMessage:@"用户ID全为数字"];
        }
    }else if (textField == _volumeTF){
        if (_volumeTF.text.length > 2 && _volumeTF.text.integerValue % 100 != 0) {
            [self showInfoWithMessage:kLocat(@"Assert_detail_100")];
        }
    }
}
-(void)textfieldDidChange:(NSNotification *)noti
{
    
    if ((_volumeTF.text.length > 2 && _volumeTF.text.integerValue % 100 == 0)&&(_recevieTF.text.length > 0)&&(_pwdTF.text.length == 6)  ) {
        
        if (_nameTF.text.length > 0 && [_dataDic[@"exchange_num"]doubleValue] >= _volumeTF.text.doubleValue ) {
//            _actionButton.enabled = YES;
        }else{
//            _actionButton.enabled = NO;
        }
    }else{
//        _actionButton.enabled = NO;
    }
    
    if (noti.object == _recevieTF) {
        if (_recevieTF.text.length > 0) {
//            [self getuserInfoWith:_recevieTF.text isEnd:NO];
//            self.isTypingOfUID = YES;
            [self fireTimerOfGetuUserInfo];
        }
    }
}




#pragma mark - 根据id查询用户
- (void)fireTimerOfGetuUserInfo {
    [self.timerOfTyping invalidate];
    self.timerOfTyping = nil;
    self.timerOfTyping = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getUserInfo) userInfo:nil repeats:NO];
}

-(void)getuserInfoWith:(NSString *)uid isEnd:(BOOL )isEnd
{
    self.nameTF.text = nil;
    if (uid.length < 1) {
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"member_id"] = uid;
    [self.nameActivityIndicatorView startAnimating];
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/AccountManage/findByMemberId"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [self.nameActivityIndicatorView stopAnimating];
        if (success) {
            _nameTF.text = [responseObj ksObjectForKey:kData][@"name"];
            
            if (_nameTF.text.length < 2) {
                _nameTF.text = nil;
                [self showTips:kLocat(@"Assert_detail_noidentify")];

            }
            
            [self textfieldDidChange:nil];
        }else{
            _nameTF.text = nil;
//            _actionButton.enabled = NO;
            if (isEnd) {
                [self showTips:[responseObj ksObjectForKey:kMessage]];
            }
        }
    }];

}


#pragma mark - 安全认证 三重步骤


/**
 1. 验证数据
 */
- (void)validateTakenCoin {
    NSString *money = _volumeTF.text ?: @"";
    NSString *to_member_id = _recevieTF.text ?: @"";
    NSDictionary *parameters = @{
                                 @"money" : money,
                                 @"to_member_id" : to_member_id,
                                 };
    
    kShowHud;
    [kNetwork_Tool objPOST:@"/Api/AccountManage/validateTakeCoin" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        kHideHud;
        if (model.succeeded) {
            [self showVerifyInfo];
        } else {
            [self showTips:model.message];
        }
    } failure:^(NSError *error) {
        kHideHud;
        [self showTips:error.localizedDescription];
    }];
}

/**
 2.验证滑动校验码
 
 @param validate 滑动校验码
 */
- (void)validateYiDunCode:(NSString *)validate {
    kShowHud;
    [kNetwork_Tool objPOST:@"/Api/AccountManage/validateYiDun" parameters:@{@"validate" : validate ?: @""} success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            [self validatePassword];
        } else {
            [self showTips:model.message];
        }
        kHideHud;
    } failure:^(NSError *error) {
        kHideHud;
        [self showTips:error.localizedDescription];
    }];
}

/**
 3. 校验交易密码
 */
- (void)validatePassword {
    kShowHud;
    [kNetwork_Tool objPOST:@"/Api/AccountManage/validatePayPwd" parameters:@{@"pay_pwd" : self.pwdTF.text ?: @""} success:^(YWNetworkResultModel *model, id responseObject) {
        kHideHud;
        if ([model succeeded]) {
            [self showVerifyCodeView];
        } else {
            [self showTips:model.message];
        }
        
    } failure:^(NSError *error) {
        kHideHud;
        [self showTips:error.localizedDescription];
    }];
}

/**
 4.1 获取手机或邮箱验证码
 */
- (void)showVerifyCodeView {
    self.verifyCodeInputView = [HBPasswordOrVerifyInputView getVerifyCodeView];
    [self.verifyCodeInputView showInWindow];
    __weak typeof(self) weakSelf = self;
    self.verifyCodeInputView.sendBlock = ^(UIButton * _Nonnull sendButton) {
        [weakSelf getVerifyCode];
    };
    self.verifyCodeInputView.callBackBlock = ^(UIButton * _Nonnull sureButton, NSString * _Nonnull text) {
        if (text.length <= 0) {
            return ;
        }
        [weakSelf exchangeActionWithVerityCode:text];
    };
}


/**
 3.2 获取 校验码
 */
- (void)getVerifyCode {
    kShowHud;
    [kNetwork_Tool objPOST:@"/Api/AccountManage/hzSandPhone" parameters:nil success:^(YWNetworkResultModel *model, id responseObject) {
        kHideHud;
        if (model.succeeded) {
            [self.verifyCodeInputView startCountDownTime];
        } else {
            [self showTips:model.message];
        }
    } failure:^(NSError *error) {
        kHideHud;
        [self showTips:error.localizedDescription];
    }];
}


#pragma mark - 互转
-(void)exchangeActionWithVerityCode:(NSString *)verityCode
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"money"] = _volumeTF.text;
    param[@"to_member_id"] = _recevieTF.text;
    param[@"paypwd"] = [_pwdTF.text md5String];
    param[@"code_deal"] = verityCode ?: @"";
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/AccountManage/mutualTransfer"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            self.pwdTF.text = nil;
            [self.verifyCodeInputView hide];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kHBMyAssetExchangeControllerUserDidExchangeSuccessKey" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                HBMyAssetExchangeRecordController *vc= [HBMyAssetExchangeRecordController new];
                vc.fromSuccess = YES;
                kNavPush(vc);
            });
            [self showTips:[responseObj ksObjectForKey:kMessage]];
            
        } else {
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
        
        
    }];

}


-(void)showVerifyInfo
{
    [self.manager openVerifyCodeView:nil];
}

- (void)verifyCodeValidateFinish:(BOOL)result
                        validate:(NSString *)validate
                         message:(NSString *)message
{
    // App添加自己的处理逻辑
    if (result == YES) {
        _verifyStr = validate;
        [self validateYiDunCode:validate];
    }else{
        _verifyStr = @"";
        [self showTips:kLocat(@"OTC_buylist_codeerror")];
    }
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    if (textField == _pwdTF) {
        if (range.length + range.location > textField.text.length) {
            return NO;
        }
        NSUInteger length = textField.text.length + string.length - range.length;
        
        return length <= 6;
    }else{
        return YES;
    }
}
#pragma mark - 图形验证码
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

- (void)getUserInfo {
    [self getuserInfoWith:self.recevieTF.text isEnd:NO];
}


@end
