
//
//  YTMineViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTMineViewController.h"
#import "KSScanningViewController.h"


@interface YTMineViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@end

@implementation YTMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [super userContentController:userContentController didReceiveScriptMessage:message];
    NSString *actionSting = message.body;
    kLOG(@"webview返回的字段===%@===",actionSting);
    if ([actionSting isEqual:@"goback"]){
        if ([self.urlStr containsString:@"forgot_password.ht"]) {//修改密码后跳转到登录
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            if ([self.webView canGoBack]) {
                [self.webView goBack];
            }else{
                [self backAction];
            }
        }
    }else
        if ([actionSting isEqual:@"loginOut"]){//登出
        [self userDidlogout];
    }else if ([actionSting isEqual:@"login"]){//登录
        [self gotoLoginVC];
    }else if ([actionSting isEqual:@"register"]){//登录
        [self gotoRegisterVC];
    }else if ([actionSting isEqual:@"code"]){//扫一扫
        [self scanAction];
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)userDidlogout
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:kLocat(@"k_ConfirmLoginout") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *desAction = [UIAlertAction actionWithTitle:kLocat(@"Confirm") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [kUserInfo clearUserInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginOutKey object:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:desAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
