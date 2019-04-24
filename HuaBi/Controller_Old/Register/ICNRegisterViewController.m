//
//  ICNRegisterViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/1/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "ICNRegisterViewController.h"
#import "YJRegisterCell.h"
#import "CaptchaView.h"
#import "YJCommonWebController.h"
#import "ICNNationalityCell.h"
#import "ICNNationalityModel.h"

#define kRegisterPlaceHolderColor kColorFromStr(@"7c7c7c")
@interface ICNRegisterViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView * topView;

@property(nonatomic,assign)NSInteger cuurentIndex;

@property(nonatomic,strong)NSArray *phoneArray;
@property(nonatomic,strong)NSArray *EmailArray;

@property (nonatomic, strong) CaptchaView *captchView;
@property(nonatomic,strong)UIView *randomView;
@property(nonatomic,strong)UIButton *agreeButton;
/**  国籍  */
@property(nonatomic,copy)UITextField *naTF;
@property(nonatomic,copy)UITextField *phoneTF;
@property(nonatomic,copy)UITextField *codeTF;
@property(nonatomic,copy)UITextField *loginTF;
@property(nonatomic,copy)UITextField *login2TF;
@property(nonatomic,copy)UITextField *payTF;
@property(nonatomic,copy)UITextField *pay2TF;
@property(nonatomic,strong)UITextField *inviteTF;



@property(nonatomic,strong)YLButton *areaButton;
@property(nonatomic,strong)UIButton *sendButton;


@property(nonatomic,copy)UITextField *eNaTF;
@property(nonatomic,copy)UITextField *emailTF;
@property(nonatomic,copy)UITextField *eLoginTF;
@property(nonatomic,copy)UITextField *eLogin2TF;
@property(nonatomic,copy)UITextField *ePayTF;
@property(nonatomic,copy)UITextField *ePay2TF;
@property(nonatomic,copy)UITextField *eCodeTF;
@property(nonatomic,strong)UITextField *eInviteTF;

@property(nonatomic,assign)NSInteger second;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger verifyCode;
@property(nonatomic,strong)ICNNationalityModel *countryModel;



@property(nonatomic,strong)NSMutableArray<ICNNationalityModel *>* nationalityArrays;

@property(nonatomic,strong)UITableView *nationalityTableview;






@end

@implementation ICNRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _second = 180;
    [self setupUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self changeStatusBarColorWithWhite:YES];
}

-(void)setupUI
{
    self.view.backgroundColor = kWhiteColor;
    UIImageView *topView = [[UIImageView alloc] initWithFrame:kScreenBounds];
    topView.image = kImageFromStr(@"bg");
    [self.view addSubview:topView];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:kRectMake(0, 44 *kScreenHeightRatio,95 * kScreenHeightRatio *0.7 , 113 * kScreenHeightRatio *0.7)];
    logo.image = kImageFromStr(@"logo");
    [topView addSubview:logo];
    [logo alignHorizontal];

//    UIImageView *logo1 = [[UIImageView alloc] initWithFrame:kRectMake(0, logo.bottom + 15 *kScreenHeightRatio,94 * kScreenHeightRatio , 22 * kScreenHeightRatio)];
//    logo1.image = kImageFromStr(@"guojiyunwang");
//    [topView addSubview:logo1];
//    [logo1 alignHorizontal];
    
    self.titleWithNoNavgationBar = @"";

    
    UIView *bgView = [[UIView alloc] initWithFrame:kRectMake(19, 142 * kScreenHeightRatio, kScreenWidth - 38, 818 / 2.0  * kScreenHeightRatio)];

    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithRed:0.09 green:0.10 blue:0.14 alpha:1.00];;;
    bgView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    bgView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    bgView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    bgView.layer.shadowRadius = 3;//阴影半径，默认3
//    kViewBorderRadius(bgView, 15, 0, kRedColor);
    bgView.layer.cornerRadius = 15;
    
    
