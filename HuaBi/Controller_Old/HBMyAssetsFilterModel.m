//
//  HBMyAssetsFilterModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMyAssetsFilterModel.h"

@implementation HBMyAssetsFilterModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id",
             };
}

+ (instancetype)createAllModel {
    HBMyAssetsFilterModel *model = [HBMyAssetsFilterModel new];
    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    NSString *name = nil;
    if ([currentLanguage containsString:@"en"]) {//英文
        name = @"All";
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
        name = @"全部";
    }else if ([currentLanguage containsString:@"ko"]){//繁体
        name = @"몽땅";
    }
    else if ([currentLanguage containsString:Japanese]){//繁体
        name = @"全部";
    }
    else{
        name = @"ทั้งหมด";
    }
    model.name = name;
    model.ID = @"";
    return model;
}



@end
