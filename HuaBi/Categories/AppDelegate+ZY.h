//
//  AppDelegate+ZY.h
//  jys
//
//  Created by 周勇 on 2017/4/17.
//  Copyright © 2017年 前海数交所. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (ZY)

-(void)initIQKeyboard;

- (void)networkDidLogin:(NSNotification *)notification;

//- (void)configShareSDK;

-(void)successPay;

-(void)failedPay;

-(void)cancelPay;

-(void)autoLoginAction;

-(void)EMLoginAction;

@end
