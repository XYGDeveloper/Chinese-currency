//
//  HBOrderManagementWebViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/11.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBOrderManagementWebViewController.h"

@interface HBOrderManagementWebViewController ()

@end

@implementation HBOrderManagementWebViewController

- (instancetype)initOrderManagmentVC {
    NSString *uri = [NSString stringWithFormat:@"%@/Mobile/MallOrders/index", kBasePath];
    return (HBOrderManagementWebViewController *)[[HBOrderManagementWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:uri];

}


@end