//    _tableView = [[UITableView alloc]initWithFrame:kRectMake(15, 372 / 2 * kScreenHeightRatio, kScreenWidth - 30, 405 * kScreenHeightRatio) style:UITableViewStylePlain];
//    [self.view addSubview:_tableView];
    _tableView = [[UITableView alloc]initWithFrame:bgView.bounds style:UITableViewStylePlain];
    [bgView addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
//    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [self createFooerView];
//    _tableView.tableHeaderView = [self creatHeaderView];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.backgroundColor = [UIColor colorWithRed:0.09 green:0.10 blue:0.14 alpha:1.00];
    kViewBorderRadius(_tableView, 15, 0, kRedColor);

    

     [_tableView registerNib:[UINib nibWithNibName:@"YJRegisterCell" bundle:nil] forCellReuseIdentifier:@"YJRegisterCell"];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = kColorFromStr(@"9e9e9e");
    label.text = kLocat(@"R_AgreeTip");
    label.font = PFRegularFont(12);
    label.userInteractionEnabled = YES;
    [label sizeToFit];
    [self.view addSubview:label];
    label.centerX = self.view.centerX;
    label.y = kScreenH - 30 *kScreenHeightRatio - 12;
    //    https://www.otcbuyme.com/Art/details/team_id/154.html.html
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        
        BaseWebViewController *vc = [[BaseWebViewController alloc] initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@/Mobile/Art/details/team_id/154",kBasePath]];
//        YJCommonWebController *vc = [[YJCommonWebController alloc] init];
//        vc.urlStr = [NSString stringWithFormat:@"%@/Mobile/Art/details/team_id/154.html.html",kBasePath];
        
        kNavPush(vc);
    }]];
    
    UIButton *agreeButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 12, 12)];
    [self.view addSubview:agreeButton];
    agreeButton.selected = YES;
    [agreeButton setImage:kImageFromStr(@"regsiter_agree") forState:UIControlStateNormal];
    [agreeButton setImage:kImageFromStr(@"regsiter_pressed") forState:UIControlStateSelected];
    [agreeButton sizeToFit];
    [agreeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *   sender) {
        sender.selected = !sender.isSelected;
    }];
    agreeButton.centerY = label.centerY;
    agreeButton.right = label.left - 5;
    _agreeButton = agreeButton;
    
    [self loadNationality];
}
-(void)loadNationality
{
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
    param[@"platform"] = @"ios";
    param[@"language"] = lang;
    
    param[@"uuid"] = [Utilities randomUUID];
    NSLog(@"%@",param);
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kCountrylist] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        NSLog(@"%@",responseObj);
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData];
            self.nationalityArrays = [NSMutableArray arrayWithCapacity:datas.count];
            for (NSDictionary *dic in datas) {
                [self.nationalityArrays addObject:[ICNNationalityModel modelWithJSON:dic]];
            }
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag) {
        return self.nationalityArrays.count;
    }
    
    if (_cuurentIndex == 0) {
        return self.phoneArray.count;
    }else{
        return self.EmailArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag) {
        static NSString *rid = @"ICNNationalityCell";
        ICNNationalityCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.model = self.nationalityArrays[indexPath.row];
        cell.topLine.hidden = indexPath.row;
        
        return cell;
    }
    
    static NSString *rid = @"YJRegisterCell";
    YJRegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    if (_cuurentIndex == 0) {
//        cell.itemLabel.text = self.phoneArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.xiala.hidden = NO;
            cell.TF.userInteractionEnabled = NO;
            _naTF = cell.TF;
            cell.icon.image = kImageFromStr(@"nationality");
            cell.TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"R_ChooseNa") attributes:@{NSForegroundColorAttributeName: kRegisterPlaceHolderColor}];
            cell.TF.text = kLocat(@"R_China");

            
        }else if (indexPath.row == 1){
            cell.phoneTF.hidden = NO;
            cell.TF.hidden = YES;
            cell.phoneButton.hidden = NO;
            _phoneTF = cell.phoneTF;
            cell.icon.image = kImageFromStr(@"phone");
            _areaButton = cell.phoneButton;
            cell.phoneTF.keyboardType = UIKeyboardTypePhonePad;
             cell.phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"LEnterPhoneNumber") attributes:@{NSForegroundColorAttributeName: kRegisterPlaceHolderColor}];
        }else if (indexPath.row == 2){
            cell.codeButton.hidden = NO;
            cell.TF.keyboardType = UIKeyboardTypeNumberPad;
            _codeTF = cell.TF;
            cell.icon.image = kImageFromStr(@"yanzhengma");
            cell.TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"LEnterVerificationCode") attributes:@{NSForegroundColorAttributeName: kRegisterPlaceHolderColor}];

            _sendButton = cell.codeButton;
            [cell.codeButton setTitle:kLocat(@"LGetVerificationCode") forState:UIControlStateNormal];
            [cell.codeButton addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.TF.secureTextEntry = NO;
            [cell.contentView bringSubviewToFront:cell.codeButton];
        }else if (indexPath.row == 3){
            _loginTF = cell.TF;
            cell.icon.image = kImageFromStr(@"login_password_icon");
            cell.TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"LEnterPWD") attributes:@{NSForegroundColorAttributeName: kRegisterPlaceHolderColor}];
            cell.TF.keyboardType = UIKeyboardTypeASCIICapable;
            cell.TF.secureTextEntry = YES;
        }else if (indexPath.row == 4){
            _login2TF = cell.TF;
            cell.icon.image = kImageFromStr(@"denglumima");
            cell.TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"LEnterPWDAgain") attributes:@{NSForegroundColorAttributeName: kRegisterPlaceHolderColor}];
            cell.TF.keyboardType = UIKeyboardTypeASCIICapable;
            cell.TF.secureTextEntry = YES;

        }else if (indexPath.row == 5){
            _payTF = cell.TF;
            cell.icon.image = kImageFromStr(@"login_password_icon");
            cell.TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"LEnterTransactionPWD") attributes:@{NSForegroundColorAttributeName: kRegisterPlaceHolderColor}];
            cell.TF.keyboardType = UIKeyboardTypeASCIICapable;
            cell.TF.secureTextEntry = YES;

        }else if (indexPath.row == 6){
            cell.randomView.hidden = YES;
            _pay2TF = cell.TF;
            cell.icon.image = kImageFromStr(@"denglumima");
            cell.TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"LEnterTransactionPWDAgain") attributes:@{NSForegroundColorAttributeName: kRegisterPlaceHolderColor}];
            cell.TF.keyboardType = UIKeyboardTypeASCIICapable;
            cell.TF.secureTextEntry = YES;
        }else if (indexPath.row == 7){
            cell.TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"LEnterInvatationCode") attributes:@{NSForegroundColorAttributeName: kRegisterPlaceHolderColor}];
            cell.TF.keyboardType = UIKeyboardTypeNumberPad;

            cell.icon.image = kImageFromStr(@"yanzhengma");
            _inviteTF = cell.TF;
        }
        
        
    }else{
        cell.itemLabel.text = self.EmailArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.xiala.hidden = NO;
            cell.TF.userInteractionEnabled = NO;
            cell.xiala.hidden = NO;
            cell.TF.userInteractionEnabled = NO;
            _eNaTF = cell.TF;
            cell.icon.image = kImageFromStr(@"nationality");
            cell.TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"R_ChooseNa") attributes:@{NSForegroundColorAttributeName: kRegisterPlaceHolderColor}];
            
            
        }else if (indexPath.row == 1){
            cell.icon.image = kImageFromStr(@"email");
            cell.phoneTF.hidden = YES;
            cell.TF.hidden = NO;
            cell.phoneButton.hidden = YES;
            cell.TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"R_EnterEmail") attributes:@{NSForegroundColorAttributeName: kRegisterPlaceHolderColor}];
            cell.TF.keyboardType = UIKeyboardTypeASCIICapable;
            _emailTF = cell.TF;
        }else if (indexPath.row == 2){
            cell.codeButton.hidden = YES;
            cell.icon.image = kImageFromStr(@"login_password_icon");

            cell.TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"LEnterPWD") attributes:@{NSForegroundColorAttributeName: kRegisterPlaceHolderColor}];
            cell.TF.keyboardType = UIKeyboardTypeASCIICapable;

            cell.TF.secureTextEntry = YES;
            _eLoginTF = cell.TF;
        }else if (indexPath.row == 3){
            cell.TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"LEnterPWDAgain") attributes:@{NSForegroundColorAttributeName: kRegisterPlaceHolderColor}];
            cell.icon.image = kImageFromStr(@"denglumima");
            _eLogin2TF = cell.TF;
            cell.TF.keyboardType = UIKeyboardTypeASCIICapable;

        }else if (indexPath.row == 4){
            cell.TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"LEnterTransactionPWD") attributes:@{NSForegroundColorAttributeName: kRegisterPlaceHolderColor}];
            cell.icon.image = kImageFromStr(@"login_password_icon");
            _ePayTF = cell.TF;
            cell.TF.keyboardType = UIKeyboardTypeASCIICapable;

        }else if (indexPath.row == 5){
            cell.TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"LEnterTransactionPWDAgain") attributes:@{NSForegroundColorAttributeName: kRegisterPlaceHolderColor}];
            cell.icon.image = kImageFromStr(@"denglumima");
            _ePay2TF = cell.TF;
            cell.TF.keyboardType = UIKeyboardTypeASCIICapable;

        }else if (indexPath.row == 6){
            cell.TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"LEnterVerificationCode") attributes:@{NSForegroundColorAttributeName: kRegisterPlaceHolderColor}];
            cell.icon.image = kImageFromStr(@"yanzhengma");
            cell.TF.keyboardType = UIKeyboardTypeASCIICapable;

            cell.randomView.hidden = NO;
            self.randomView = cell.randomView;
            //            cell.randomView.backgroundColor = kRedColor;
            [self captchView];
            cell.TF.secureTextEntry = NO;
            _eCodeTF = cell.TF;
        }else if (indexPath.row == 7){
            cell.TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"LEnterInvatationCode") attributes:@{NSForegroundColorAttributeName: kRegisterPlaceHolderColor}];
            cell.TF.keyboardType = UIKeyboardTypeNumberPad;
            
            cell.icon.image = kImageFromStr(@"yanzhengma");
            _eInviteTF = cell.TF;
        }
        
    }
    cell.topLine.hidden = indexPath.row;

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag) {
        ICNNationalityModel *model = self.nationalityArrays[indexPath.row];
        _countryModel = model;
        [self.nationalityArrays enumerateObjectsUsingBlock:^(ICNNationalityModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (indexPath.row == idx) {
                obj.isSelected = YES;
            }else{
                obj.isSelected = NO;
            }
        }];
        
        [tableView reloadData];
        _naTF.text = model.name;
        _eNaTF.text = model.name;
        [_areaButton setTitle:model.phone_code forState:UIControlStateNormal];
        [UIView animateWithDuration:0.25 animations:^{
            tableView.y = kScreenH;
        }];
        
    }else{
        if (indexPath.row == 0) {
            if (_nationalityTableview == nil) {
                [self nationalityTableview];
            }else{
                [UIView animateWithDuration:0.25 animations:^{
                    self.nationalityTableview.y = tableView.superview.y;
                }];
            }
        }
  
    }

}

