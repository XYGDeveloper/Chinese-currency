//
//  HBTakeTokenRecordListApi.m
//  HuaBi
//
//  Created by l on 2019/2/23.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBTakeTokenRecordListApi.h"
#import "HBChongCurrencyRecorModel.h"
@interface HBTakeTokenRecordListApi()
@property (nonatomic,strong)NSString *lan;
@property (nonatomic,strong)NSString *token;
@property (nonatomic,strong)NSString *token_id;
@property (nonatomic,strong)NSString *currency_id;
@property (nonatomic,strong)NSString *status;

@end

@implementation HBTakeTokenRecordListApi

- (instancetype)initWithLanage:(NSString *)lanage token:(NSString *)token token_id:(NSString *)token_id currency_id:(NSString *)currency_id status:(NSString *)status{
    self = [super init];
    if (self) {
        self.lan = lanage;
        self.token = token;
        self.token_id = token_id;
        self.currency_id = currency_id;
        self.status = status;
    }
    return self;
}


- (void)refresh {
    NSDictionary *params = @{
                             @"language":self.lan ?: @"",
                             @"token":kUserInfo.token ?: @"",
                             @"token_id":kUserInfo.user_id ?: @"",
                             @"currency_id":self.currency_id ?: @"",
                             @"status":self.status ?: @"",
                             };
    [self refreshWithParams:params];
}

- (void)loadNextPage {
    NSDictionary *params = @{
                             @"language":self.lan ?: @"",
                             @"token":kUserInfo.token ?: @"",
                             @"token_id":kUserInfo.user_id ?: @"",
                             @"currency_id":self.currency_id ?: @"",
                             @"status":self.status ?: @"",
                             };
    [self loadNextPageWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(wallet_record);
    return command;
}

- (id)reformData:(id)responseObject {
    NSArray *list = [HBChongCurrencyRecorModel mj_objectArrayWithKeyValuesArray:responseObject];
    NSLog(@"/////////%@",list);
    return list;
}
@end
