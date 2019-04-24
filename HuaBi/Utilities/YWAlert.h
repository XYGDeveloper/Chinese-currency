//
//  YWAlert.h
//  ywshop
//
//  Created by 前海数交（ZJ） on 2018/9/7.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWAlert : NSObject

+ (void)alertSorryWithDevelopingMessageInViewController:(UIViewController *)viewController;

//+ (void)alertInfoWithMessage:(NSString *)message
//            inViewController:(UIViewController *)viewController;

+ (void)alertSorryWithMessage:(NSString *)message
             inViewController:(UIViewController *)viewController;

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
      inViewController:(UIViewController *)viewController;

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
            sureAction:(void(^)(void))sureBlock
      inViewController:(UIViewController *)viewController;

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
            sureAction:(void(^)(void))sureBlock
          cancelAction:(void(^)(void))cancelBlock
      inViewController:(UIViewController *)viewController;

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
             sureTitle:(NSString *)sureTitle
           cancelTitle:(NSString *)cancelTitle
            sureAction:(void(^)(void))sureBlock
          cancelAction:(void(^)(void))cancelBlock
      inViewController:(UIViewController *)viewController;

@end