-(UIView *)creatHeaderView
{
    UIView * topView = [[UIView alloc] initWithFrame:kRectMake(0, 0, _tableView.width, 50)];
    topView.userInteractionEnabled = YES;
    topView.backgroundColor = [UIColor colorWithRed:0.09 green:0.10 blue:0.14 alpha:1.00];
    CGFloat w = (_tableView.width - 45)/2.0;
    for (NSInteger i = 0; i < 2; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:kRectMake(22.5, 23, w ,20)];
        [topView addSubview:label];
        label.tag = i;
        label.userInteractionEnabled = YES;
        label.textAlignment = 1;
        label.font = PFRegularFont(16);
        label.backgroundColor = [UIColor colorWithRed:0.09 green:0.10 blue:0.14 alpha:1.00];
        UILabel *lineView = [[UILabel alloc] initWithFrame:CGRectMake(0, topView.height - 3, w, 3)];
        lineView.backgroundColor = kColorFromStr(@"dbb668");
        [topView addSubview:lineView];
        lineView.tag = i + 2;
        if (i == 0) {
            label.text = @"手机注册";
            label.textColor = kColorFromStr(@"dbb668");
        }else{
            label.textColor = kColorFromStr(@"7c7c7c");
            
            label.text = @"邮箱注册";
            label.x = 22.5 + w;
            lineView.hidden = YES;
        }
        
        lineView.x = label.x;
        
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topViewTapAction:)]];
    }
    return topView;
}

