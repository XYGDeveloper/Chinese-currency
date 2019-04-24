//
//  UpdateVersionManager.m
//  YJOTC
//
//  Created by l on 2018/9/18.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "UpdateVersionManager.h"
#import "NSUserDefaults+HB.h"

@implementation UpdateVersionManager

+ (instancetype)sharedUpdate {
    static UpdateVersionManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[UpdateVersionManager alloc] init];
    });
    return __manager;
}


- (void)versionControl{
    
    [self versionControlWithSuccess:nil failure:nil];
    
}

- (void)versionControlWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    
//    if ([kBasePath containsString:@"tp://te"]) {
//        return;
//    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
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
    param[@"language"] = lang;
    param[@"platform"] = @"ios";
    param[@"uuid"] = [Utilities randomUUID];
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/District/version"] andParam:param completeBlock:^(BOOL isSuccess, NSDictionary *responseObj, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
            return ;
        }
        if (isSuccess) {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            NSDictionary *dic = [responseObj ksObjectForKey:kResult];
            
            NSString *time =  [dic ksObjectForKey:@"last_get"];
            [NSUserDefaults setServerTime:time];
            
            NSArray *tipsArr = dic[@"mobile_apk_explain"];
            NSMutableString *tipsStr = [NSMutableString new];
            for (NSDictionary *dic in tipsArr) {
                [tipsStr appendString:[NSString stringWithFormat:@"%@\n",dic[@"text"]]];
            }
            
            if (success) {
                success();
            }
            
            if ([kBasePath containsString:@"http://test"]) {
                return;
            }
            NSInteger isForceUpdata = [dic[@"versionForce"]integerValue] ;
            if (![dic[@"versionName"] isEqualToString:app_Version]) {
                self.url = dic[@"downloadUrl"];
                if (isForceUpdata) {
                    NSString *title                          = @"版本升级说明";
                    NSString *content                     = tipsStr.mutableCopy;
                    NSString  *buttonTitle                =  @"立即更新";
                    UpdateViewMessageObject *messageObject = MakeUpdateViewObject(title,content, buttonTitle,YES);
                    [LYZUpdateView showManualHiddenMessageViewInKeyWindowWithMessageObject:messageObject delegate:self viewTag:99];
                }
            }
        }
    }];
    
}

- (void)baseMessageView:(__kindof BaseMessageView *)messageView event:(id)event {
    NSLog(@"%@, tag:%ld event:%@", NSStringFromClass([messageView class]), (long)messageView.tag, event);
    if (messageView.tag == 99) {
        NSURL *url = [NSURL URLWithString:self.url];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
