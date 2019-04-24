
//
//  YJMineViewController.m
//  YJOTC
//
//  Created by 周勇 on 2017/12/22.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YJMineViewController.h"
#import "KSScanningViewController.h"
#import "YTLoginManager.h"

@interface YJMineViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView * webView;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,assign)BOOL firstLoad;

@end

@implementation YJMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kLoginSuccessKey object:nil];


    [self setupWebView];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;

}

-(void)setupWebView
{
    _webView = [[WKWebView alloc] initWithFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight - kTabbarItemHeight) configuration:[self webViewConfigurate]];
    if (@available(iOS 11.0, *)) {
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _firstLoad = YES;
    
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    [self.webView loadHTMLString:@"" baseURL:kBasePath.ks_URL];
    
    
    [self.view addSubview:_webView];
    
    kShowHud;
}

-(WKWebViewConfiguration *)webViewConfigurate
{
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    // 支持内嵌视频播放，不然网页中的视频无法播放
    webConfig.allowsInlineMediaPlayback = YES;
    NSString *cookieValue;
    
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
    if ([Utilities isExpired]) {
        cookieValue =  [NSString stringWithFormat:@"document.cookie = 'odrtoken=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';",@"1",[Utilities randomUUID],lang];
    }else{
        cookieValue =  [NSString stringWithFormat:@"document.cookie = 'odrtoken=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';",kUserInfo.token,kUserInfo.user_uuid,lang];
    }
    // 加cookie给h5识别，表明在ios端打开该地址
    WKUserContentController* userContentController = [[WKUserContentController alloc] init];;
    [userContentController addScriptMessageHandler:self name:@"iosAction"];
    WKUserScript * cookieScript = [[WKUserScript alloc]
                                   initWithSource: cookieValue
                                   injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    webConfig.userContentController = userContentController;
    return webConfig;
}
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSString *actionSting = message.body;
    kLOG(@"webview返回的字段===%@===",actionSting);
    if ([actionSting isEqual:@"iosLoginAction"]) {
        dispatch_async_on_main_queue(^{
            [self gotoLoginVC];
        });
    }else if ([actionSting isEqual:@"goback"]){

        [self backAction];
    }else if ([actionSting isEqual:@"loginOut"]){//登出
        [self userDidlogout];
        
    }else if ([actionSting isEqual:@"login"]){//登录
        [self gotoLoginVC];
    }else if ([actionSting isEqual:@"register"]){//注册
        [self gotoRegisterVC];
    }else if ([actionSting isEqual:@"code"]){//扫一扫
        [self scanAction];
    }
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)backAction
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (_firstLoad == NO) {
        kHideHud;
    }
    
    if (_firstLoad) {
        _firstLoad = NO;
        
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        
        
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
        NSString *JSFuncString;
        if ([Utilities isExpired]) {
            JSFuncString = [NSString stringWithFormat:@"document.cookie = 'odrtoken=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';",@"1",[Utilities randomUUID],lang];
        }else{
            JSFuncString = [NSString stringWithFormat:@"document.cookie = 'odrtoken=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';",kUserInfo.token,kUserInfo.user_uuid,lang];
        }
        //拼凑js字符串，按照自己的需求拼凑Cookie
        NSMutableString *JSCookieString = JSFuncString.mutableCopy;
        for (NSHTTPCookie *cookie in cookieStorage.cookies) {
            NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 3);", cookie.name, cookie.value]; [JSCookieString appendString:excuteJSString];
            
        }
        //执行js
        [webView evaluateJavaScript:JSCookieString completionHandler:^(id obj, NSError * _Nullable error) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Mobile/AccountManage/account",kBasePath]];

            // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            // 3. 发送请求给服务器
            [_webView loadRequest:request];
        }];
    }
}



-(void)scanAction
{
    if ([Utilities isExpired]) {
        [self gotoLoginVC];
    }else{
        __weak typeof(self)weakSelf = self;
        KSScanningViewController *vc = [[KSScanningViewController alloc] init];
        vc.callBackBlock = ^(NSString *scannedStr) {
            kLOG(@"%@",[NSString stringWithFormat:@"showName('%@')",scannedStr]);
            [weakSelf.webView evaluateJavaScript:[NSString stringWithFormat:@"showName('%@')",scannedStr] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            }];
            
        };
        kNavPush(vc);
    }
}
-(void)userDidLogin
{
    [_webView removeFromSuperview];
    [self setupWebView];
}


-(void)userDidlogout
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:kLocat(@"k_ConfirmLoginout") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *desAction = [UIAlertAction actionWithTitle:kLocat(@"Confirm") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [YTLoginManager logout];
//        [kUserInfo clearUserInfo];
        [self userDidLogin];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginOutKey object:nil];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:desAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
