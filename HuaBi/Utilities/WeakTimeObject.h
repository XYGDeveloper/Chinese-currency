//
//  WeakTimeObject.h
//  timer
//
//  Created by 周勇 on 2018/9/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakTimeObject : NSObject

+ (NSTimer *)weakScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)sel userInfo:(id)userInfo repeats:(BOOL)isRepeats;

@end