-(UIView *)createFooerView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:kRectMake(0, 0, _tableView.width, 160 *kScreenHeightRatio)];
    bottomView.backgroundColor = [UIColor colorWithRed:0.09 green:0.10 blue:0.14 alpha:1.00];
    
    UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(0, 23 * kScreenHeightRatio, bottomView.width - 110 *kScreenWidthRatio, 40 *kScreenHeightRatio)];
    [bottomView addSubview:button];
    [button alignHorizontal];
    [button setTitle:kLocat(@"LRegister") forState:UIControlStateNormal];
    [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
//    [button setBackgroundImage:kImageFromStr(@"btn_bg") forState:UIControlStateNormal];
    button.backgroundColor = kColorFromStr(@"dbb668");
    button.titleLabel.font = PFRegularFont(16);
    [button addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    kViewBorderRadius(button, button.height/2.0, 0, kColorFromStr(@"434343"));

    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:kRectMake(button.x, button.bottom + 15 *kScreenHeightRatio, button.width, button.height)];
    [bottomView addSubview:loginButton];
    bottomView.backgroundColor = kClearColor;
    kViewBorderRadius(loginButton, button.height/2.0, 0.5, kColorFromStr(@"434343"));
    
    NSString *registerStr = kLocat(@"R_HaveCount?");
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
    
    [loginButton setAttributedTitle:attributedStr forState:UIControlStateNormal];
//    [loginButton setTitleColor:kColorFromStr(@"7c7c7c") forState:UIControlStateNormal];
//    [loginButton setTitle:@"已经有账户号了" forState:UIControlStateNormal];
    loginButton.titleLabel.font = PFRegularFont(16);
    [loginButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (self.navigationController.viewControllers.count>= 2) {
            kNavPop;
        }else{
            kNavPush([ICNLoginViewController new]);
        }
    }];
    
