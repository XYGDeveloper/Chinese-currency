
//
//  YJCommonWebController.m
//  YJOTC
//
//  Created by 周勇 on 2018/1/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJCommonWebController.h"

@interface YJCommonWebController ()

@end

@implementation YJCommonWebController

- (void)viewDidLoad {
    [super viewDidLoad];


    UIWebView *webView = [[UIWebView alloc] initWithFrame:kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight)];
    
    NSURL *url = [NSURL URLWithString:_urlStr];
    
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.view addSubview:webView];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

@end
