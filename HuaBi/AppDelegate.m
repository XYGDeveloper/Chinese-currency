//
//  AppDelegate.m
//  YJOTC
//
//  Created by 周勇 on 2017/12/22.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//  com.qhszzc.YJOTC

#import "AppDelegate.h"
#import "YJTabBarController.h"
#import "AppDelegate+ZY.h"
#import "LocalizableLanguageManager.h"
#import "CoreStatus.h"
#import <Bugly/Bugly.h>
#import "XGPush.h"
#import "NSUserDefaults+HB.h"

@interface AppDelegate ()<CoreStatusProtocol,UIAlertViewDelegate, XGPushDelegate, XGPushTokenManagerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%@", @([NSDate timeIntervalSinceReferenceDate]));
    [Bugly startWithAppId:@"844f9426d2"];
 
    /*
    en-CN,
    zh-Hans-CN,
    zh-Hant-CN
    */
//    NSArray *languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
//    NSString *currentLanguage = languages.firstObject;
//    NSLog(@"模拟器当前语言：%@",currentLanguage);

//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
//    }

    [LocalizableLanguageManager initUserLanguage];
    [LocalizableLanguageManager setUserlanguage:CHINESEradition];

    [CoreStatus beginNotiNetwork:self];
    NSString *language =  [kUserDefaults objectForKey:@"kUser_Language_Key"];
    if (language == nil) {
        [LocalizableLanguageManager setUserlanguage:CHINESEradition];
    }else if ([language isEqualToString:ENGLISH]){
        [LocalizableLanguageManager setUserlanguage:ENGLISH];
    }else if ([language isEqualToString:ThAI]){
        [LocalizableLanguageManager setUserlanguage:ThAI];
    }else if ([language isEqualToString:@"ko"]){
        [LocalizableLanguageManager setUserlanguage:@"ko"];
    }else if ([language isEqualToString:Japanese]){
        [LocalizableLanguageManager setUserlanguage:Japanese];
    }
    else{
        [LocalizableLanguageManager setUserlanguage:CHINESEradition];
    }
    
    [NSUserDefaults cleanExpiredData];

    [self initIQKeyboard];
    
    [self _setupStyle];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    
    YJTabBarController *tabVC = [[YJTabBarController alloc] init];
    
    self.window.rootViewController = tabVC;
    
    [self.window makeKeyAndVisible];
  #if kUseScreenShotGesture
    self.screenshotView = [[ScreenShotView alloc] initWithFrame:CGRectMake(-self.window.frame.size.width, 0, self.window.frame.size.width, self.window.frame.size.height)];
    [self.window insertSubview:_screenshotView atIndex:0];
    self.screenshotView.hidden = YES;
  #endif
//    [self _setupXGPush];
    NSLog(@"%@", @([NSDate timeIntervalSinceReferenceDate]));
    return YES;
    
}

- (void)_setupXGPush {
    [[XGPush defaultManager] startXGWithAppID:2200323912 appKey:@"I3UKR3438ESZ" delegate:self];
    [[XGPush defaultManager] setEnableDebug:YES];
    [XGPushTokenManager defaultTokenManager].delegate = self;
//    [[XGPush defaultManager] setBadge:0];
}

- (void)_setupStyle {
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-500., 0) forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"back_white"];
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back_white"];
}

-(void)coreNetworkChangeNoti:(NSNotification *)noti{
    NSString * statusString = [CoreStatus currentNetWorkStatusString];
//    [[UIApplication sharedApplication].keyWindow makeToast:[NSString stringWithFormat:@"当前网络连接为%@",statusString]];
    if ([noti.userInfo[@"currentStatusEnum"] intValue] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kLocat(@"net_alert_load_title") message:kLocat(@"net_alert_load_message") delegate:self cancelButtonTitle:kLocat(@"net_alert_load_message_cancel") otherButtonTitles:kLocat(@"net_alert_load_message_sure"), nil];
        NSLog(@"%@\n\n\n\n=========================\n\n\n\n%@ %@",noti,statusString,noti.userInfo[@"currentStatusEnum"]);
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (buttonIndex == 0) {
        
    }else{
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
           [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

#pragma mark - PUSH
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required - 注册 DeviceToken
    [application registerForRemoteNotifications];
    
    //    [JPUSHService registerDeviceToken:deviceToken];
    [kUserDefaults setObject:deviceToken forKey:kDeviceTokenKey];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    //    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    //ios 8 ,9
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        //打开app的时候
        kLOG(@"UIApplicationStateActive====");
    }else{
        //后台
        kLOG(@"UIAppl====");
        //        [self remoteNotificationActionWithDic:userInfo];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
   
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {

    
}


-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    if (self.isForceLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }else if (self.isForcePortrait){
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskPortrait;
    
}

#pragma mark - XGPushTokenManagerDelegate

- (void)xgPushDidBindWithIdentifier:(nonnull NSString *)identifier type:(XGPushTokenBindType)type error:(nullable NSError *)error {
    
}


@end