//    UILabel *registerLabel = [[UILabel alloc] initWithFrame:kRectMake(0, button.bottom + 10, 200, 14)];
//    registerLabel.userInteractionEnabled = YES;
//    [bottomView addSubview:registerLabel];
//    registerLabel.right = button.right;
//
//    NSString *registerStr = kLocat(@"R_HaveCount?");
//    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:registerStr];
//    if (![[LocalizableLanguageManager userLanguage] containsString:@"?"]) {
//        [attributedStr addAttribute:NSForegroundColorAttributeName
//                              value:kRedColor
//                              range:NSMakeRange(0, registerStr.length)];
//    }else{
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
//    registerLabel.attributedText = attributedStr;
//    registerLabel.textAlignment = 2;
//    [registerLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toLoginAction)]];

    return bottomView;
}
#pragma mark - 注册
-(void)registerAction
{
//    kLOG(@"%@",[self.captchView.changeString.mutableCopy uppercaseString] );
    [self hideKeyBoard];
    
    if (_cuurentIndex == 0) {//手机注册
        if (_phoneTF.text.length == 0) {
            [self showTips:kLocat(@"LEnterPhoneNumber")];
            return;
        }
        if (_codeTF.text.length == 0) {
            [self showTips:kLocat(@"LEnterVerificationCode")];
            return;
        }
//        if (_codeTF.text.integerValue != _verifyCode) {
//            [self showTips:kLocat(@"LCodeError")];
//            return;
//        }
        
        if (_loginTF.text.length == 0 || _login2TF.text.length == 0) {
            [self showTips:kLocat(@"LEnterPWD")];
            return;
        }
        if (![_loginTF.text isEqualToString:_login2TF.text]) {
            [self showTips:kLocat(@"LLoginPWDNotSame")];
            return;
        }
        if (_loginTF.text.length < 6) {
            [self showTips:kLocat(@"LPWDLengthLessThan6")];
            return;
        }
        
        if (_payTF.text.length == 0||_pay2TF.text.length == 0) {
            [self showTips:kLocat(@"LEnterTransactionPWD")];
            return;
        }
        if (_payTF.text.length < 6 || _pay2TF.text.length < 6) {
            [self showTips:kLocat(@"LPWDLengthLessThan6")];
            return;
        }
        if (![_payTF.text isEqualToString:_pay2TF.text]) {
            [self showTips:kLocat(@"LPayPWDNotSame")];
            return;
        }
        
        if (_inviteTF.text.length == 0) {
            [self showTips:kLocat(@"k_PleaseEnerInviiteCode")];
            return;
        }
        if ([_loginTF.text isEqualToString:_payTF.text]) {
            [self showTips:kLocat(@"k_PayLoginPWDSame")];
            return;
        }
        
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"phone"] = _phoneTF.text;
        param[@"pwd"] = _loginTF.text;
        param[@"repwd"] = _login2TF.text;
        param[@"pwdtrade"] = _payTF.text;
        param[@"repwdtrade"] = _pay2TF.text;
        
        param[@"countrycode"] = _countryModel.phone_code;
        if (_countryModel == nil) {
            param[@"countrycode"] = @"86";
        }
        param[@"phone_code"] = _codeTF.text;
//        param[@"phone_code"] = _countryModel.phone_code;
//        if (_countryModel == nil) {
//            param[@"phone_code"] = @"86";
//        }
//        param[@"ename"] = _userNameTF.text;
        param[@"platform"] = @"ios";
        param[@"pid"] = _inviteTF.text;
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
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kUserRegisterPhone] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
                [SVProgressHUD showSuccessWithStatus:nil];
                [self showTips:kLocat(@"LRegisterSuccess")];
                [kUserDefaults setObject:_phoneTF.text forKey:@"kUserLoginAccountKey"];
                
                //保存数据
                YJUserInfo *model = [YJUserInfo modelWithJSON:[responseObj ksObjectForKey:kData]];
                [kUserDefaults setInteger:model.uid forKey:kUserIDKey];
                [model saveUserInfo];
                //保存当前登录时间
                [kUserDefaults setObject:[NSDate new] forKey:@"kLastLoginTimeKey"];
                //发通知
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessKey object:nil];

                kDismiss;
                return ;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    if (self.navigationController.viewControllers.count == 1) {
                        kNavPush([ICNLoginViewController new]);
                    }else{
                        kNavPop;
                    }
                });
                
            }else{
                [self showTips:[responseObj ksObjectForKey:kMessage]];
            }
        }];
   
    }else{
        if (_emailTF.text.length == 0) {
            [self showTips:kLocat(@"LEnterPhoneNumber")];
            return;
        }
        if (_eCodeTF.text.length == 0) {
            [self showTips:kLocat(@"LEnterVerificationCode")];
            return;
        }
        if (![[_eCodeTF.text uppercaseString] isEqualToString:[self.captchView.changeString.mutableCopy uppercaseString]]) {
            [self showTips:kLocat(@"LCodeError")];
            return;
        }
        if (_eLoginTF.text.length == 0 || _eLogin2TF.text.length == 0) {
            [self showTips:kLocat(@"LEnterPWD")];
            return;
        }
        if (![_eLoginTF.text isEqualToString:_eLogin2TF.text]) {
            [self showTips:kLocat(@"LLoginPWDNotSame")];
            return;
        }
        if (_eLoginTF.text.length < 6) {
            [self showTips:kLocat(@"LPWDLengthLessThan6")];
            return;
        }
        if (_ePayTF.text.length == 0||_ePay2TF.text.length == 0) {
            [self showTips:kLocat(@"LEnterTransactionPWD")];
            return;
        }
        if (_ePayTF.text.length < 6 || _ePay2TF.text.length < 6) {
            [self showTips:kLocat(@"LPWDLengthLessThan6")];
            return;
        }
        if (![_ePayTF.text isEqualToString:_ePay2TF.text]) {
            [self showTips:kLocat(@"LPayPWDNotSame")];
            return;
        }
        if (_eInviteTF.text.length == 0) {
            [self showTips:kLocat(@"k_PleaseEnerInviiteCode")];
            return;
        }
        if ([_ePayTF.text isEqualToString:_eLoginTF.text]) {
            [self showTips:kLocat(@"k_PayLoginPWDSame")];
            return;
        }
        
        
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"email"] = _emailTF.text;
        param[@"pwd"] = _eLoginTF.text;
        param[@"repwd"] = _eLogin2TF.text;
        param[@"pwdtrade"] = _ePayTF.text;
        param[@"repwdtrade"] = _ePay2TF.text;
        //        param[@"pid"] = _invitationTF.text;
        param[@"countrycode"] = _countryModel.phone_code;
        if (_countryModel == nil) {
            param[@"countrycode"] = @"86";
        }
        param[@"pid"] = _eInviteTF.text;
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

        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kUserRegisterEmail] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
                [SVProgressHUD showSuccessWithStatus:nil];
                [self showTips:kLocat(@"LRegisterSuccess")];
                [kUserDefaults setObject:_phoneTF.text forKey:@"kUserLoginAccountKey"];
                
                //保存数据
                YJUserInfo *model = [YJUserInfo modelWithJSON:[responseObj ksObjectForKey:kData]];
                [kUserDefaults setInteger:model.uid forKey:kUserIDKey];
                [model saveUserInfo];
                //保存当前登录时间
                [kUserDefaults setObject:[NSDate date] forKey:@"kLastLoginTimeKey"];
                //发通知
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessKey object:nil];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    kDismiss;
                });
                
            }else{
                [self showTips:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    }
}

