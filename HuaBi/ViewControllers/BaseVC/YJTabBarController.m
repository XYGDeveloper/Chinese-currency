//
//  YJTabBarController.m
//  YJOTC
//
//  Created by 周勇 on 2017/12/22.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YJTabBarController.h"
#import "YJBaseViewController.h"
#import "YJBaseNavController.h"
#import "YJMainViewController.h"
#import "YJMineViewController.h"
#import "FXBlurView.h"
#import "YJDiscoverViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "YWCircleViewController.h"
#import "YTMainViewController.h"
#import "YTMineViewController.h"
#import "YTDealViewController.h"
#import "MeViewController.h"
#import "IndexViewController.h"
#import "QuotationViewController.h"
#import "NewViewController.h"
#import "QuotationViewController.h"
#import "TPBaseOTCViewController.h"
#import "HBQuotationViewController.h"
#import "HBShopViewController.h"

#define kAnimationTime 0.25

@interface YJTabBarController ()<UITabBarControllerDelegate>
@property(nonatomic,strong)MeViewController *mineVC;
@property(nonatomic,strong)UIViewController *nnewVC;
@property(nonatomic,strong)IndexViewController *nmainVC;
@property(nonatomic,strong)UIViewController *newsVC;
@property (nonatomic, strong) UIViewController *tradeVC;
@property (nonatomic, strong) UIViewController *otcVC;
@property (nonatomic, strong) UIViewController *accountVC;
@property (nonatomic, strong) UIViewController *homeVC;
@property (nonatomic, strong) UIViewController *shopVC;

@property(nonatomic,strong)NSArray *imagesArray;
@property(nonatomic,strong)NSArray *selctedImagesArray;
@property(nonatomic,strong)NSArray *titleArray;

@end

@implementation YJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addChildViewControllers];
    [self.tabBar setBarTintColor:kColorFromStr(@"#0B132A")];
    self.tabBar.translucent = NO;
    self.delegate = self;
    [self registerNotifications];

}

-(void)addChildViewControllers
{
    YJBaseNavController *nav0 = [[YJBaseNavController alloc] initWithRootViewController:self.homeVC];
    YJBaseNavController *nav1 = [[YJBaseNavController alloc] initWithRootViewController:self.nnewVC];
    YJBaseNavController *nav2 = [[YJBaseNavController alloc] initWithRootViewController:self.tradeVC];
    YJBaseNavController *nav3 = [[YJBaseNavController alloc] initWithRootViewController:self.newsVC];
    YJBaseNavController *nav4 = [[YJBaseNavController alloc] initWithRootViewController:self.shopVC];
    
//    self.viewControllers = @[nav3,nav0,nav1,nav2,nav4];
    self.viewControllers = @[nav0,nav1,nav2,nav3,nav4];
    
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kColorFromStr(@"#7582A4")} forState:UIControlStateNormal];
        [obj.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kColorFromStr(@"#DEE5FF")} forState:UIControlStateSelected];
    }];
}



- (void)setUpOneChildViewController:(UIViewController *)vc image:(NSString *)image selectImage:(NSString *)selectImage
{
    //描述对应的按钮的内容
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity {
    
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.tabBar.bounds);
    self.tabBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.tabBar.layer.shadowColor = color.CGColor;
    self.tabBar.layer.shadowOffset = offset;
    self.tabBar.layer.shadowRadius = radius;
    self.tabBar.layer.shadowOpacity = opacity;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.tabBar.clipsToBounds = NO;
}





#pragma mark - 环信
-(void)userDidLoginOut
{
    //环信
//    if ([[EMClient sharedClient] isLoggedIn]) {
//        [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
//            if (aError) {
//                NSLog(@"%@",aError);
//            }else{
//                NSLog(@"环信登出成功");
//                [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessageCountKey object:@(0)];
//            }
//        }];
//    }
    //极光
    //    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
    //        NSLog(@"极光别名删除成功");
    //    } seq:0];
}


