//
//  HBResumeModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/19.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBIconInfoModel.h"

@implementation HBIconInfoModel

- (NSString *)name {
    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    NSString *name = self.english_short;
    if ([currentLanguage containsString:@"Hant"]){//繁体
        name = self.china_name;
    }
    
    if (!name && !self.english_name) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@(%@)", (name ?: @""), self.english_name ?: @""];
}

@end
