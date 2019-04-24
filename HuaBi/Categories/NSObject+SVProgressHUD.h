//
//  NSObject+SVProgressHUD.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/5.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SVProgressHUD)

- (void)startNetworkActivityIndicator;

- (void)stopNetworkActivityIndicator;

- (void)showErrorWithMessage:(NSString *)message;

- (void)showSuccessWithMessage:(NSString *)message;

- (void)showInfoWithMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