-(void)topViewTapAction:(UITapGestureRecognizer *)tap
{
    NSInteger currentIndex = tap.view.tag;
    if (currentIndex == _cuurentIndex) {
        return;
    }
    if (currentIndex == 0) {//手机
        
        for (UILabel *label in tap.view.superview.subviews) {

            if (label.tag == 0) {
                label.textColor = kColorFromStr(@"dbb668");
            }else if (label.tag == 1){
                label.textColor = kColorFromStr(@"7c7c7c");
            }else if (label.tag == 2){
                label.hidden = NO;
            }else if (label.tag == 3){
                label.hidden = YES;
            }
        }
        _phoneTF.text = @"";
        _codeTF.text = @"";
        _loginTF.text = @"";
        _login2TF.text = @"";
        _payTF.text = @"";
        _pay2TF.text = @"";
        
    }else{//邮箱
        for (UILabel *label in tap.view.superview.subviews) {
            if (label.tag == 0) {
                label.textColor = kColorFromStr(@"7c7c7c");
            }else if (label.tag == 1){
                label.textColor = kColorFromStr(@"dbb668");
            }else if (label.tag == 2){
                label.hidden = YES;
            }else if (label.tag == 3){
                label.hidden = NO;
            }
        }
        _eLoginTF.text = @"";
        _eLogin2TF.text = @"";
        _ePayTF.text = @"";
        _ePay2TF.text = @"";
        _eCodeTF.text = @"";
        
    }
    _cuurentIndex = currentIndex;
    [self.tableView reloadData];
}


