//
//  NSString+sandBox.m
//
//  Created by shenzhenIOS on 15/3/31.
//  Copyright © 2015年 ZhuuYong. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (sandBox)
//chche目录
- (instancetype)appendCache;
//Document目录
- (instancetype)appendDocument;
//Temp目录
- (instancetype)appendTemp;
@end
