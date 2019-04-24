//
//  getMineListApi.m
//  YJOTC
//
//  Created by l on 2018/9/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "getMineListApi.h"
#import "MineModel.h"
@interface getMineListApi()
@property (nonatomic,strong)NSString *lan;
@property (nonatomic,strong)NSString *token;
@property (nonatomic,strong)NSString *token_id;
@property (nonatomic,strong)NSString *uuid;
@property (nonatomic,strong)NSString *startTime;
@property (nonatomic,strong)NSString *endTime;
@property (nonatomic, copy) NSString *type;
@end
@implementation getMineListApi

- (instancetype)initWithKey:(NSString *)token
                     lanage:(NSString *)lanage
                   token_id:(NSString *)token_id
                       uuid:(NSString *)uuid
                  startTime:(NSString *)starttime
                    endTime:(NSString *)endTime
                       type:(NSString *)type{
    self = [super init];
    if (self) {
        self.lan = lanage;
        self.token = token;
        self.token_id = token_id;
        self.uuid = uuid;
        self.startTime = starttime;
        self.endTime = endTime;
        self.type = type;
    }
    return self;
}

- (void)refresh {
    NSDictionary *params = @{@"language":self.lan ?: @"",
                             @"token":self.token ?: @"",
                             @"token_id":self.token_id ?: @"",
                             @"uuid":self.uuid ?: @"",
                             @"star_time":self.startTime ?: @"",
                             @"end_time":self.endTime ?: @"",
                             @"type":self.type ?: @"",
                             };
    [self refreshWithParams:params];
}

- (void)loadNextPage {
    NSDictionary *params = @{@"language":self.lan ?: @"",
                             @"token":self.token ?: @"",
                             @"token_id":self.token_id ?: @"",
                             @"uuid": self.uuid ?: @"",
                             @"star_time": self.startTime ?: @"",
                             @"end_time": self.endTime ?: @"",
                              @"type": self.type ?: @"",
                             };
    [self loadNextPageWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(mine);
    return command;
}

- (id)reformData:(id)responseObject {
    MineModel *model = [MineModel mj_objectWithKeyValues:responseObject];
    return model;
}

@end