-(void)sendCodeAction:(UIButton *)button
{
    _verifyCode = 0;
    [self hideKeyBoard];
    if (_phoneTF.text.length == 0) {
        [self showTips:kLocat(@"LEnterPhoneNumber")];
        return;
    }
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        self.sendButton.userInteractionEnabled = NO;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"act"] = @"mb_login";
    param[@"op"] = @"setmessage";
    param[@"phone"] = _phoneTF.text;
    param[@"uuid"] = [Utilities randomUUID];
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kSenderSMS] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
//            _verifyCode = [[responseObj ksObjectForKey:kData] integerValue];
            //            kLOG(@"验证码 %zd",_verifyCode);
            kLOG(@"%@",[responseObj ksObjectForKey:kData]);
            [self showTips:LocalizedString(@"LCodeSendSuccess")];
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
            _second = 1;
        }
    }];
}
-(void)countDown
{
    _second --;
    if (_second == 0) {
        _sendButton.userInteractionEnabled = YES;
        [_sendButton setTitle:kLocat(@"LResend") forState:UIControlStateNormal];
        _second = 180;
        [_timer invalidate];
        _timer = nil;
    }else{
        _sendButton.userInteractionEnabled = NO;
        [_sendButton setTitle:[NSString stringWithFormat:@"%lds%@",(long)_second,kLocat(@"LResend")] forState:UIControlStateNormal];
    }
}

