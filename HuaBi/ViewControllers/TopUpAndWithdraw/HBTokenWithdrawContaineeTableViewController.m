//
//  HBTokenWithdrawContaineeTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/2/18.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBTokenWithdrawContaineeTableViewController.h"
#import "HBSelectTokenTableViewController.h"
#import "HBTokenListModel.h"
#import "KSScanningViewController.h"
#import "HBPasswordOrVerifyInputView.h"
#import "UIButton+LSSmsVerification.h"
#import "HBGetCurrenInfoModel.h"
#import "HBTakeTokenRecordViewController.h"
#import "HBTakenTokenAddressViewController.h"
#import "HBCurrenyInfo.h"
#import "HBAddressModel.h"
@interface HBTokenWithdrawContaineeTableViewController ()<NTESVerifyCodeManagerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;
@property (weak, nonatomic) IBOutlet UILabel *currencyName;
@property (weak, nonatomic) IBOutlet UILabel *selectCurrencyName;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *normalAddressLabel;
@property (weak, nonatomic) IBOutlet UITextField *noteContent;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITextField *countContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UILabel *minMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UILabel *shouxuLabel;
@property (weak, nonatomic) IBOutlet UILabel *shouxuContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *actualLabel;
@property (weak, nonatomic) IBOutlet UILabel *actualContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressDefault;
@property (weak, nonatomic) IBOutlet UILabel *valiableCount;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (nonatomic,strong)HBPasswordOrVerifyInputView *passwordView;
@property (nonatomic,strong)HBPasswordOrVerifyInputView *varcodeView;
@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property(nonatomic,copy)NSString *verifyStr;
@property(nonatomic,strong)NSString *pwd;
@property(nonatomic,strong)NSString *smscode;
@property(nonatomic,strong)NSString *is_check;
@property(nonatomic,strong)HBGetCurrenInfoModel *model;
@property(nonatomic,strong)NSString *cid;
@property (nonatomic,assign)BOOL isHaveDian;
@end

@implementation HBTokenWithdrawContaineeTableViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVerifyConfigure];
    self.is_check = @"0";
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
    
    self.tableView.backgroundColor = kThemeBGColor;
    [self.containerViews enumerateObjectsUsingBlock:^(UIView  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kThemeColor;
    }];
    self.currencyName.text = self.currencyNameString;
    NSLog(@"------mmmmm----------%@",_currency_id);
    self.selectCurrencyName.text = kLocat(@"HBTokenWithdrawViewController_select");
    self.addressLabel.text = kLocat(@"HBTokenWithdrawViewController_address");
    self.addressContentLabel.placeholder = kLocat(@"HBTokenWithdrawViewController_address_placehoder");
    self.addressContentLabel.userInteractionEnabled = YES;
    self.noteContent.userInteractionEnabled = YES;
    self.noteContent.placeholder = kLocat(@"HBTokenWithdrawViewController_address_note");
    self.normalAddressLabel.text = kLocat(@"HBTokenWithdrawViewController_address_normal");
    self.countLabel.text = kLocat(@"HBTokenWithdrawViewController_counter");
    self.countContentLabel.placeholder = kLocat(@"HBTokenWithdrawViewController_placehoder_counter");
    self.countContentLabel.delegate = self;
    [self.countContentLabel setValue:kColorFromStr(@"#6A7687") forKeyPath:@"_placeholderLabel.textColor"];
    [self.addressContentLabel setValue:kColorFromStr(@"#6A7687") forKeyPath:@"_placeholderLabel.textColor"];
    [self.noteContent setValue:kColorFromStr(@"#6A7687") forKeyPath:@"_placeholderLabel.textColor"];
    [self.allBtn setTitle:kLocat(@"k_MyassetDetailViewController_tableview_all") forState:UIControlStateNormal];
    self.minMaxLabel.text = kLocat(@"HBTokenWithdrawViewController_placehoder_min");
    self.maxLabel.text = kLocat(@"HBTokenWithdrawViewController_placehoder_max");
    self.actualLabel.text = kLocat(@"HBTokenWithdrawViewController_placehoder_actual");
    self.noticeLabel.text = kLocat(@"HBTokenWithdrawViewController_placehoder_notice");
    self.normalAddressLabel.userInteractionEnabled  = YES;
    [self.countContentLabel addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toset)];
    [self.normalAddressLabel addGestureRecognizer:tap];
    [self.addressDefault setImage:[UIImage imageNamed:@"nomal_address"] forState:UIControlStateNormal];
    [self.addressDefault setImage:[UIImage imageNamed:@"select_address"] forState:UIControlStateSelected];
    self.leftLabel.text = self.currencyNameString;
}

