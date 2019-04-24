//
//  BindMailViewController.m
//  YJOTC
//
//  Created by l on 2018/10/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "BindMailViewController.h"
#import "PooCodeView.h"
@interface BindMailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *stepLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepleft;
@property (weak, nonatomic) IBOutlet UILabel *stepright;

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *vacode;
@property (weak, nonatomic) IBOutlet UIButton *comBtn;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (nonatomic, strong) PooCodeView *pooCodeView;
@property (weak, nonatomic) IBOutlet UIView *mailBg;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;

@end

@implementation BindMailViewController

- (IBAction)commitAction:(id)sender {
   
    if (self.email.text.length <= 0) {
        [self showTips:kLocat(@"bindemail_tip")];
        return;
    }
    if (self.vacode.text.length <= 0) {
        [self showTips:kLocat(@"bindemail_tip1")];
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
    param[@"email"] = self.email.text;
    param[@"email_code"] = self.vacode.text;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Account/bindemail"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self showTips:kLocat(@"bindemail_scuess")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kNavPop;
            });
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.email becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_BindsetViewController_title");
    self.stepleft.layer.cornerRadius = 15/2;
    self.stepleft.layer.masksToBounds = YES;
    self.stepright.layer.cornerRadius = 15/2;
    self.stepright.layer.masksToBounds = YES;
    self.view.backgroundColor = kRGBA(24, 30, 50, 1);
   
    self.leftLabel.text = kLocat(@"k_BindsetViewController_t3");
    self.rightLabel.text = kLocat(@"k_BindsetViewController_t4");
    self.comBtn.layer.cornerRadius = 8;
    self.comBtn.layer.masksToBounds = YES;
    self.email.placeholder = kLocat(@"k_BindsetViewController_t1");
    self.vacode.placeholder = kLocat(@"k_BindsetViewController_t2");
    [self.email setValue:kColorFromStr(@"#7582A4") forKeyPath:@"_placeholderLabel.textColor"];
    [self.vacode setValue:kColorFromStr(@"#7582A4") forKeyPath:@"_placeholderLabel.textColor"];
    if (self.isBind == YES) {
        self.bgView.hidden = YES;
        self.email.text = self.mail;
        self.email.textColor = kColorFromStr(@"#7582A4");
        self.email.userInteractionEnabled = NO;
        self.stepright.backgroundColor = kColorFromStr(@"#E96E44");
        self.stepLineLabel.backgroundColor = kColorFromStr(@"#E96E44");
        self.comBtn.backgroundColor = kColorFromStr(@"#CCCCCC");
        self.comBtn.enabled = NO;
        [self.comBtn setTitle:kLocat(@"k_Bined") forState:UIControlStateNormal];
        [self.comBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mailBg.mas_bottom).mas_equalTo(20);
            make.left.mas_equalTo(self.mailBg.mas_left);
            make.right.mas_equalTo(self.mailBg.mas_right);
            make.height.mas_equalTo(40);
        }];
    }else{
        self.stepLineLabel.backgroundColor = kColorFromStr(@"#CCCCCC");
        self.stepright.backgroundColor = kColorFromStr(@"#CCCCCC");
        [self.comBtn setTitle:kLocat(@"k_BindsetViewController_b1") forState:UIControlStateNormal];
        [self.sendBtn setTitle:kLocat(@"k_BindphoneViewController_b0") forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view from its nib.
    
    [self.containerViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = kThemeColor;
    }];
}


- (IBAction)sendValCode:(id)sender {
    
    if (self.email.text.length <= 0) {
        [self showTips:kLocat(@"bindemail_tip")];
        return;
    }
    [self startTimer];
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
    param[@"email"] = self.email.text;
    param[@"type"] = @"bindemail";
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Email/code"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            NSLog(@"验证码：%@",[responseObj ksObjectForKey:kData]);
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
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
                [self.sendBtn setTitle:kLocat(@"bindemail_send_1") forState:UIControlStateNormal];
                self.sendBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.sendBtn setTitle:[NSString stringWithFormat:@"%@%@",kLocat(@"bindemail_send_2"),strTime] forState:UIControlStateNormal];
                self.sendBtn.titleLabel.font = HiraginoSans(12);
                self.sendBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


@end
