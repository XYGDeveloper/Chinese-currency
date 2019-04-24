//
//  MeViewController.m
//  YJOTC
//
//  Created by l on 2018/9/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MeViewController.h"
#import "HeaderTableViewCell.h"
#import "LoginOutTableViewCell.h"
#import "UserInfoViewController.h"
#import <UIButton+YYWebImage.h>
#import "TOActionSheet.h"
#import "MyInviteViewController.h"
#import "MymineViewController.h"
#import "MyBonusViewController.h"
#import "MyRecommendViewController.h"
#import "OnViewController.h"
#import "ContactViewController.h"
#import "MyAssetsViewController.h"
#import "C2CViewController.h"
#import "TPCurrencyInfoController.h"
#import "YTLoginManager.h"
#import "YTSetyViewController.h"
#import "AuthViewController.h"
@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *MeTableview;

@property (nonatomic,strong)HeaderTableViewCell *head;

@end

@implementation MeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPage:) name:kLoginSuccessKey object:nil];
    self.navigationController.navigationBar.hidden = NO;
    [self.MeTableview reloadData];
    [self refreshHeader];
}

- (void)refreshPage:(NSNotification *)noti{
    if ([noti.name isEqualToString:kLoginSuccessKey] ||[noti.name isEqualToString:@"loginOutScuess"]) {
        [self refreshHeader];
        [self.MeTableview reloadData];
    }
}

- (void)refreshHeader{
    if ([Utilities isExpired]) {
        self.head.uid.text = @"";
        self.head.accountLabel.text = kLocat(@"k_meViewcontroler_loginAndLoginOut");
        self.head.nameLabel.text = @"";
         [self.head.headImg setBackgroundImageWithURL:[NSURL URLWithString:kUserInfo.avatar] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"default_avater"]];
    }else{
        NSLog(@"------------------------%@",kUserInfo.user_name);
        [self.head.headImg setBackgroundImageWithURL:[NSURL URLWithString:kUserInfo.avatar] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"default_avater"]];
        self.head.uid.text = [NSString stringWithFormat:@"UID:%ld",kUserInfo.uid];
        self.head.accountLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"k_meViewcontroler_laccountDes"),kUserInfo.phone];
        if (!kUserInfo.user_name || kUserInfo.user_name.length <= 0) {
            self.head.nameLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"k_meViewcontroler_nameDes"),kLocat(@"k_meViewcontroler_loginout_set")];
        }else{
            self.head.nameLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"k_meViewcontroler_nameDes"),kUserInfo.user_name];
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enablePanGesture = NO;
    self.navigationItem.title = kLocat(@"k_meViewcontroler_title");
    [self.MeTableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.MeTableview registerNib:[UINib nibWithNibName:@"LoginOutTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([LoginOutTableViewCell class])];
    HeaderTableViewCell *head =  [[[NSBundle mainBundle] loadNibNamed:@"HeaderTableViewCell" owner:nil options:nil] lastObject];
    self.head.headImg.userInteractionEnabled = YES;
    head.userInteractionEnabled = YES;
    self.head = head;
    self.MeTableview.tableHeaderView = self.head;
    self.MeTableview.showsVerticalScrollIndicator = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toLogin)];
    [self.head.headImg addTarget:self action:@selector(toLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.head.accountLabel addGestureRecognizer:tap];
    self.view.backgroundColor = kColorFromStr(@"#FFF4F4F4");
    self.MeTableview.separatorColor = kColorFromStr(@"#DDDDDD");
    self.MeTableview.backgroundColor = kColorFromStr(@"#F4F4F4");

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPage:) name:@"loginOutScuess" object:nil];
    [self refreshHeader];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)toLogin{
    if ([Utilities isExpired]) {
        ICNLoginViewController*vc = [[ICNLoginViewController alloc]init];
        [self presentViewController:[[YJBaseNavController alloc]initWithRootViewController:vc] animated:YES completion:nil];
    }else{
        kNavPush([UserInfoViewController new]);

        //用户信息
//        kNavPush([UserInfoViewController new]);
//           BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@",kBasePath,real_name]];
//           kNavPush(vc);
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([Utilities isExpired]) {
        return 1;
    }else{
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([Utilities isExpired]) {
        return 3;
    }else{
        if (section == 0) {
            return 7;
        }else if (section == 1){
            return 7;
        }else{
            return 1;
        }
    }
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([Utilities isExpired]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *sectionTwo = @[kLocat(@"k_meViewcontroler_s2_4"),kLocat(@"k_meViewcontroler_s2_5"),kLocat(@"k_meViewcontroler_s2_6")];
        NSArray *sectionTwoImg = @[@"s2_4",@"s2_5",@"s2_6"];
        cell.imageView.image = [UIImage imageNamed:sectionTwoImg[indexPath.row]];
        cell.textLabel.text = [sectionTwo objectAtIndex:indexPath.row];
        cell.textLabel.textColor = kColorFromStr(@"#333333");
        cell.textLabel.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:16];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {
            NSArray *sectionOne = @[kLocat(@"k_meViewcontroler_s1_1"),kLocat(@"k_meViewcontroler_s1_2"),kLocat(@"k_meViewcontroler_s1_3"),kLocat(@"k_meViewcontroler_s1_5"),kLocat(@"k_meViewcontroler_s1_6"),kLocat(@"k_meViewcontroler_s1_7"),kLocat(@"k_meViewcontroler_s1_4")];
            NSArray *sectionOneImg = @[@"s1_1",@"s1_2",@"s1_3",@"s1_5",@"s1_6",@"s1_7",@"s1_4"];
            
            cell.imageView.image = [UIImage imageNamed:sectionOneImg[indexPath.row]];
            cell.textLabel.text = [sectionOne objectAtIndex:indexPath.row];
            cell.textLabel.textColor = kColorFromStr(@"#333333");
            cell.textLabel.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:16];
        }else if (indexPath.section == 1){
            NSArray *sectionTwo = @[kLocat(@"k_meViewcontroler_s2_1"),kLocat(@"k_meViewcontroler_s2_2"),kLocat(@"k_meViewcontroler_s2_3"),kLocat(@"k_meViewcontroler_s2_4"),kLocat(@"k_meViewcontroler_s2_5"),kLocat(@"k_meViewcontroler_s2_6"),kLocat(@"k_meViewcontroler_s2_7")];
            NSArray *sectionTwoImg = @[@"s2_1",@"s2_2",@"s2_3",@"s2_4",@"s2_5",@"s2_6",@"s2_7"];
            cell.imageView.image = [UIImage imageNamed:sectionTwoImg[indexPath.row]];
            cell.textLabel.text = [sectionTwo objectAtIndex:indexPath.row];
            cell.textLabel.textColor = kColorFromStr(@"#333333");
            cell.textLabel.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:16];
        }else{
            LoginOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LoginOutTableViewCell class])];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kScreenW);
            cell.lout = ^{
                TOActionSheet *actionSheet = [[TOActionSheet alloc] init];
                actionSheet.title = kLocat(@"k_meViewcontroler_loginout");
                actionSheet.contentstyle = TOActionSheetContentStyleDefault;
                [actionSheet addButtonWithTitle:kLocat(@"k_meViewcontroler_loginout_sure") icon:nil tappedBlock:^{
                    [self loginOutAction];
                }];
                actionSheet.actionSheetDismissedBlock = ^{
                    NSLog(@"dissmiss");
                };
                [actionSheet showFromView:nil inView:self.view];
                
            };
            return cell;
        }
        return cell;
    }
    
}

