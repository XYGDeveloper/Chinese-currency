//
//  BaseWebViewController.m
//  YJOTC
//
//  Created by 周勇 on 2017/12/29.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "BaseWebViewController.h"
#import "KSScanningViewController.h"
#import "EmptyManager.h"
#import "HBShoppingCartViewController.h"

@interface BaseWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property(nonatomic,assign)NSInteger count;

@property(nonatomic,assign)BOOL firstLoad;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) MBProgressHUD *hub;

@end

@implementation BaseWebViewController

- (void)showHub{
    [BQActivityView showActiviTy];
}

- (void)hideHub{
    [BQActivityView hideActiviTy];
}

-(instancetype)initWithWebViewFrame:(CGRect)frame title:(NSString *)title
{
    BaseWebViewController *vc = [[self class] new];
    vc.webViewFrame = frame;
    vc.titleString = title;
    _webViewFrame = frame;
    _titleString = title;
    return vc;
}
-(instancetype)initWithWebViewType:(BaseWebVCWebViewType)type title:(NSString *)title urlString:(NSString*)urlString
{
    BaseWebViewController *vc = [[self class] new];
    vc.urlStr = urlString;
    vc.titleString = title;
    if (type == BaseWebVCWebViewTypeNavi) {
        vc.webViewFrame = kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight);
    }else if (type == BaseWebVCWebViewTypeTabbar){
        vc.webViewFrame = kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight - kTabbarItemHeight);
    }else{
        vc.webViewFrame = kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight);
    }
    
    return vc;
}

- (instancetype)initWithWebViewType:(BaseWebVCWebViewType)type title:(NSString *)title html:(NSString *)html{
    BaseWebViewController *vc = [[BaseWebViewController alloc]init];
    vc.titleString = title;
    vc.htmlString = html;
    [vc.webView loadHTMLString:html baseURL:nil];
    if (type == BaseWebVCWebViewTypeNavi) {
        vc.webViewFrame = kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight);
    }else if (type == BaseWebVCWebViewTypeTabbar){
        vc.webViewFrame = kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight - kTabbarItemHeight);
    }else{
        vc.webViewFrame = kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight);
    }
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enablePanGesture = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kLoginSuccessKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kLoginOutKey object:nil];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
    [self setupWebView];
    
}

-(void)setupWebView
{
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kStatusBarHeight)];
    statusView.backgroundColor = kRGBA(28, 29, 37, 1);
    [self.view addSubview:statusView];

    _webView = [[WKWebView alloc] initWithFrame:_webViewFrame configuration:[self webViewConfigurate]];

    if (@available(iOS 11.0, *)) {
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _firstLoad = YES;
    [self.webView loadHTMLString:@"" baseURL:kBasePath.ks_URL];
    [self.view addSubview:_webView];
    [self showHub];

   

    if (_titleString) {
        self.title = _titleString;
    }
    [self initProgressView];
    
    
}
-(void)initProgressView
{
    if (self.progressView) {
        [self.progressView removeFromSuperview];
    }
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, _webView.y, CGRectGetWidth(self.view.frame), 2)];
    self.progressView.progressTintColor = kPurpleColor;
    [self.view addSubview:self.progressView];
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.backgroundColor = [UIColor clearColor];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = !_showNaviBar;
    NSLog(@"\\\\\\\\\\-----%lu",self.navigationController.viewControllers.count);
