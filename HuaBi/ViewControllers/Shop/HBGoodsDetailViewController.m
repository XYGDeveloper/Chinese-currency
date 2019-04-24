//
//  HBGoodsDetailViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/9.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBGoodsDetailViewController.h"
#import "HBConfirmOrderViewController.h"
#import "HBCustomerServiceViewController.h"

@interface HBGoodsDetailViewController ()

@end

@implementation HBGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.webView reload];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
}

- (instancetype)initWithGoodsId:(NSString *)ID {
    NSString *goodsURL = [NSString stringWithFormat:@"%@/Mobile/mall/details?id=%@", kBasePath, ID];
    return (HBGoodsDetailViewController *)[[HBGoodsDetailViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:goodsURL];
}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.body hasPrefix:@"immediatelyBuy"]) {
        if ([Utilities isExpired]) {
            [self gotoLoginVC];
            return;
        }
        
        NSArray<NSString *> *array = [message.body componentsSeparatedByString:@"&"];
        if (array.count == 3) {
            NSString *cartIDs = array[2];
            NSString *specs = array[1] ?: @"";
            HBConfirmOrderViewController *vc = [HBConfirmOrderViewController fromStoryboard];
            vc.cartIDs = cartIDs;
            vc.spec_array = specs;
            kNavPush(vc);
        }
    }
    else if ([message.body hasPrefix:@"goToCustomerService"]) {
        UIViewController *vc = [HBCustomerServiceViewController new];
        kNavPush(vc);
    }
    else {
       [super userContentController:userContentController didReceiveScriptMessage:message];
    }
    
}

@end
