//
//  YTMainViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTMainViewController.h"

@interface YTMainViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property(nonatomic,copy)NSString *updateString;
@property(nonatomic,copy)NSString *updateUrl;

@end

@implementation YTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self checkVersion];

}


-(void)checkVersion
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"platform"] = @"ios";
    param[@"uuid"] = [Utilities randomUUID];
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/District/version"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        if (success) {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            //            CFShow((__bridge CFTypeRef)(infoDictionary));
            // app名称
            //            NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
            // app版本
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            // app build版本
            //            NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
            
            
            NSDictionary *dic = [responseObj ksObjectForKey:kResult];
            
            
            NSArray *tipsArr = dic[@"mobile_apk_explain"];
            
            NSMutableString *tipsStr = [NSMutableString new];
            for (NSDictionary *dic in tipsArr) {
                [tipsStr appendString:[NSString stringWithFormat:@"%@\n",dic[@"text"]]];
                
            }
            
            _updateString = tipsStr.mutableCopy;
            
            NSInteger isForceUpdata = [dic[@"versionForce"]integerValue] ;
            
            if (![dic[@"versionName"] isEqualToString:app_Version]) {
                
                _updateUrl = dic[@"downloadUrl"];
                
                if (isForceUpdata) {
                    [self showUpdateView:YES];
                    
                }else{
                    [self showUpdateView:NO];
                }
            }
        }
    }];
}

-(void)showUpdateView:(BOOL)isForce
{
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.5];
    [kKeyWindow addSubview:bgView];
    
    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(0, 0, 250, 180)];
    [bgView addSubview:midView];
    [midView alignVertical];
    [midView alignHorizontal];
    midView.backgroundColor = kWhiteColor;
    kViewBorderRadius(midView, 6, 0, kRedColor);
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(30, 0, 250-60, 120)];
    [midView addSubview:tipsLabel];
    tipsLabel.numberOfLines = 0;
    tipsLabel.textColor = k323232Color;
    tipsLabel.font = PFRegularFont(14);
    
    if (_updateString.length > 2) {
        tipsLabel.text = _updateString;
    }else{
        tipsLabel.text = kLocat(@"k_NewVersion");
        tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(0, tipsLabel.bottom, midView.width, midView.height - tipsLabel.height) title:kLocat(@"Confirm") titleColor:kBlueColor font:PFRegularFont(16) titleAlignment:0];
    
    [midView addSubview:button];
    
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton*  _Nonnull sender) {
        
        [self gotoSafariUpdataWith:_updateUrl];
        
        if (isForce == NO) {
            [sender.superview.superview removeFromSuperview];
        }
        
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, button.top, midView.width, 0.5)];
    lineView.backgroundColor = kColorFromStr(@"e6e6e6");
    
    [midView addSubview:lineView];
}

-(void)gotoSafariUpdataWith:(NSString *)urlStr
{
    //    NSString * urlStr = url;
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{}
                                         completionHandler:^(BOOL success) {
                                             NSLog(@"Open %d",success);
                                         }];
            } else {
                // Fallback on earlier versions
            }
        } else {
            BOOL success = [[UIApplication sharedApplication] openURL:url];
            NSLog(@"Open  %d",success);
        }
        
    } else{
        bool can = [[UIApplication sharedApplication] canOpenURL:url];
        if(can){
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [super userContentController:userContentController didReceiveScriptMessage:message];
    NSString *actionSting = message.body;
    kLOG(@"webview返回的字段===%@===",actionSting);
    if ([actionSting isEqual:@"toHangQing"]){
        self.tabBarController.selectedIndex = 1;
    }
    
}
-(void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