//    [IQKeyboardManager sharedManager].enable = NO;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
     [self setStatusBarBackgroundColor:kThemeColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [IQKeyboardManager sharedManager].enable = YES;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
     [self setStatusBarBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.hidden = NO;
}

-(WKWebViewConfiguration *)webViewConfigurate
{
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    // 支持内嵌视频播放，不然网页中的视频无法播放
    webConfig.allowsInlineMediaPlayback = YES;
    NSString *cookieValue = [self _getCookieValue];
//    cookieValue= @"";
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

- (NSString *)_getCookieValue {
    NSString *lang = [LocalizableLanguageManager currentLanguage];
    NSString *cookieValue;
    if ([Utilities isExpired]) {
        cookieValue =  [NSString stringWithFormat:@"document.cookie = 'odrtoken=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';",@"1",kUserInfo.user_uuid,lang];
    }else{
        cookieValue =  [NSString stringWithFormat:@"document.cookie = 'odrtoken=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';",kUserInfo.token, kUserInfo.user_uuid,lang];
    }
    if (_cookieValue) {
        cookieValue = _cookieValue;
    }
    
    return cookieValue;
}

#pragma mark - WKNavigationDelegate


// 页面加载失败时调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    kHideHud;
    NSLog(@"%@",error);
    switch (error.code) {
        case 1009:
        case -1009:
        {
            self.navigationController.navigationBar.hidden = NO;
            [[EmptyManager sharedManager] showNetErrorOnView:self.view response:error.localizedDescription operationBlock:^{
                [self didClickRetryButton];
            }];
        }
            break;
        case -1001:
        case -1003:
        {
            self.navigationController.navigationBar.hidden = NO;
            [[EmptyManager sharedManager] showNetErrorOnView:self.view response:error.localizedDescription operationBlock:^{
                [self didClickRetryButton];
            }];
        }
            break;
         case -1007:
        {
            self.navigationController.navigationBar.hidden = NO;
            [[EmptyManager sharedManager] showNetErrorOnView:self.view response:error.localizedDescription operationBlock:^{
                [self didClickRetryButton];
            }];
        }
        case -2000:
            //        case -999:
        case -1011:
        case -1008:
        case -1201:
        case -1005:
        {
            self.navigationController.navigationBar.hidden = NO;
            [[EmptyManager sharedManager] showNetErrorOnView:self.view response:error.localizedDescription operationBlock:^{
                [self didClickRetryButton];
            }];
        }
            break;
        default:
            break;
    }
}
//-(void)setupBlankViewWithStatus:(NSInteger)type
//{
//    /**  0 链接失败   1没有网络  */
//    UIView *bgView = [[UIView alloc] initWithFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight - kTabbarItemHeight)];
//    [self.view addSubview:bgView];
//    bgView.backgroundColor = kWhiteColor;
//    NSString *img ;
//    NSString *tipsStr;
//
//    CGSize size = kSizeMake(kScreenW, 243 * kScreenHeightRatio);
//
//    if (type) {
//        img = @"mainnonet";
//        tipsStr = kLocat(@"R_NoNetWork");
//    }else{
//        img = @"mainconfail";
//        tipsStr = kLocat(@"R_ConnectFail");
//    }
//
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:kImageFromStr(img)];
//    [bgView addSubview:imgView];
//    imgView.image = kImageFromStr(img);
//    if (type == 0) {
//        imgView.size = size;
//    }
//
//    [imgView alignHorizontal];
//
//    UIButton *retryButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 109, 38) title:kLocat(@"k_Retry") titleColor:kWhiteColor font:PFRegularFont(17) titleAlignment:0];
//    [bgView addSubview:retryButton];
//    [retryButton alignHorizontal];
//    retryButton.bottom = bgView.height  - 256/2*kScreenHeightRatio;
//    [retryButton addTarget:self action:@selector(didClickRetryButton) forControlEvents:UIControlEventTouchUpInside];
//    kViewBorderRadius(retryButton, 3, 0, kRedColor);
//    retryButton.backgroundColor = kYellowColor;
//
//    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, kScreenW, 19) text:tipsStr font:PFRegularFont(17) textColor:k323232Color textAlignment:1 adjustsFont:1];
//    [bgView addSubview:tipsLabel];
//    tipsLabel.bottom = retryButton.top -154/2*kScreenHeightRatio;
//
//    imgView.bottom = tipsLabel.top - 5;
//
//    if (type == 1) {
//        imgView.bottom = tipsLabel.top - 25;
//    }
//
//    _webView.hidden = YES;
//}
-(void)didClickRetryButton
{
    [self.webView removeFromSuperview];
    [self setupWebView];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"===%@===",navigationAction.request.URL.absoluteString);
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 页面加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self hideHub];

    NSLog(@"%@===",webView.URL.absoluteString);
    if ([webView.URL.absoluteString containsString:@"User/qrcod"]) {
        [self.webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';"completionHandler:nil];
        [self.webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    }
    

    
    if (_firstLoad == NO) {
        [self hideHub];
    }
    
    if (_firstLoad) {
        _firstLoad = NO;
        
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        
        
//        NSString *lang = [LocalizableLanguageManager currentLanguage];
        
        NSString *JSFuncString =  [self _getCookieValue];
        
        
        //拼凑js字符串，按照自己的需求拼凑Cookie
        NSMutableString *JSCookieString = JSFuncString.mutableCopy;
        for (NSHTTPCookie *cookie in cookieStorage.cookies) {
            NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 4);", cookie.name, cookie.value]; [JSCookieString appendString:excuteJSString];
            
        }
//        JSFuncString = @"";
        
        //执行js
        [webView evaluateJavaScript:JSCookieString completionHandler:^(id obj, NSError * _Nullable error) {
            NSURL *url = [NSURL URLWithString:_urlStr];
            
            // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            // 3. 发送请求给服务器
            [_webView loadRequest:request];
        }];
    }
}







-(void)userDidLogin
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];

    [self.webView removeFromSuperview];
    [self setupWebView];
}

