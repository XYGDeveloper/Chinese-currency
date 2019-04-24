//
//  WeakTimeObject.m
//  timer
//
//  Created by 周勇 on 2018/9/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "WeakTimeObject.h"

@interface WeakTimeObject ()

@property (nonatomic,weak) id target;
@property (nonatomic,assign)SEL selector;

@end

@implementation WeakTimeObject


+ (NSTimer *)weakScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)sel userInfo:(id)userInfo repeats:(BOOL)isRepeats {
    
    WeakTimeObject *objc=[[WeakTimeObject alloc]init];
    objc.target = target;
    objc.selector = sel;
    
    
    //Nstimer 对 WeakTimeObject 对象 强引用
    return [NSTimer scheduledTimerWithTimeInterval:timeInterval target:objc selector:@selector(timeAction:) userInfo:userInfo repeats:isRepeats];
}


//消息传递，在 self.target  运行 self.selector 方法
- (void)timeAction:(id)info {
    [self.target performSelector:self.selector withObject:info];
    
}


@end
