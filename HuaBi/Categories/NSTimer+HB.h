//
//  NSTimer+HB.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/21.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (HB)

+ (instancetype)_createRandomTimerWithTarget:(id)target selector:(SEL)sel;

@end

NS_ASSUME_NONNULL_END
