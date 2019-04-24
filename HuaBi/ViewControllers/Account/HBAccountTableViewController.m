//
//  HBAccountTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBAccountTableViewController.h"
#import "YTSetyViewController.h"
#import "AuthViewController.h"
#import "HBHelpCenterViewController.h"
#import "AuthViewController.h"
#import "YTSetyViewController.h"
#import "C2CViewController.h"
#import "MyAssetsViewController.h"
#import "HBLoginTableViewController.h"
#import "HBMemberViewController.h"
#import "HBRewardViewController.h"
#import "WSCameraAndAlbum.h"
#import "UIImage+ZXCompress.h"
#import "TPBaseOTCViewController.h"
#import "UserProfile.h"
#import "HBMyAssetDetailController.h"
#import "YTData_listModel.h"
#import "HBKOKAndKOKcyCurrencyInfoRequest.h"
#import <SafariServices/SFSafariViewController.h>
#import "HBCustomerServiceViewController.h"
#import "HBSelectPricingMethodTableViewController.h"
#import "HBTokenTopUpTableViewController.h"
#import "HBTokenWithdrawViewController.h"

// verify_state -1未认证 0未通过 1:已认证 2: 审核中


typedef NS_ENUM(NSInteger, HBAccountTableViewControllerType) {
    HBAccountTableViewControllerTypeProfile = 0,
    HBAccountTableViewControllerTypeAsset = 1,
    HBAccountTableViewControllerTypeMyKoK = 2,
    HBAccountTableViewControllerTypeMyKoKcy = 3,
    HBAccountTableViewControllerTypeReward = 4,
    HBAccountTableViewControllerTypeC2C = 5,
    HBAccountTableViewControllerTypeSubscribe = 6,
    HBAccountTableViewControllerTypeHoldingMoney = 7,
    HBAccountTableViewControllerTypeSecurity = 8,//
    HBAccountTableViewControllerTypeAuthentication = 9,
    HBAccountTableViewControllerTypeHelp = 10,
};

@interface HBAccountTableViewController ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *kokcyLabel;
@property (weak, nonatomic) IBOutlet UIButton *nikeName;
@property (weak, nonatomic) IBOutlet UILabel *uidLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *myAssetLabel;
@property (weak, nonatomic) IBOutlet UILabel *kokLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *setLabel;
@property (weak, nonatomic) IBOutlet UILabel *authLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UILabel *subscriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyInterestLabel;
//认证状态
@property (weak, nonatomic) IBOutlet UIImageView *authImg;
@property (weak, nonatomic) IBOutlet UILabel *authDes;
@property (strong, nonatomic) IBOutlet UIView *cellSelectedBackgroundView;
@property (nonatomic, assign) BOOL isFirstAppear;

@property (nonatomic, strong) ListModel *kok;
@property (nonatomic, strong) ListModel *kokcy;

@end

@implementation HBAccountTableViewController

+ (instancetype)fromStoryboard {
    return [UIStoryboard storyboardWithName:@"Account" bundle:nil].instantiateInitialViewController;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshHeader];
    [self updateUserInfo];
    [self.tableView reloadData];
    self.tableView.backgroundColor = kThemeBGColor;
}

