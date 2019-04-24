//
//  NSString+IM.h
//  
//
//  Created by tarena31 on 16/7/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZZ)
@property (nonatomic,readonly) NSURL *ks_URL;


- (NSAttributedString *)attributedStringWithParagraphSize:(CGFloat)size;

@end
