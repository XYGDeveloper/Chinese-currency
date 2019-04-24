//
//  HBHomeIndexModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBHomeIndexModel+Request.h"
//#import ""

@implementation HBHomeIndexModel (Request)

+ (void)requestHomeIndexDataWithSuccess:(void(^)(HBHomeIndexModel *model))success
                                failure:(void(^)(NSError *error))failure {

    [kNetwork_Tool objPOST:@"/Api/Index/index" parameters:nil success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            NSLog(@"%@",responseObject);
            HBHomeIndexModel *indexModel =[HBHomeIndexModel mj_objectWithKeyValues:model.result];
            if (success) {
                success(indexModel);
            }
        } else if (failure) {
            failure(model.error);
        }
    } failure:failure];
}

+ (void)requestHomeQuotationsWithSuccess:(void(^)(YWNetworkResultModel *model))success
                                 failure:(void(^)(NSError *error))failure {
    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    NSString *lang = nil;
    if ([currentLanguage containsString:@"en"]) {//英文
        lang = @"en-us";
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
        lang = @"zh-tw";
    }else if ([currentLanguage containsString:@"ko"]){//繁体
        lang = KoreanLanage;
    }else if ([currentLanguage containsString:Japanese]){//繁体
        lang = Japanese;
    }else{//泰文
        lang = ThAI;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"language"] = lang;
    [kNetwork_Tool objPOST:@"/Api/Index/quotation" parameters:param success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            NSLog(@"%@",responseObject);
//            HBHomeIndexModel *indexModel =[HBHomeIndexModel mj_objectWithKeyValues:model.result];
            if (success) {
                success(model);
            }
        } else if (failure) {
            failure(model.error);
        }
    } failure:failure];
}

@end