//去除空格,UTF8
- (NSString *)handleFormatString:(NSString *)str
{
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([str containsString:@" "]) {
        return [str stringByReplacingOccurrencesOfString:@" "withString:@""];
    }else{
        return str;
    }
}
#pragma mark - 交互处理
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSString *actionSting = message.body;
    NSLog(@"webview返回的字段===%@===",actionSting);
    if ([actionSting isEqual:@"iosLoginAction"]) {
        dispatch_async_on_main_queue(^{
            [self gotoLoginVC];
        });
    }else if ([actionSting isEqual:@"goback"]){
        if ([_urlStr containsString:@"forgot_password.ht"]) {//修改密码后跳转到登录
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            if ([_webView canGoBack]) {
                [_webView goBack];
            }else{
                [self backAction];
            }
        }
    }else if ([actionSting isEqual:ThAI]){//简体
        
        [kUserDefaults setObject:ThAI forKey:@"kUser_Language_Key"];
        [LocalizableLanguageManager setUserlanguage:ThAI];
        
    }else if ([actionSting isEqual:@"zh-tw"]){//繁体
        [kUserDefaults setObject:CHINESEradition forKey:@"kUser_Language_Key"];
        [LocalizableLanguageManager setUserlanguage:CHINESEradition];

    }else if ([actionSting isEqual:@"en-us"]){//英文
        [kUserDefaults setObject:ENGLISH forKey:@"kUser_Language_Key"];
        [LocalizableLanguageManager setUserlanguage:ENGLISH];

    }else if ([actionSting isEqual:@"loginOut"]){//登出
        
    }else if ([actionSting isEqual:@"login"]){//登录
            [self gotoLoginVC];
    }else if ([actionSting isEqual:@"register"]){//登录
        [self gotoRegisterVC];
    }else if ([actionSting isEqual:@"code"]){//扫一扫
        [self scanAction];
    }else if ([actionSting hasPrefix:@"gobuy"]){//买入
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidClickBuyOrSellButtonKey" object:actionSting];
        YJTabBarController *tabVC = (YJTabBarController *)self.tabBarController;
        tabVC.currentParam = actionSting;
        self.tabBarController.selectedIndex = 2;
    }else if ([actionSting hasPrefix:@"gosell"]){//卖出
        self.tabBarController.selectedIndex = 2;
        YJTabBarController *tabVC = (YJTabBarController *)self.tabBarController;
        tabVC.currentParam = actionSting;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidClickBuyOrSellButtonKey" object:actionSting];
    }else if([actionSting hasPrefix:@"download"]){
        NSArray *arr = [actionSting componentsSeparatedByString:@","];
        [self downloadImageWithUrlString:arr.lastObject];
    }else if([actionSting isEqualToString:@"exit"]){
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([actionSting isEqual:@"iosgocart"]){//购物车
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"HBShoppingCartViewController")]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
        
        [self.navigationController pushViewController:[HBShoppingCartViewController fromStroyboard] animated:YES];
        
    } else if ([actionSting isEqualToString:@"finish"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}



-(void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
-(void)scanAction
{
    if ([Utilities isExpired]) {
        [self gotoLoginVC];
    }else{
        __weak typeof(self)weakSelf = self;
        KSScanningViewController *vc = [[KSScanningViewController alloc] init];
        vc.callBackBlock = ^(NSString *scannedStr) {
            NSLog(@"%@",[NSString stringWithFormat:@"showName('%@')",scannedStr]);
            [weakSelf.webView evaluateJavaScript:[NSString stringWithFormat:@"showName('%@')",scannedStr] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            }];
        };
        kNavPush(vc);
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqual:@"estimatedProgress"] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress  >= 1.0f) {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self hideHub];
                });
            }];
        }
    }else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.title = self.webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark 下载图片
-(void)downloadImageWithUrlString:(NSString *)urlString
{
    /**  base64转图片  */
   
    NSData * imageData =[[NSData alloc] initWithBase64EncodedString:urlString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    UIImage *photo = [UIImage imageWithData:imageData ];
    
    [self saveImage:photo];
    
    return;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //        NSLog(@"File downloaded to: %@", filePath);
        NSData *data = [NSData dataWithContentsOfURL:filePath];
        UIImage * image = [UIImage imageWithData:data];
        
        [self saveImage:image];
        
    }];
    [downloadTask resume];
}
//image是要保存的图片
- (void) saveImage:(UIImage *)image{
    
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
    }
}
//保存完成后调用的方法
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存图片出错%@", error.localizedDescription);
        dispatch_sync_on_main_queue(^{
            [self showTips:kLocat(@"k_PicSaveFail")];
        });
    }
    else {
        dispatch_sync_on_main_queue(^{
            [self showTips:kLocat(@"k_PicSaved")];
        });
        NSLog(@"保存图片成功");
    }
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    // js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:kLocat(@"Confirm")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
    
}



@end