-(void)toLoginAction
{
    if (self.navigationController.viewControllers.count == 1) {
        [self.navigationController pushViewController:[ICNLoginViewController new] animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag) {
        return nil;
    }
    return self.topView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag) {
        return 44;
    }
    if (indexPath.section == 0) {
        if (kScreenW > 321) {
            return 49;
        }else{
            return 49 *kScreenHeightRatio;
        }

    }else if (indexPath.section == 1){
        return 44;
    }else{
        return 17;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag) {
        return 0.01;
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(NSArray *)phoneArray
{
    if (_phoneArray == nil) {
//        _phoneArray = @[@"国籍",@"手机号码",@"验证码",@"登录密码",@"重复密码",@"支付密码",@"重复密码"];
        _phoneArray = @[kLocat(@"R_nationality"),kLocat(@"R_PhoneNumber"),kLocat(@"R_VerifyCode"),kLocat(@"R_LoginPWD"),kLocat(@"R_RepeatPWD"),kLocat(@"R_PayPWD"),kLocat(@"R_RepeatPWD"),kLocat(@"LEnterInvatationCode")];

    }
    
    return _phoneArray;
}
-(NSArray *)EmailArray
{
    if (_EmailArray == nil) {
//        _EmailArray = @[@"国籍",@"电子邮箱",@"登录密码",@"重复密码",@"支付密码",@"重复密码",@"验证码"];
        _EmailArray = @[kLocat(@"R_nationality"),kLocat(@"R_Email"),kLocat(@"R_LoginPWD"),kLocat(@"R_RepeatPWD"),kLocat(@"R_PayPWD"),kLocat(@"R_RepeatPWD"),kLocat(@"R_VerifyCode"),kLocat(@"LEnterInvatationCode")];

    }
    return _EmailArray;
}
-(UIView *)topView
{
    if (_topView == nil) {
        UIView * topView = [[UIView alloc] initWithFrame:kRectMake(0, 0, _tableView.width, 50)];
        topView.userInteractionEnabled = YES;
        topView.backgroundColor = [UIColor colorWithRed:0.09 green:0.10 blue:0.14 alpha:1.00];
        CGFloat w = (_tableView.width - 38)/2.0;
        for (NSInteger i = 0; i < 2; i++) {
            UILabel * label = [[UILabel alloc]initWithFrame:kRectMake(19, 23, w ,20)];
            [topView addSubview:label];
            label.tag = i;
            label.userInteractionEnabled = YES;
            label.textAlignment = 1;
            label.font = PFRegularFont(16);
            label.adjustsFontSizeToFitWidth = YES;
            label.backgroundColor = [UIColor colorWithRed:0.09 green:0.10 blue:0.14 alpha:1.00];

            
            UILabel *lineView = [[UILabel alloc] initWithFrame:CGRectMake(0, topView.height - 3, w, 3)];
            lineView.backgroundColor = kColorFromStr(@"dbb668");
            [topView addSubview:lineView];
            lineView.tag = i + 2;
            if (i == 0) {
                label.text = kLocat(@"R_PhoneRegister");
                label.textColor = kColorFromStr(@"dbb668");
            }else{
                label.textColor = kColorFromStr(@"7c7c7c");
                label.text = kLocat(@"R_EmailRegister");
                label.x = 19 + w;
                lineView.hidden = YES;
            }
            
            lineView.x = label.x;
            
            [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topViewTapAction:)]];
            _topView = topView;
        }
    }
    return _topView;
}
- (CaptchaView *)captchView{
//    __weak typeof(self) weakSelf = self;
    if (_captchView == nil) {
        _captchView = [[CaptchaView alloc]initWithFrame:self.randomView.bounds];
        _captchView.backgroundColor = [UIColor lightGrayColor];
        
        /* 每次刷新验证码，都需将按钮置为不可用**/
//        _captchView.changeCaptchaBlock = ^(void){
//            [weakSelf.getPhoneCodeBtn setEnabled:NO];
//        };
        
        [self.randomView addSubview:_captchView];
    }
    return _captchView;
}

-(UITableView *)nationalityTableview
{
    if (_nationalityTableview == nil) {
        
        _nationalityTableview = [[UITableView alloc]initWithFrame:kRectMake(19, kScreenH, _tableView.width, _tableView.height) style:UITableViewStylePlain];
        [self.view addSubview:_nationalityTableview];
        
        _nationalityTableview.delegate = self;
        _nationalityTableview.dataSource = self;
        _nationalityTableview.showsVerticalScrollIndicator = NO;
        //    _tableView.bounces = NO;
        _nationalityTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        //取消多余的小灰线
        _nationalityTableview.tableFooterView = [UIView new];
        //    _tableView.tableHeaderView = [self creatHeaderView];
        _nationalityTableview.estimatedRowHeight = 0;
        _nationalityTableview.estimatedSectionFooterHeight = 0;
        _nationalityTableview.estimatedSectionHeaderHeight = 0;
        _nationalityTableview.backgroundColor = kWhiteColor;
        kViewBorderRadius(_nationalityTableview, 15, 0, kRedColor);
        _nationalityTableview.tag = 1;
        [UIView animateWithDuration:0.25 animations:^{
            _nationalityTableview.y = _tableView.superview.y;
        }];
         [_tableView registerNib:[UINib nibWithNibName:@"ICNNationalityCell" bundle:nil] forCellReuseIdentifier:@"ICNNationalityCell"];
    }
    
    return _nationalityTableview;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
} 

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.25 animations:^{
        _nationalityTableview.y = kScreenH;
    }];
    
}


@end
