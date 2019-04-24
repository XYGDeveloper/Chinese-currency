//
//  BindTeleViewController.m
//  YJOTC
//
//  Created by l on 2018/10/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "BindTeleViewController.h"
#import "HBSelectCodeOfCountryView.h"
#import "ICNNationalityModel+Request.h"

@interface BindTeleViewController ()<NTESVerifyCodeManagerDelegate,HBSelectCodeOfCountryViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *stepLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepleft;
@property (weak, nonatomic) IBOutlet UILabel *stepright;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightlabel;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *valcode;
@property (weak, nonatomic) IBOutlet UIButton *valbtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property(nonatomic,copy)NSString *verifyStr;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UIView *phoneBg;

@property (nonatomic,strong)NSString *countryCode;
@property (nonatomic, strong) NSArray<ICNNationalityModel *> *codesOfCountry;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;

@end

@implementation BindTeleViewController

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

- (IBAction)selectCountry:(id)sender {
    HBSelectCodeOfCountryView *view = [HBSelectCodeOfCountryView viewLoadNib];
    view.codesOfCountry = self.codesOfCountry;
    view.delegate = self;
    [view showInWindow];
}

#pragma mark - HBSelectCodeOfCountryViewDelegate

- (void)selectCodeOfCountryView:(HBSelectCodeOfCountryView *)view didSelectModel:(ICNNationalityModel *)model {
    [self.selectBtn setTitle:[NSString stringWithFormat:@"%@ ", model.name] forState:UIControlStateNormal];
    self.countryLabel.text = model.countrycode;
}

#pragma mark - Setters

- (void)setCodesOfCountry:(NSArray<ICNNationalityModel *> *)codesOfCountry {
    _codesOfCountry = codesOfCountry;
}

- (IBAction)getValcode:(id)sender {
    
    [self showVerifyInfo];
    
}

-(void)showVerifyInfo
{
    if (self.phone.text.length <= 0) {
        [self showTips:@"请输入手机号"];
        return;
    }
    [self.phone resignFirstResponder];
    [self.manager openVerifyCodeView:nil];
    
}

- (void)startTimer{
    __block int timeout=59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.valbtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.valbtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.valbtn setTitle:[NSString stringWithFormat:@"重新获取%@秒",strTime] forState:UIControlStateNormal];
                self.valbtn.titleLabel.font = HiraginoSans(12);
                self.valbtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


- (IBAction)commitAction:(id)sender {
    
    //提交
    if (self.phone.text.length <= 0) {
        [self showTips:@"请输入手机号"];
        return;
    }
    if (self.valcode.text.length <= 0) {
        [self showTips:@"请输入验证码"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = kUserInfo.user_id;
    param[@"phone"] = self.phone.text;
    param[@"phone_code"] = self.valcode.text;
    param[@"countrycode"] = self.countryLabel.text;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Account/bindphone"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self showTips:@"绑定手机号成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kNavPop;
            });
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.isBind = NO;
    [ICNNationalityModel requestCountryListWithSuccess:^(NSArray<ICNNationalityModel *> * _Nonnull array, YWNetworkResultModel * _Nonnull model) {
        self.codesOfCountry = array;
    } failure:^(NSError * _Nonnull error) {
        
    }];
    self.title = kLocat(@"k_BindphonesetViewController_title");
    self.stepleft.layer.cornerRadius = 15/2;
    self.stepleft.layer.masksToBounds = YES;
    self.stepright.layer.cornerRadius = 15/2;
    self.stepright.layer.masksToBounds = YES;
    self.view.backgroundColor = kRGBA(24, 30, 50, 1);
    self.commitBtn.layer.cornerRadius = 8;
    self.commitBtn.layer.masksToBounds = YES;
    self.leftLabel.text = kLocat(@"k_BindphoneViewController_t3");
    self.rightlabel.text = kLocat(@"k_BindphoneViewController_t4");
    self.phone.placeholder = kLocat(@"k_BindphonesetViewController_t1");
    self.valcode.placeholder = kLocat(@"k_BindphoneViewController_t2");
    self.phone.textColor = kColorFromStr(@"#7582A4");
    self.valcode.textColor = kColorFromStr(@"#7582A4");
    [self.phone setValue:kColorFromStr(@"#7582A4") forKeyPath:@"_placeholderLabel.textColor"];
    [self.valcode setValue:kColorFromStr(@"#7582A4") forKeyPath:@"_placeholderLabel.textColor"];
    if (self.isBind == YES) {
        self.bgview.hidden = YES;
        self.commitBtn.enabled = NO;
        self.phone.text = self.telepphone;
        self.phone.textColor = kColorFromStr(@"#7582A4");
        self.phone.userInteractionEnabled = NO;
        self.stepright.backgroundColor = kColorFromStr(@"#E96E44");
        self.stepLineLabel.backgroundColor = kColorFromStr(@"#E96E44");
        self.commitBtn.backgroundColor = kColorFromStr(@"#CCCCCC");
        [self.commitBtn setTitle:kLocat(@"k_Bined") forState:UIControlStateNormal];
        [self.commitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.phoneBg.mas_bottom).mas_equalTo(20);
            make.left.mas_equalTo(self.phoneBg.mas_left);
            make.right.mas_equalTo(self.phoneBg.mas_right);
            make.height.mas_equalTo(40);
        }];
        self.countryLabel.text = kLocat(@"HBLoginTableViewController_phone_placehoder");
        self.selectBtn.hidden = YES;
    }else{
        self.stepLineLabel.backgroundColor = kColorFromStr(@"#CCCCCC");
        self.stepright.backgroundColor = kColorFromStr(@"#CCCCCC");
        [self.commitBtn setTitle:kLocat(@"k_ModifysetViewController_b1") forState:UIControlStateNormal];
        [self.valbtn setTitle:kLocat(@"k_BindphoneViewController_b0") forState:UIControlStateNormal];
        [self initVerifyConfigure];
        self.countryLabel.text = @"86";
        self.selectBtn.hidden = NO;
    }
    // Do any additional setup after loading the view from its nib.
    
    [self.containerViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kThemeColor;
    }];
}



- (void)verifyCodeValidateFinish:(BOOL)result
                        validate:(NSString *)validate
                         message:(NSString *)message
{
    NSLog(@"%d  %@  %@ %@",result,validate,message,self.countryLabel.text);
    // App添加自己的处理逻辑
    if (result == YES) {
        _verifyStr = validate;
        [self startTimer];
        kShowHud;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"phone"] = self.phone.text;
        param[@"type"] = @"bindphone";
        param[@"country_code"] = self.countryLabel.text;
        param[@"validate"] = _verifyStr;
        param[@"uuid"] = [Utilities randomUUID];
        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kSenderSMS] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
                NSLog(@"验证码：%@",[responseObj ksObjectForKey:kData]);
                [self showTips:LocalizedString(@"LCodeSendSuccess")];
            }else{
                [self showTips:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    }else{
        _verifyStr = @"";
        [self showTips:@"验证码错误"];
    }
}

@end