-(void)userDidLogin
{
//    YJUserInfo *model = kUserInfo;
//    NSString *userName = [NSString stringWithFormat:@"%zd",model.uid];
//    NSString *pwd = model.hx_password;
//    [[EMClient sharedClient] loginWithUsername:userName password:pwd completion:^(NSString *aUsername, EMError *aError) {
//        if (!aError) {
//            NSLog(@"用户<=%@=>即时通讯登录成功",aUsername);
//            BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
//            if (isAutoLogin == NO) {
//                //设置是否自动登录
//                [[EMClient sharedClient].options setIsAutoLogin:YES];
//            }
//
//            EMError *error = [[EMClient sharedClient] bindDeviceToken:[kUserDefaults objectForKey:kDeviceTokenKey]];
//            if (error) {
//                NSLog(@"%@",error.errorDescription);
//            }
//            [[EMClient sharedClient] setApnsNickname:kUserInfo.nickName];
//            [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
//            EMPushOptions *options = [[EMClient sharedClient] pushOptions];
//            options.displayName = kUserInfo.nickName;
//            options.displayStyle = EMPushDisplayStyleMessageSummary; // 显示消息内容
//            //            options.displayStyle = EMPushDisplayStyleSimpleBanner; // 显示“您有一条新消息”
//
//            dispatch_sync(dispatch_get_global_queue(0, 0), ^{
//
//                EMError *optionError = [[EMClient sharedClient] updatePushOptionsToServer]; // 更新配置到服务器，该方法为同步方法，如果需要，请放到单独线程
//                if(!optionError) {
//                    // 成功
//                    NSLog(@"环信配置更新到服务器");
//                }else {
//                    // 失败
//                }
//            });
//        }else{
//            NSLog(@"====%@",aError);
//        }
//    }];
    
    //    if (![Utilities isExpired]) {
    //        NSString *alias = [NSString stringWithFormat:@"%zd",kUserInfo.uid];
    //        [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
    //            NSLog(@"极光别名设置成功");
    //        } seq:0];
    //    }
}

#pragma mark - 处理未读信息
-(void)messagesDidReceive:(NSArray *)aMessages
{
//    NSLog(@"新消息来了");
//    [self handleUnreadMeg];
//
//    for (EMMessage*message in aMessages) {
//        dispatch_sync_on_main_queue(^{
//            UIApplicationState state =[[UIApplication sharedApplication] applicationState];
//            switch (state) {
//                    //前台运行
//                case UIApplicationStateActive:
//                    [self showPushNotificationMessage:message];
//                    break;
//                    //待激活状态
//                case UIApplicationStateInactive:
//                    break;
//                    //后台状态
//                case UIApplicationStateBackground:
//                    [self showPushNotificationMessage:message];
//                    break;
//                default:
//                    break;
//            }
//
//        });
//    }
    
}
-(void)messagesDidRead:(NSArray *)aMessages
{
    NSLog(@"消息已读");
    //    [self handleUnreadMeg];
}






-(IndexViewController *)nmainVC
{
    if (_nmainVC == nil) {
        _nmainVC = [[IndexViewController alloc] init];
        [self setUpOneChildViewController:_nmainVC image:self.imagesArray[0] selectImage:self.selctedImagesArray[0]];
        _nmainVC.title = LocalizedString(@"main");
    }
    return _nmainVC;
    
}

-(UIViewController *)newsVC
{
    if (_newsVC == nil) {
        _newsVC = [[TPBaseOTCViewController alloc] init];
        [self setUpOneChildViewController:_newsVC image:self.imagesArray[3] selectImage:self.selctedImagesArray[3]];
        _newsVC.title = @"OTC";
    }
    return _newsVC;
}

-(MeViewController *)mineVC
{
    if (_mineVC == nil) {
        _mineVC = [MeViewController new];
        [self setUpOneChildViewController:_mineVC image:self.imagesArray.lastObject  selectImage:self.selctedImagesArray.lastObject];
        _mineVC.title = LocalizedString(@"account");
    }
    return _mineVC;
}