- (void)loginOutAction{
    
    [BQActivityView showActiviTy];
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
    param[@"token"] = kUserInfo.token;
    param[@"uuid"] = [Utilities randomUUID];
    param[@"token_id"] = [NSString stringWithFormat:@"%ld",kUserInfo.uid];
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:loginOut] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        if (error) {
            [self showTips:error.localizedFailureReason];
        }
        [BQActivityView hideActiviTy];
        NSLog(@"%@",responseObj);
        if (success) {
            kLOG(@"%@",[responseObj ksObjectForKey:kData]);
            [self showTips:[responseObj ksObjectForKey:kMessage]];
            [YTLoginManager logout];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  
    if (@available(iOS 11.0, *)) {
        return 10;
    }else{
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
        foot.backgroundColor = kColorFromStr(@"#F4F4F4");
        return foot;
    }else{
        UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
        foot.backgroundColor = kColorFromStr(@"#F4F4F4");
        return foot;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([Utilities isExpired]) {
        if (indexPath.row == 0) {
            BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@?ts=%@",kBasePath,helpCenter,[Utilities dataChangeUTC]]];
            //                vc.showNaviBar = YES;
            kNavPush(vc);
        }else if (indexPath.row == 1){
            //关于我们
            kNavPush([OnViewController new]);
        }else{
            kNavPush([ContactViewController new]);
        }
    }else{
        if (indexPath.section == 0) {
            //
            if (indexPath.row == 0) {
                //基本信息
                kNavPush([UserInfoViewController new]);

            }else if (indexPath.row == 1){
                //我的资产AccountManage
                kNavPush([MyAssetsViewController new]);
            }else if (indexPath.row == 2){
                //财务日志
                BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@?ts=%@",kBasePath,widthdraw,[Utilities dataChangeUTC]]];
                //                vc.showNaviBar = YES;
                kNavPush(vc);
            }else if (indexPath.row == 3){
                //我的挖矿
                kNavPush([MymineViewController new]);
                
            }else if (indexPath.row == 4){
                kNavPush([MyBonusViewController new]);

            }else if (indexPath.row == 5){
                
                kNavPush([MyRecommendViewController new]);

            }else{
                //安全设置
//                BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@?ts=%@",kBasePath,bank,[Utilities dataChangeUTC]]];
//                //                vc.showNaviBar = YES;
//                kNavPush(vc);
                kNavPush([YTSetyViewController new]);
            }
        }else if (indexPath.section == 1){
            //
            if (indexPath.row == 0) {
                //实名认证
//                BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@?ts=%@",kBasePath,new_name_operation,[Utilities dataChangeUTC]]];
//                //                vc.showNaviBar = YES;
//                kNavPush(vc);
                kNavPush([AuthViewController new]);
            }else if (indexPath.row == 1){
                //C2C交易
//                kNavPush([C2CViewController new]);
                BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@?ts=%@",kBasePath,Ctrade,[Utilities dataChangeUTC]]];
                //                vc.showNaviBar = YES;
                kNavPush(vc);
            }else if (indexPath.row == 2){
                kNavPush([MyInviteViewController new]);
  
            }else if (indexPath.row == 3){
                //帮助中心
                BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@?ts=%@",kBasePath,helpCenter,[Utilities dataChangeUTC]]];
                //                vc.showNaviBar = YES;
                kNavPush(vc);
            }else if (indexPath.row == 4){
                //关于我们
                kNavPush([TPCurrencyInfoController new]);
            }else if (indexPath.row == 5){
                kNavPush([ContactViewController new]);
            }else{
                //推广二维码
                BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@?ts=%@",kBasePath,qrcode6,[Utilities dataChangeUTC]]];
//                vc.showNaviBar = YES;
                kNavPush(vc);
            }
        }
    }
}

@end
