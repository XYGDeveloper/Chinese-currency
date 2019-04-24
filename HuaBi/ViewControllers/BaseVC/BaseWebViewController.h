//
//  BaseWebViewController.h
//  YJOTC
//
//  Created by 周勇 on 2017/12/29.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"
#import <WebKit/WebKit.h>


typedef enum
{
    BaseWebVCWebViewTypeFullScreen,//全屏
    BaseWebVCWebViewTypeNavi,//有导航栏
    BaseWebVCWebViewTypeTabbar,//显示tabbar

}BaseWebVCWebViewType;


@interface BaseWebViewController : YJBaseViewController

@property(nonatomic,strong)WKWebView * webView;

@property(nonatomic,assign)CGRect webViewFrame;

@property(nonatomic,copy)NSString *cookieValue;

@property(nonatomic,copy)NSString *urlStr;

@property(nonatomic,copy)NSString *titleString;

@property(nonatomic,copy)NSString *htmlString;

@property(nonatomic,assign)BOOL showNaviBar;


-(instancetype)initWithWebViewFrame:(CGRect)frame title:(NSString *)title;

-(instancetype)initWithWebViewType:(BaseWebVCWebViewType)type title:(NSString *)title urlString:(NSString*)urlString;
-(instancetype)initWithWebViewType:(BaseWebVCWebViewType)type title:(NSString *)title html:(NSString*)html;

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;


@end
