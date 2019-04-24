//
//  XNCustomTextfield.m
//  YJOTC
//
//  Created by XI YANGUI on 2018/8/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "XNCustomTextfield.h"
#import "XNTextfieldLimit.h"

@interface XNCustomTextfield ()
@property (nonatomic, strong) XNTextfieldLimit *limit;
@end
@implementation XNCustomTextfield

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self.limit;
        [self addTarget:self.limit
                 action:@selector(valueChange:)
       forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

// 禁止 粘贴、剪切、选择、选择全部
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    //禁止粘贴
    if (action == @selector(paste:)){
        return NO;
    }
    if (action == @selector(cut:)) {
        return NO;
    }
    if (action == @selector(copy:)) {
        return NO;
    }
    if (action == @selector(select:)) {
        return NO;
    }
    if (action == @selector(selectAll:)) {
        return NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}

#pragma mark - Getter
- (XNTextfieldLimit *)limit{
    if (!_limit) {
        _limit = [[XNTextfieldLimit alloc] init];
    }
    return _limit;
}


@end
