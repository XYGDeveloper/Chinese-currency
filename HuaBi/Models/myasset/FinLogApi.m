//
//  FinLogApi.m
//  YJOTC
//
//  Created by l on 2018/10/10.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "FinLogApi.h"
#import "FinModel.h"
@interface FinLogApi()

@property (nonatomic,copy)NSString *lan;
@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *token_id;

@end

@implementation FinLogApi

- (instancetype)initWithKey:(NSString *)token lanage:(NSString *)lanage token_id:(NSString *)token_id leng:(NSString *)leng type:(NSString *)type currency_id:(NSString *)currency_id{
    self = [super init];
    if (self) {
        self.lan = lanage;
        self.token = token;
        self.token_id = token_id;
        self.leng = leng;
        self.type = type;
        self.currency_id = currency_id;
    }
    return self;
}

- (void)refresh {
    NSDictionary *params = [self _paramters];
    [self refreshWithParams:params];
}

- (NSDictionary *)_paramters {
    return @{
             @"language":self.lan ?: @"",
             @"token":kUserInfo.token ?: @"",
             @"token_id":kUserInfo.user_id ?: @"",
             @"leng":self.leng ?: @"",
             @"type":self.type ?: @"",
             @"currency_id":self.currency_id ?: @"",
             };
}

- (void)loadNextPage {
    NSDictionary *params = [self _paramters];
    [self loadNextPageWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(mine_widthdraw);
    return command;
}

- (id)reformData:(id)responseObject {
    NSArray *list = [FinModel mj_objectArrayWithKeyValuesArray:responseObject];
    NSLog(@"------%@",responseObject);
    return list;
}


- (NSString *)lan {
    if (!_lan) {
        
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
        _lan = lang;
    }
    
    return _lan;
}

@end