- (void)updateUserInfo{
    
    
    if ([Utilities isExpired]) {
        return;
    }
    
    if (self.isFirstAppear) {
        kShowHud;
        self.isFirstAppear = NO;
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
    param[@"token_id"] = kUserInfo.user_id;
    param[@"key"] = kUserInfo.token;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Account/memberinfo"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        NSLog(@"---------%@",responseObj);
        kHideHud;
        if (success) {
            UserProfile *userProfile = [UserProfile mj_objectWithKeyValues:[responseObj ksObjectForKey:kData]];
            YJUserInfo *model = kUserInfo;
            model.user_name = userProfile.name;
            model.verify_state = userProfile.verify_state;
            model.name = userProfile.name;
            model.nick = userProfile.nick;
            [model saveUserInfo];

        }else{
            
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedString(@"account");
    self.isFirstAppear = YES;
    [self.containerViews enumerateObjectsUsingBlock:^(UIView  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       obj.backgroundColor = kColorFromStr(@"#0B132A");
    }];
    self.myAssetLabel.text = kLocat(@"HBAsetViewController_header");
    self.rewardLabel.text = kLocat(@"HBRewardViewController_header");
    self.setLabel.text = kLocat(@"k_YTsetViewController_s1_title");
    self.authLabel.text = kLocat(@"k_AuthViewController_title");
    self.helpLabel.text = kLocat(@"k_HBHelpCenteriewController_title");
    self.kokLabel.text = kLocat(@"k_HBAssetDetailiewController_kok");
    self.kokcyLabel.text = kLocat(@"k_HBAssetDetailiewController_kokcy");
    self.subscriptionLabel.text = kLocat(@"Subscription");
    self.moneyInterestLabel.text = kLocat(@"Money Interest title");
//    self.exchangeLabel.text = kLocat(@"Exchange");
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TaptoLoginP)];
//    [self.uidLabel addGestureRecognizer:tap];
//    if (![Utilities isExpired]) {
//        UITapGestureRecognizer *changeAvate = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAvater:)];
//        self.headImage.userInteractionEnabled = YES;
//        [self.headImage addGestureRecognizer:changeAvate];
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:kLoginSuccessKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutRefresh:) name:@"loginOutScuess" object:nil];
    [self _setupRightBarButtonItem];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([Utilities isExpired]) {
        [self gotoLoginVC];
        return NO;
    }
    
    return YES;
}

#pragma mark - Private