- (UIViewController *)otcVC {
    if (!_otcVC) {
        _otcVC = [UIViewController new];
        [self setUpOneChildViewController:_otcVC image:self.imagesArray[3] selectImage:self.selctedImagesArray[3]];
        _otcVC.title = @"OTC";
    }
    
    return _otcVC;
}




-(UIViewController *)nnewVC
{
    if (_nnewVC == nil) {
//        _nnewVC = [[QuotationViewController alloc] init];
        _nnewVC = [[HBQuotationViewController alloc] init];
        [self setUpOneChildViewController:_nnewVC image:self.imagesArray[1] selectImage:self.selctedImagesArray[1]];
        _nnewVC.title = LocalizedString(@"hangqing");
    }
    return _nnewVC;
}




- (UIViewController *)shopVC {
    if (!_shopVC) {
        _shopVC = [HBShopViewController new];
        
//        _shopVC = [HBShopComingSoonViewController fromStoryboard];
        [self setUpOneChildViewController:_shopVC image:self.imagesArray[4] selectImage:self.selctedImagesArray[4]];
        _shopVC.title = kLocat(@"HBShopViewController_Title");
    }
    
    return _shopVC;
}



- (UIViewController *)tradeVC {
    if (!_tradeVC) {
        _tradeVC = [UIStoryboard storyboardWithName:@"Trade" bundle:nil].instantiateInitialViewController;
        [self setUpOneChildViewController:_tradeVC image:self.imagesArray[2] selectImage:self.selctedImagesArray[2]];
        _tradeVC.title = LocalizedString(@"k_TradeViewController_title");
    }
    return _tradeVC;
}

//-(UIViewController *)newsVC
//{
//    if (_newsVC == nil) {
//        _newsVC = [ new];
//        [self setUpOneChildViewController:_newsVC image:self.imagesArray[3] selectImage:self.selctedImagesArray[3]];
//        _newsVC.title = LocalizedString(@"news");
//    }
//    return _newsVC;
//}

- (UIViewController *)homeVC {
    if (!_homeVC) {
        _homeVC = [UIStoryboard storyboardWithName:@"Home" bundle:nil].instantiateInitialViewController;
        [self setUpOneChildViewController:_homeVC image:self.imagesArray[0] selectImage:self.selctedImagesArray[0]];
        _homeVC.title = LocalizedString(@"main");
    }
    
    return _homeVC;
}

- (UIViewController *)accountVC {
    if (!_accountVC) {
        _accountVC = [UIStoryboard storyboardWithName:@"Account" bundle:nil].instantiateInitialViewController;
        [self setUpOneChildViewController:_accountVC image:self.imagesArray[4] selectImage:self.selctedImagesArray[4]];
        _accountVC.title = LocalizedString(@"account");
    }
    
    return _accountVC;
}


-(NSArray *)imagesArray
{
    if (_imagesArray == nil) {
        _imagesArray = @[@"tab_icon11",@"tab_icon22",@"tab_icon33",@"tab_icon66",@"tab_icon77"];

    }
    return _imagesArray;
}
-(NSArray *)selctedImagesArray
{
    if (_selctedImagesArray == nil) {
//        _selctedImagesArray = @[@"home_kuai",@"faxian_kuai",@"zxun_kuai",@"user_kuai"];
        _selctedImagesArray = @[@"tab_icon1",@"tab_icon2",@"tab_icon3",@"tab_icon6",@"tab_icon7"];

    }
    return _selctedImagesArray;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (self.selectedIndex != index) {
        [self playSound];//点击时音效
        [self animationWithIndex:index];
    }
}
-(void) playSound{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"like" ofType:@"caf"];
    SystemSoundID soundID;
    NSURL *soundURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,&soundID);
    AudioServicesPlaySystemSound(soundID);
}
// 动画
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.08;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.2];
    [[tabbarbuttonArray[index] layer]
     addAnimation:pulse forKey:nil];
    self.selectedIndex = index;
}

-(void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLoginOut) name:kLoginOutKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kLoginSuccessKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kTokenExpiredKey object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
