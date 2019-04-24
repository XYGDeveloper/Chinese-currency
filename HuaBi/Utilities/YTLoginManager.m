//
//  YTLoginAndOutManager.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/30.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTLoginManager.h"

@implementation YTLoginManager

+ (void)logout {
    [kUserInfo clearUserInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginOutKey object:nil];
}

+ (void)checkIsLogOutByCode:(NSInteger)code {
    
    if (code != kUserNotLoginCode) {
        return;
    }
    
    if ([Utilities isExpired]) {
        return;
    }
    
    [self logout];
    
    if (![[kKeyWindow visibleViewController] isKindOfClass:[HBLoginTableViewController class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            YJBaseViewController *vc = (YJBaseViewController *)[kKeyWindow visibleViewController];
            UIViewController *vc1 = [HBLoginTableViewController fromStoryboard];
            [vc presentViewController:vc1 animated:YES completion:nil];
        });
    }
}

@end