- (void)_setupRightBarButtonItem {
    UIButton *button = [UIButton new];
//    [button setTitle:kLocat(@"Customer Service") forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"kfu_icon"] forState:UIControlStateNormal];
    [button sizeToFit];
    button.titleLabel.font = [UIFont systemFontOfSize:12.];
    [button addTarget:self action:@selector(showCustomerServiceAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sz_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(_showSelectCurrencyTypeAction)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.rightBarButtonItems = @[item, item2];
}



- (void)changeAvater:(UITapGestureRecognizer *)tap{
    
    [WSCameraAndAlbum showSelectPicsWithController:self multipleChoice:NO selectDidDo:^(UIViewController *fromViewController, NSArray *selectedImageDatas) {
        {
            if(selectedImageDatas.count > 0){
                HBAccountTableViewController *vc = (HBAccountTableViewController *)fromViewController;
                UIImage *image = [[UIImage alloc]initWithData:selectedImageDatas[0]];
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                NSMutableArray *pic1Arr = [NSMutableArray array];
                [pic1Arr addObject:[vc UIImageToBase64Str:image]];
                param[@"key"] = kUserInfo.token;
                param[@"token_id"] = kUserInfo.user_id;
                param[@"img"] = [[vc arrayToJSONString:pic1Arr] base64EncodedString];
                
                [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Account/touxiang"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
                    NSLog(@"%@",responseObj);
                    [vc.view makeToast:[responseObj ksObjectForKey:kMessage]];
                    
                    if (success) {
                        [vc.view makeToast:kLocat(@"k_AuthViewController_uploadScuess")];
                        [kUserInfo setUser_head:[[responseObj ksObjectForKey:kData] ksObjectForKey:@"path"]];
                        [kUserInfo saveUserInfo];
                        YJUserInfo *model = kUserInfo;
                        model.user_head = [[responseObj ksObjectForKey:kData] ksObjectForKey:@"path"];
                        [model saveUserInfo];
                        
                    }else{
                        [vc.view makeToast:[responseObj ksObjectForKey:kMessage]];
                    }
                }];
            }
        }
    } cancleDidDo:^(UIViewController *fromViewController) {
        
    }];
}


- (void)refreshHeader{
    self.headImage.image = [UIImage imageNamed:@"default_avater"];
    if ([Utilities isExpired]) {
        self.headImage.layer.cornerRadius = 34/2;
        self.headImage.layer.masksToBounds = YES;
        
        [self.nikeName setTitle:kLocat(@"HBAccountTableViewController_isexpire") forState:UIControlStateNormal];
        self.uidLabel.text = @"";
        self.headImage.backgroundColor = kColorFromStr(@"#7582A4");
        self.authImg.image = [UIImage imageNamed:@""];
        self.authDes.text = @"";
    }else{
        self.headImage.layer.cornerRadius = 34/2;
        self.headImage.layer.masksToBounds = YES;
//        [self.headImage setImageWithURL:[NSURL URLWithString:kUserInfo.user_head] placeholder:[UIImage imageNamed:@"default_avater"]];
        self.headImage.backgroundColor = [UIColor clearColor];
        [self.nikeName setTitle:kUserInfo.seurityName forState:UIControlStateNormal];
        self.uidLabel.text = [NSString stringWithFormat:@"ID:%@",kUserInfo.user_id];
        switch ([Utilities getAuthStatus]) {
            case AuthenticationTypeRejected:
                self.authDes.text = kLocat(@"HBMemberViewController_authfailure");
                break;
            case AuthenticationTypeAuthented:
                self.authImg.image = [UIImage imageNamed:@"authed"];
                self.authDes.text = kLocat(@"HBMemberViewController_authscuess");
                break;
            case AuthenticationTypeAuditing:
                self.authDes.text = kLocat(@"HBMemberViewController_authstat3");
                break;
            case AuthenticationTypeNot:
                self.authDes.text = kLocat(@"HBMemberViewController_authstat0");
                break;
            default:
                break;
        }
    }
    
}

- (void)refresh:(NSNotification *)noti{
    if ([noti.name isEqualToString:kLoginSuccessKey]) {
        [self refreshHeader];
        [self.tableView reloadData];
    }
}

- (void)loginOutRefresh:(NSNotification *)noti{
    if ([noti.name isEqualToString:@"loginOutScuess"]) {
        [self refreshHeader];
        [self.tableView reloadData];
    }
}

#pragma mark - Actions

- (void)_showSelectCurrencyTypeAction {
    UIViewController *vc = [HBSelectPricingMethodTableViewController new];
    kNavPush(vc);
}

- (IBAction)showCustomerServiceAction:(id)sender {
    
//    BaseWebViewController *vc = [[BaseWebViewController alloc] initWithWebViewFrame:CGRectMake(0, 0, kScreenW, kScreenH - kNavigationBarHeight) title:kLocat(@"Customer Service")];
//    vc.urlStr = @"http://kefu.ziyun.com.cn/vclient/chat/?websiteid=142904&wc=225137&hidetitle=1";
//    vc.showNaviBar = YES;
//    kNavPush(vc);
    
    UIViewController *vc = [HBCustomerServiceViewController new];
    kNavPush(vc);
    
//    UIViewController *vc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://kefu.ziyun.com.cn/vclient/chat/?websiteid=142904&wc=225137"]];
//    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == HBAccountTableViewControllerTypeHoldingMoney  ) {
//        return 0.;
//    }
//    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectedBackgroundView = self.cellSelectedBackgroundView;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case HBAccountTableViewControllerTypeProfile: {
            [self TaptoLoginP];
        }
            break;

            case HBAccountTableViewControllerTypeHelp:

            kNavPush([HBHelpCenterViewController new]);
//            kNavPush([HBTokenTopUpTableViewController fromStoryboard]);
//              kNavPush([HBTokenWithdrawViewController fromStoryboard]);
            break;

            case HBAccountTableViewControllerTypeAuthentication:
            //使用 storyboard segue 进行跳转
            break;

            case HBAccountTableViewControllerTypeSecurity:

            if ([Utilities isExpired]) {
                UIViewController *vc = [HBLoginTableViewController fromStoryboard];
                [self presentViewController:vc animated:YES completion:nil];
                return;
            }else{
                kNavPush([YTSetyViewController new]);
            }
             
            break;
            case HBAccountTableViewControllerTypeAsset:
            if ([Utilities isExpired]) {
                UIViewController *vc = [HBLoginTableViewController fromStoryboard];
                [self presentViewController:vc animated:YES completion:nil];
                return;
            }else{
                kNavPush([MyAssetsViewController new]);
            }
          
            break;

            case HBAccountTableViewControllerTypeReward:
            if ([Utilities isExpired]) {
                UIViewController *vc = [HBLoginTableViewController fromStoryboard];
                [self presentViewController:vc animated:YES completion:nil];
                return;
            }else{
                kNavPush([HBRewardViewController new]);
            }
           
            break;

            case HBAccountTableViewControllerTypeMyKoK:

            if ([Utilities isExpired]) {
                UIViewController *vc = [HBLoginTableViewController fromStoryboard];
                [self presentViewController:vc animated:YES completion:nil];
                return;
            }else{
                [self mykokWithCompletion:^(ListModel *kok, ListModel *kokcy) {
                    HBMyAssetDetailController *vc = [HBMyAssetDetailController new];
                    vc.title = kLocat(@"k_HBAssetDetailiewController_kok");
                    vc.current_id = kok.currency_id;
                    vc.currencyName = kok.currency_name;
                    kNavPush(vc);
                }];
            }
            
            break;
            
        case HBAccountTableViewControllerTypeMyKoKcy: {
            if ([Utilities isExpired]) {
                UIViewController *vc = [HBLoginTableViewController fromStoryboard];
                [self presentViewController:vc animated:YES completion:nil];
                return;
            }else{
                [self mykokWithCompletion:^(ListModel *kok, ListModel *kokcy) {
                    HBMyAssetDetailController *vc = [HBMyAssetDetailController new];
                    vc.title = kLocat(@"k_HBAssetDetailiewController_kokcy");
                    vc.current_id = kokcy.currency_id;
                    vc.currencyName = kokcy.currency_name;
                    kNavPush(vc);
                }];
               
            }
            
            break;
        }
            
        case HBAccountTableViewControllerTypeC2C:
        
            if ([Utilities isExpired]) {
                UIViewController *vc = [HBLoginTableViewController fromStoryboard];
                [self presentViewController:vc animated:YES completion:nil];
                return;
            }else{
                if (kUserInfo.verify_state.intValue == 1) {
                    kNavPush([C2CViewController new]);
                }else{
                    [self.view makeToast:kLocat(@"k_in_c2c_tips")];
                }
            }
            
            break;
            
        default:
            break;
    }

}

