
//
//  YJDealViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/3/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJDealViewController.h"

@interface YJDealViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView * webView;
@property(nonatomic,assign)BOOL firstLoad;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,strong)NSString *currencyID;
@property(nonatomic,assign)BOOL isSell;

@end

@implementation YJDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enablePanGesture = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kLoginSuccessKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidlogout) name:kLoginOutKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveCurrencyInfo:) name:@"kCurrenyId" object:nil];
    
    kShowHud;
    //    [self setupWebView];
    [self didReceiveCurrencyInfo:nil];
}
-(void)didReceiveCurrencyInfo:(NSNotification *)noti
{
    if (noti) {
        [_webView removeFromSuperview];
        _count = 0;
        NSString *obj = noti.object;
        NSArray *arr = [obj componentsSeparatedByString:@","];
        _currencyID = arr.lastObject;
        if ([arr.firstObject isEqualToString:@"gosell"]) {//卖出
            _isSell = YES;
        }else{//卖出
            _isSell = NO;
        }
    }
    
    [self setupWebView];
}

-(void)setupWebView
{
    _firstLoad = YES;

    _webView = [[WKWebView alloc] initWithFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight - kTabbarItemHeight) configuration:[self webViewConfigurate]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
        
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    //    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Mobile/entrust/tradall_buy.html",kBasePath]];
    NSURL *url;
    NSString *info =  [kUserDefaults objectForKey:@"kCurrenryInfoKey"];
    if (info) {
        NSArray *arr = [info componentsSeparatedByString:@","];
        _currencyID = arr.lastObject;
        if ([arr.firstObject isEqualToString:@"gosell"]) {//卖出
            _isSell = YES;
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Mobile/entrust/tradall_sell/currency/%@.html",kBasePath,_currencyID]];
        }else{//买入
            _isSell = NO;
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Mobile/entrust/tradall_buy/currency/%@.html",kBasePath,_currencyID]];
        }
    }else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Mobile/entrust/tradall_buy.html",kBasePath]];
        
    }
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 3. 发送请求给服务器
//    [_webView loadRequest:request];
    [self.webView loadHTMLString:@"" baseURL:kBasePath.ks_URL];

    [self.view addSubview:_webView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
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
        cookieValue =  [NSString stringWithFormat:@"document.cookie = 'odrtoken=%@';document.cookie = 'platform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';",@"1",[Utilities randomUUID],lang];
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
    }else if ([actionSting isEqual:ThAI]){//简体
        [LocalizableLanguageManager setUserlanguage:ThAI];
    }else if ([actionSting isEqual:@"zh-tw"]){//繁体
        [LocalizableLanguageManager setUserlanguage:CHINESEradition];
    }else if ([actionSting isEqual:@"en-us"]){//英文
        [LocalizableLanguageManager setUserlanguage:ENGLISH];
    }else if ([actionSting isEqual:@"loginOut"]){//登出
    }else if ([actionSting isEqual:@"login"]){//登录
        [self gotoLoginVC];
    }else if ([actionSting isEqual:@"register"]){//登录
        [self gotoRegisterVC];
    }else if ([actionSting containsString:@"gobuy"] || [actionSting containsString:@"gosell"]){
        if ([_webView canGoBack]) {
            [_webView goBack];
        }
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
            JSFuncString = [NSString stringWithFormat:@"document.cookie = 'odrtoken=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';",kUserInfo.token,[Utilities randomUUID],lang];
        }
        //拼凑js字符串，按照自己的需求拼凑Cookie
        NSMutableString *JSCookieString = JSFuncString.mutableCopy;
        for (NSHTTPCookie *cookie in cookieStorage.cookies) {
            NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 3);", cookie.name, cookie.value]; [JSCookieString appendString:excuteJSString];
            
        }
        //执行js
        [webView evaluateJavaScript:JSCookieString completionHandler:^(id obj, NSError * _Nullable error) {
            
            
            NSURL *url;
            NSString *info =  [kUserDefaults objectForKey:@"kCurrenryInfoKey"];
            if (info) {
                NSArray *arr = [info componentsSeparatedByString:@","];
                _currencyID = arr.lastObject;
                if ([arr.firstObject isEqualToString:@"gosell"]) {//卖出
                    _isSell = YES;
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Mobile/entrust/tradall_sell/currency/%@.html",kBasePath,_currencyID]];
                }else{//买入
                    _isSell = NO;
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Mobile/entrust/tradall_buy/currency/%@.html",kBasePath,_currencyID]];
                }
            }else{
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Mobile/entrust/tradall_buy.html",kBasePath]];
            }
            
            // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            // 3. 发送请求给服务器
            [_webView loadRequest:request];
        }];
    }
}

-(void)userDidLogin
{
    [_webView removeFromSuperview];
    _count = 0;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}





@end
