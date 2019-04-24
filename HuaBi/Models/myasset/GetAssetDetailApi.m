//
//  GetAssetDetailApi.m
//  YJOTC
//
//  Created by l on 2018/9/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "GetAssetDetailApi.h"
#import "YTMyassetDetailModel.h"
@interface GetAssetDetailApi()
@property (nonatomic,strong)NSString *lan;
@property (nonatomic,strong)NSString *token;
@property (nonatomic,strong)NSString *token_id;
@property (nonatomic,strong)NSString *currency_id;

@end
@implementation GetAssetDetailApi

- (instancetype)initWithKey:(NSString *)token
                     lanage:(NSString *)lanage
                   token_id:(NSString *)token_id
                currency_id:(NSString *)currency_id{
    self = [super init];
    if (self) {
        self.lan = lanage;
        self.token = token;
        self.token_id = token_id;
        self.currency_id = currency_id;
    }
    return self;
}

- (void)refresh {
    NSDictionary *params = @{@"language":self.lan ?: @"",
                             @"key":self.token ?: @"",
                             @"token_id":self.token_id ?: @"",
                             @"currency_id":self.currency_id ?: @"",
                             };
    [self refreshWithParams:params];
}

- (void)loadNextPage {
    NSDictionary *params = @{@"language":self.lan ?: @"",
                             @"key":self.token ?: @"",
                             @"token_id":self.token_id ?: @"",
                             @"currency_id":self.currency_id ?: @"",
                             };
    [self loadNextPageWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(mine_myasset_detail);
    return command;
}

- (id)reformData:(id)responseObject {
    YTMyassetDetailModel *item = [YTMyassetDetailModel mj_objectWithKeyValues:responseObject];
    return item;
}
@end
