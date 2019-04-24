//
//  NSString+IM.m
//  
//
//  Created by tarena31 on 16/7/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "NSString+ZZ.h"

@implementation NSString (ZZ)
- (NSURL *)ks_URL {
    /******  网络url  ******/
    if ([self containsString:@"http://"] || [self containsString:@"https://"]) {
        return [NSURL URLWithString:self];
    }
    /******  文件url  ******/
    return [NSURL fileURLWithPath:self];
}

- (NSAttributedString *)attributedStringWithParagraphSize:(CGFloat)size {
    NSString *string = self ?: @"";
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, string.length)];
    
    return attributedString1;
}

@end
