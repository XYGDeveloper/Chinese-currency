//
//  UIImage+HB.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "UIImage+HB.h"
#import "UIImage+ZXCompress.h"

@implementation UIImage (HB)

- (NSString *)toHBJsonString {
    UIImage *tempimage = [UIImage imageWithData:UIImageJPEGRepresentation(self, 1.0)];
    CGSize size = [UIImage zx_scaleImage:tempimage length:668.];
    tempimage = [tempimage zx_imageWithNewSize:size];
    NSString *str = [NSString stringWithFormat:@"%@%@",@"data:image/jpeg;base64,",[Utilities encodeToBase64StringWithImage:tempimage]];
    
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@[str] options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return [jsonString base64EncodedString];
}

- (NSString *)toHBJsonStringOnlyOnceBase64Encoded {
    UIImage *tempimage = [UIImage imageWithData:UIImageJPEGRepresentation(self, 1.0)];
    CGSize size = [UIImage zx_scaleImage:tempimage length:668.];
    tempimage = [tempimage zx_imageWithNewSize:size];
    NSString *str = [NSString stringWithFormat:@"%@%@",@"data:image/jpeg;base64,",[Utilities encodeToBase64StringWithImage:tempimage]];
    
//    NSError *error = nil;
//    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@[str] options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}

@end
