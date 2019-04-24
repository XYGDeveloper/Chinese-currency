//
//  HBConfirmOrderPasswordView.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/11.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HBConfirmOrderPasswordViewDidSureBlock)(NSString *password);
typedef void(^HBConfirmOrderPasswordViewCancelBlock)(void);

@interface HBConfirmOrderPasswordView : UIView

@property (nonatomic, copy) HBConfirmOrderPasswordViewDidSureBlock  didSureBlock;
@property (nonatomic, copy) HBConfirmOrderPasswordViewCancelBlock  cancelBlock;
@property (nonatomic, copy) NSString *orderNO;

- (void)showInWindow;

- (void)hide;

@end

