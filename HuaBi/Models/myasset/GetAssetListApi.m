//
//  GetAssetListApi.m
//  YJOTC
//
//  Created by l on 2018/9/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "GetAssetListApi.h"
#import "MyAssetModel.h"
@interface GetAssetListApi()
@property (nonatomic,strong)NSString *lan;
@property (nonatomic,strong)NSString *token;
@property (nonatomic,strong)NSString *token_id;
@end

@implementation GetAssetListApi

- (instancetype)initWithKey:(NSString *)token
                     lanage:(NSString *)lanage
                   token_id:(NSString *)token_id{
    self = [super init];
    if (self) {
        self.lan = lanage;
        self.token = token;
        self.token_id = token_id;
    }
    return self;
}

- (void)refresh {
    NSDictionary *params = @{@"language":self.lan ?: @"",
                             @"key":self.token ?: @"",
                             @"token_id":self.token_id ?: @"",
                             };
    [self refreshWithParams:params];
}

- (void)loadNextPage {
    NSDictionary *params = @{@"language":self.lan ?: @"",
                             @"key":self.token ?: @"",
                             @"token_id":self.token_id ?: @"",
                             };
    [self loadNextPageWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(mine_myasset);
    return command;
}

- (id)reformData:(id)responseObject {
    MyAssetModel *model = [MyAssetModel mj_objectWithKeyValues:responseObject];
    return model;
}
@end
