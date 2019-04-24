//
//  YWAlert.m
//  ywshop
//
//  Created by 前海数交（ZJ） on 2018/9/7.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YWAlert.h"

@implementation YWAlert

+ (void)alertInfoWithMessage:(NSString *)message
            inViewController:(UIViewController *)viewController {
    
    [self alertWithTitle:@"提示"
                 message:message
        inViewController:viewController];
}

+ (void)alertSorryWithDevelopingMessageInViewController:(UIViewController *)viewController {
    [self alertSorryWithMessage:@"该功能正在开发中.." inViewController:viewController];
}

+ (void)alertSorryWithMessage:(NSString *)message
             inViewController:(UIViewController *)viewController {
    
    [self alertWithTitle:kLocat(@"Sorry")
                 message:message
        inViewController:viewController];
}

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
      inViewController:(UIViewController *)viewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:kLocat(@"k_meViewcontroler_loginout_sure") style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewController presentViewController:alert animated:YES completion:nil];
    });
}
+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
            sureAction:(void(^)(void))sureBlock
      inViewController:(UIViewController *)viewController
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:kLocat(@"k_meViewcontroler_loginout_sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sureBlock) {
            sureBlock();
        }
    }];
    [alert addAction:action];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewController presentViewController:alert animated:YES completion:nil];
    });
}

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
            sureAction:(void(^)(void))sureBlock
          cancelAction:(void(^)(void))cancelBlock
      inViewController:(UIViewController *)viewController {
    
    [self alertWithTitle:title
                 message:message
               sureTitle:nil
             cancelTitle:nil
              sureAction:sureBlock
            cancelAction:cancelBlock
        inViewController:viewController];
}

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
             sureTitle:(NSString *)sureTitle
           cancelTitle:(NSString *)cancelTitle
            sureAction:(void(^)(void))sureBlock
          cancelAction:(void(^)(void))cancelBlock
      inViewController:(UIViewController *)viewController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureTitle ?:kLocat(@"k_meViewcontroler_loginout_sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sureBlock) {
            sureBlock();
        }
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle ?:kLocat(@"k_meViewcontroler_loginout_cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelBlock) {
            cancelBlock();
        }
    }];
    
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewController presentViewController:alert animated:YES completion:nil];
    });
    
}

@end