- (void)textFieldTextDidChange:(UITextField *)textChange{
    self.shouxuContentLabel.text = [NSString stringWithFormat:@"%f%@",[self.model.tcoin_fee doubleValue]*[self.countContentLabel.text doubleValue]/100,self.model.currency_name];
    self.actualContentLabel.text = [NSString stringWithFormat:@"%f%@",[self.countContentLabel.text doubleValue] - [self.model.tcoin_fee doubleValue]*[self.countContentLabel.text doubleValue]/100,self.model.currency_name];
}

//- (void)keyboardAction:(NSNotification*)sender{
//    // 通过通知对象获取键盘frame: [value CGRectValue]
//    NSDictionary *useInfo = [sender userInfo];
//    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    // <注意>具有约束的控件通过改变约束值进行frame的改变处理
//    if([sender.name isEqualToString:UIKeyboardWillShowNotification]){
//         self.passwordView.frame = kRectMake(0,kScreenH - 300 - [value CGRectValue].size.height, kScreenW, 300);
//        self.varcodeView.frame = kRectMake(0,kScreenH - 300 - [value CGRectValue].size.height, kScreenW, 300);
//    }else{
//        self.passwordView.frame = kRectMake(0, kScreenH - 300, kScreenW, 300);
//        self.varcodeView.frame = kRectMake(0, kScreenH - 300, kScreenW, 300);
//    }
//}

- (IBAction)scanQR:(id)sender {
    __weak typeof(self)weakSelf = self;
    KSScanningViewController *vc = [[KSScanningViewController alloc] init];
    vc.callBackBlock = ^(NSString *scannedStr) {
        kLOG(@"%@",[NSString stringWithFormat:@"showName('%@')",scannedStr]);
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"currency_id"] = self.currency_id;
        param[@"address"] = scannedStr;
        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/findByAddress"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
                NSArray *temp = [HBCurrenyInfo mj_objectArrayWithKeyValuesArray:[responseObj ksObjectForKey:kResult]];
                for (HBCurrenyInfo *info in temp) {
                    if ([scannedStr isEqualToString:info.qianbao_url]) {
                        self.noteContent.text = info.name;
                        if ([info.is_default isEqualToString:@"1"]) {
                            self.addressDefault.selected = YES;
                            self.is_check = @"1";
                        }
                    }
                }
            }else{
               
            }
        }];
        weakSelf.addressContentLabel.text = scannedStr;
    };
    kNavPush(vc);
}

- (IBAction)addressAction:(id)sender {
    HBTakenTokenAddressViewController *zhangben = [HBTakenTokenAddressViewController new];
    zhangben.currency_id = self.currency_id;
    zhangben.currencyName = self.currencyNameString;
    zhangben.address = ^(HBAddressModel * _Nonnull model) {
        self.addressContentLabel.text = model.qianbao_url;
        self.noteContent.text = model.name;
        if ([model.is_default isEqualToString:@"1"]) {
            self.addressDefault.selected = YES;
            self.is_check = @"1";
        }
    };
    kNavPush(zhangben);
}
- (void)toset{
    if (self.addressContentLabel.text.length <= 0) {
        [kKeyWindow showWarning:kLocat(@"HBTokenWithdrawViewController_address_placehoder")];
        return;
    }
   self.addressDefault.selected = !self.addressDefault.selected;
    if (self.addressDefault.selected == YES) {
        self.is_check = @"1";
    }else{
        self.is_check = @"0";
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = self.currency_id;
    param[@"name"] = self.noteContent.text;
    param[@"address"] = self.addressContentLabel.text;
    param[@"is_default"] = self.is_check;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/add_qianbao_address"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
            self.addressDefault.selected = NO;
        }
    }];
}

- (IBAction)zhangbenAction:(id)sender {
    
}