- (void)mykokWithCompletion:(void(^)(ListModel *kok, ListModel *kokcy))completion{
    
    if (self.kok) {
        if (completion) {
            completion(self.kok, self.kokcy);
        }
        return;
    }
    kShowHud;
    [[HBKOKAndKOKcyCurrencyInfoRequest sharedInstance] requestMyKokWithCompletion:^(ListModel * _Nonnull kok, ListModel * _Nonnull kokcy, NSError * _Nonnull error) {
        kHideHud;
        if (!error) {
            self.kok = kok;
            self.kokcy = kokcy;
            if (completion) {
                completion(kok, kokcy);
            }
        }
    }];
}

- (IBAction)toLogin:(id)sender {
    if (![Utilities isExpired]) {
        kNavPush([HBMemberViewController new]);
    }else{
        UIViewController *vc = [HBLoginTableViewController fromStoryboard];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)TaptoLoginP{
    if (![Utilities isExpired]) {
        kNavPush([HBMemberViewController new]);
    }else{
        UIViewController *vc = [HBLoginTableViewController fromStoryboard];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (BOOL)islogin{
    if (kUserInfo.token) {
        return NO;
    }
    UIViewController *vc = [HBLoginTableViewController fromStoryboard];
    [self presentViewController:vc animated:YES completion:nil];
    return YES;
}

-(NSString *)UIImageToBase64Str:(UIImage *)image{
    UIImage *tempimage = [UIImage imageWithData:UIImageJPEGRepresentation(image,0.7)];
    //    UIImage *image = _avatar.image;
    CGSize size = [UIImage zx_scaleImage:tempimage length:100.];
    tempimage = [tempimage zx_imageWithNewSize:size];
    NSString *str = [NSString stringWithFormat:@"%@%@",@"data:image/jpeg;base64,",[Utilities encodeToBase64StringWithImage:tempimage]];
    return str;
}

- (NSString *)arrayToJSONString:(NSArray *)array
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
