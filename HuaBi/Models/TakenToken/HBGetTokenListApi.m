//
//  HBGetTokenListApi.m
//  HuaBi
//
//  Created by l on 2019/2/21.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBGetTokenListApi.h"
#import "HBTokenListModel.h"
@interface HBGetTokenListApi()
@property (nonatomic,strong)NSString *lan;
@property (nonatomic,strong)NSString *token;
@property (nonatomic,strong)NSString *token_id;

@end
@implementation HBGetTokenListApi

- (instancetype)initWithLanage:(NSString *)lanage token:(NSString *)token token_id:(NSString *)token_id{
    self = [super init];
    if (self) {
        self.lan = lanage;
        self.token = token;
        self.token_id = token_id;
    }
    return self;
}


- (void)refresh {
    NSDictionary *params = @{
                             @"language":self.lan ?: @"",
                             @"token":kUserInfo.token ?: @"",
                             @"token_id":kUserInfo.user_id ?: @"",
                             };
[self refreshWithParams:params];
}

- (void)loadNextPage {
    NSDictionary *params = @{
                             @"language":self.lan ?: @"",
                             @"token":kUserInfo.token ?: @"",
                             @"token_id":kUserInfo.user_id ?: @"",
                             };
[self loadNextPageWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(taketokenlist);
    return command;
}

- (id)reformData:(id)responseObject {
    NSArray *list = [HBTokenListModel mj_objectArrayWithKeyValuesArray:responseObject];
    NSLog(@"/////////%@",list);
    return list;
}

@end