- (IBAction)allAction:(id)sender {
    if ([self.model.num doubleValue] <= [self.model.currency_all_tibi doubleValue]) {
        self.countContentLabel.text = self.model.num;
    }else{
        self.countContentLabel.text = self.model.currency_all_tibi;
    }
    self.shouxuContentLabel.text = [NSString stringWithFormat:@"%f%@",[self.model.tcoin_fee doubleValue]*[self.countContentLabel.text doubleValue]/100,self.model.currency_name];
    self.actualContentLabel.text = [NSString stringWithFormat:@"%f%@",[self.countContentLabel.text doubleValue] - [self.model.tcoin_fee doubleValue]*[self.countContentLabel.text doubleValue]/100,self.model.currency_name];
}

- (void)preSubmit{
    
    if (self.countContentLabel.text.length <= 0) {
        [kKeyWindow showWarning:kLocat(@"HBTokenWithdrawViewController_placehoder_counter")];
        return;
    }
    if (self.addressContentLabel.text.length <= 0) {
        [kKeyWindow showWarning:kLocat(@"HBTokenWithdrawViewController_address_placehoder")];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = self.currency_id;
    param[@"money_deal"] = self.countContentLabel.text;
    param[@"site_deal"] = self.addressContentLabel.text;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/validateTakeCoin"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self showVerifyInfo];
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

- (void)submitAction {
    [self preSubmit];
}

- (void)showInputPasswordView{
    self.passwordView = [HBPasswordOrVerifyInputView getPasswordView];
    [self.passwordView showInWindow];
    __weak typeof(self) weakSelf = self;
    self.passwordView.callBackBlock = ^(UIButton *sureButton, NSString *text) {
        if (text.length <= 0) {
            [kKeyWindow showWarning:kLocat(@"HBRegisterTableViewController_1tradepwd")];
            return ;
        }
        [weakSelf requestValidatePayPwd:text];
    };
}

- (void)requestValidatePayPwd:(NSString *)text {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"pay_pwd"] = text;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/validatePayPwd"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            self.pwd = text;
            [self.passwordView hideWithCompletion:^{
                [self showGetVerifyCodeView];
            }];
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

-(void)showGetVerifyCodeView
{
    self.varcodeView = [HBPasswordOrVerifyInputView getVerifyCodeView];
    [self.varcodeView showInWindow];
    __weak typeof(self) weakSelf = self;
    self.varcodeView.callBackBlock = ^(UIButton *sureButton, NSString *text) {
        if (text.length <= 0) {
            [kKeyWindow showWarning:kLocat(@"LEnterVerificationCode")];
            return;
        }
        weakSelf.smscode = text;
        [weakSelf commitTakeTokenInfo:sureButton];
    };
    
    self.varcodeView.sendBlock = ^(UIButton * _Nonnull sendButton) {
        [weakSelf getVarcode:sendButton];
    };
}

- (void)commitTakeTokenInfo:(UIButton *)sendButton{
    kShowHud;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = self.currency_id;
    param[@"money_deal"] = self.countContentLabel.text;
    param[@"site_deal"] = self.addressContentLabel.text;
    param[@"pay_pwd"] = self.passwordView.passwordTextfield.text;
    param[@"code_deal"] = self.varcodeView.passwordTextfield.text;
    if (self.addressDefault.selected == YES) {
        if (self.noteContent.text.length <= 0) {
            [kKeyWindow showWarning:kLocat(@"HBTokenWithdrawViewController_address_placehoder")];
            return;
        }
    }
    param[@"label_deal"] = self.noteContent.text;
    param[@"is_check"] = self.is_check;
    NSLog(@"%@",param);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/submitTakeCoin"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
            [self.varcodeView hide];
            HBTakeTokenRecordViewController *recorder = [HBTakeTokenRecordViewController new];
            recorder.currency_id = self.model.currency_id;
            recorder.type = @"1";
            kNavPush(recorder);
            
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}

- (void)getVarcode:(UIButton *)sendButton{
    kShowHud;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/tcoinSandPhone"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
             [sendButton startTimeWithDuration1:60];
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
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
    NSLog(@"%d  %@  %@",result,validate,message);
    // App添加自己的处理逻辑
    if (result == YES) {
        _verifyStr = validate;
        kShowHud;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"validate"] = _verifyStr;
        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/validateYiDun"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
                [self showInputPasswordView];
            }else{
                [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    }else{
        _verifyStr = @"";
        [kKeyWindow showWarning:@"验证码错误"];
    }
}

- (void)setCurrencyNameString:(NSString *)currencyNameString {
    _currencyNameString = currencyNameString;
    self.currencyName.text = currencyNameString;
    self.leftLabel.text = currencyNameString;
}

- (void)setCurrency_id:(NSString *)currency_id{
    _currency_id = currency_id;
    NSLog(@"8888888888--------%@",_currency_id);
    [self loadData:_currency_id];
}

- (void)loadData:(NSString *)cid{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = cid;
    NSLog(@"%@",param);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/getUserCurrency"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            NSLog(@"%@",[responseObj ksObjectForKey:kResult]);
            self.model = [HBGetCurrenInfoModel mj_objectWithKeyValues:[responseObj ksObjectForKey:kResult]];
            NSLog(@"%@",self.model);
            if (!self.model.address) {
                self.addressContentLabel.text = @"";
                self.noteContent.text = @"";
                self.addressDefault.selected = NO;      
            }else{
                self.addressContentLabel.text = self.model.address.qianbao_url;
                self.noteContent.text = self.model.address.name;
                self.addressDefault.selected = YES;
            }
            self.shouxuLabel.text = [NSString stringWithFormat:@"%@(%@%%)",kLocat(@"HBTokenWithdrawViewController_placehoder_shouxu"),self.model.tcoin_fee];
            self.shouxuContentLabel.text = [NSString stringWithFormat:@"%@%@",@"0.0000",self.model.currency_name];
//            self.actualContentLabel.text = [NSString stringWithFormat:@"%@",model.currency_name];
            self.valiableCount.text = [NSString stringWithFormat:@"(%@%@)",kLocat(@"k_MyassetViewController_tableview_list_cell_middle_avali"),self.model.num];
            self.minMaxLabel.text = [NSString stringWithFormat:@"%@%@,  ",kLocat(@"HBTokenWithdrawViewController_placehoder_min"),self.model.currency_min_tibi];
            self.maxLabel.text = [NSString stringWithFormat:@"%@%@",kLocat(@"HBTokenWithdrawViewController_placehoder_max"),self.model.currency_all_tibi];
//            if (self.model.num >= self.model.currency_all_tibi) {
//                self.countContentLabel.text = self.model.currency_all_tibi;
//            }
            self.leftLabel.text = self.model.currency_name;
            self.actualContentLabel.text = [NSString stringWithFormat:@"0.000%@",self.model.currency_name];
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}

- (IBAction)selectAddress:(id)sender{
    HBSelectTokenTableViewController *select = [HBSelectTokenTableViewController new];
    select.select = ^(HBTokenListModel * _Nonnull model) {
        self.currencyName.text = model.currency_name;
        self.currency_id = model.currency_id;
        self.shouxuContentLabel.text = [NSString stringWithFormat:@"%@%@",model.tcoin_fee,model.currency_name];
        self.actualContentLabel.text = [NSString stringWithFormat:@"%@",model.currency_name];
        self.minMaxLabel.text = [NSString stringWithFormat:@"%@%@",kLocat(@"HBTokenWithdrawViewController_placehoder_min"),model.currency_min_tibi];
        self.maxLabel.text = [NSString stringWithFormat:@"%@%@",kLocat(@"HBTokenWithdrawViewController_placehoder_max"),model.currency_all_tibi];
    };
    kNavPush(select);
}


/**
 *  textField的代理方法，监听textField的文字改变
 *  textField.text是当前输入字符之前的textField中的text
 *
 *  @param textField textField
 *  @param range     当前光标的位置
 *  @param string    当前输入的字符
 *
 *  @return 是否允许改变
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    
    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        self.isHaveDian = YES;
    }else{
        self.isHaveDian = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.'))
        {
            return NO;
        }
        
        // 只能有一个小数点
        if (self.isHaveDian && single == '.') {
            return NO;
        }
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (self.isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length >= 6) {
                    return NO;
                }
            }
        }
    }
    
    return YES;
}



@end
