//
//  NSDictionary+HBWrapperParameters.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/3/13.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "NSDictionary+HBWrapperParameters.h"
#import "NSUserDefaults+HB.h"

@implementation NSDictionary (HBWrapperParameters)

+ (NSDictionary *)_wrappedParametersFor:(NSDictionary *)parameters {
    if (!parameters) {
        parameters = @{};
    }
    NSMutableDictionary *tmp = parameters.mutableCopy;
//    if (![parameters.allKeys containsObject:@"language"])
    {
//        NSString *currentLanguage = [LocalizableLanguageManager currentLanguage];
//        NSString *lang = nil;
//        if ([currentLanguage containsString:@"en"]) {//英文
//            lang = @"en-us";
//        }else if ([currentLanguage containsString:@"Hant"]){//繁体
//            lang = @"zh-tw";
//        }else if ([currentLanguage containsString:@"ko"]){//繁体
//            lang = KoreanLanage;
//        }else if ([currentLanguage containsString:Japanese]){//繁体
//            lang = @"ja-jr";
//        }else{//泰文
//            lang = ThAI;
//        }
        
        tmp[@"language"] = [LocalizableLanguageManager currentLanguage] ?: @"zh-tw";
    }
    
    if (![parameters.allKeys containsObject:@"token_id"] && kUserInfo.uid > 0) {
        tmp[@"token_id"] = @(kUserInfo.uid);
    }
    
    if (![parameters.allKeys containsObject:@"key"] && kUserInfo.token) {
        tmp[@"key"] = kUserInfo.token ?: @"";
    }
    
    tmp[@"sign__time"] = [NSUserDefaults getServerTime] ?: @"";
    tmp[@"sign"] = [Utilities handleParamsWithDic:tmp];
    
    return tmp.copy;
}

@end
