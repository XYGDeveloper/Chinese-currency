
//
//  YJMainViewController.m
//  YJOTC
//
//  Created by 周勇 on 2017/12/22.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YJMainViewController.h"


@interface YJMainViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView * webView;

@property(nonatomic,assign)BOOL firstLoad;
@property(nonatomic,assign)NSInteger count;
@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation YJMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        statusBar.backgroundColor = [UIColor colorWithRed:0.13 green:0.14 blue:0.21 alpha:1.00];
//    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kLoginSuccessKey object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidlogout) name:kLoginOutKey object:nil];

    [self setupWebView];

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
    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Mobile/Entrust/index.html",kBasePath]];

    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 3. 发送请求给服务器
//    [_webView loadRequest:request];
    
    [self.webView loadHTMLString:@"" baseURL:kBasePath.ks_URL];

//        NSURLRequest *request = [NSURLRequest requestWithURL:@"http://test.yzcet.com/Mobile/Entrust/index.html".ks_URL];

    
//    [_webView loadRequest:request];
    
    
    
    
    [self.view addSubview:_webView];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];

    kShowHud;
    [self initProgressView];

}
-(void)initProgressView
{
    if (self.progressView) {
        [self.progressView removeFromSuperview];
    }
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, _webView.y, CGRectGetWidth(self.view.frame), 2)];
    self.progressView.progressTintColor = [UIColor colorWithRed:0.19 green:0.70 blue:0.91 alpha:1.00];
    [self.view addSubview:self.progressView];
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.backgroundColor = [UIColor clearColor];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
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
        if ([_webView canGoBack]) {
            [_webView goBack];
        }else{
            [self backAction];
        }
    }else if ([actionSting isEqual:@"zh-cn"]){//简体
        [LocalizableLanguageManager setUserlanguage:CHINESESimlple];
    }else if ([actionSting isEqual:@"zh-tw"]){//繁体
        [LocalizableLanguageManager setUserlanguage:CHINESEradition];
    }else if ([actionSting isEqual:@"en-us"]){//英文
        [LocalizableLanguageManager setUserlanguage:ENGLISH];
    }else if ([actionSting isEqual:@"loginOut"]){//登出
    }else if ([actionSting isEqual:@"login"]){//登录
        [self gotoLoginVC];
    }else if ([actionSting isEqual:@"register"]){//登录
        [self gotoRegisterVC];
    }else if ([actionSting hasPrefix:@"gobuy"]){//买入
        self.tabBarController.selectedIndex = 2;
        [kUserDefaults setObject:actionSting forKey:@"kCurrenryInfoKey"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kCurrenyId" object:actionSting];
        [self backAction];
    }else if ([actionSting hasPrefix:@"gosell"]){//卖出
        self.tabBarController.selectedIndex = 2;
        [kUserDefaults setObject:actionSting forKey:@"kCurrenryInfoKey"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kCurrenyId" object:actionSting];
        [self backAction];
    }

}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
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
            JSFuncString = [NSString stringWithFormat:@"document.cookie = 'odrtoken=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';",kUserInfo.token,[Utilities randomUUID],lang];
        }
        
        
        
        
        
        //拼凑js字符串，按照自己的需求拼凑Cookie
        NSMutableString *JSCookieString = JSFuncString.mutableCopy;
        for (NSHTTPCookie *cookie in cookieStorage.cookies) {
            NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 3);", cookie.name, cookie.value]; [JSCookieString appendString:excuteJSString];
            
        }
        //执行js
        [webView evaluateJavaScript:JSCookieString completionHandler:^(id obj, NSError * _Nullable error) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Mobile/Entrust/index",kBasePath]];

            // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            // 3. 发送请求给服务器
            [_webView loadRequest:request];
        }];
    }
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    kLOG(@"加载失败");
    
}
-(void)userDidLogin
{
    [_webView removeFromSuperview];
    [self setupWebView];
    
}

-(void)userDidlogout
{
    [self userDidLogin];
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

-(void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqual:@"estimatedProgress"] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        
        kLOG(@"%.2f",self.webView.estimatedProgress);
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress  >= 1.0f) {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:YES];
            }];
        }
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
