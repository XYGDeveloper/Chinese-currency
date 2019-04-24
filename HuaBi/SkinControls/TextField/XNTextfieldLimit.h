//
//  XNTextfieldLimit.h
//  YJOTC
//
//  Created by XI YANGUI on 2018/8/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol XWMoneyTextFieldLimitDelegate;

@interface XNTextfieldLimit : NSObject
@property (nonatomic, assign) id <XWMoneyTextFieldLimitDelegate> delegate;
@property (nonatomic, strong) NSString *max; // 默认99999.99
- (void)valueChange:(id)sender;

@end

@protocol XWMoneyTextFieldLimitDelegate <NSObject>
@optional
- (void)valueChange:(id)sender;

@end
