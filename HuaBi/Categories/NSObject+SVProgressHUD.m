//
//  NSObject+SVProgressHUD.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/5.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "NSObject+SVProgressHUD.h"



@implementation NSObject (SVProgressHUD)

- (void)startNetworkActivityIndicator {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)stopNetworkActivityIndicator {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)showErrorWithMessage:(NSString *)message {
    [self showMessage:message type:1 delay:1.5];
}

- (void)showSuccessWithMessage:(NSString *)message {
    [self showMessage:message type:0 delay:2.];
}

- (void)showInfoWithMessage:(NSString *)message {
    [self showMessage:message type:2 delay:1.5];
}

- (void)showMessage:(NSString *)message
               type:(NSInteger)type
              delay:(NSTimeInterval)delay {
    
    if (!message) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (type) {
            case 0:
                [SVProgressHUD showSuccessWithStatus:message];
                break;
                
            case 1:
                [SVProgressHUD showErrorWithStatus:message];
                break;
                
            case 2:
                [SVProgressHUD showInfoWithStatus:message];
                break;
            default:
                break;
        }
        
        [SVProgressHUD dismissWithDelay:delay];
    });
    
}


@end
