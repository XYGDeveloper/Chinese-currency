//
//  GetListApi.m
//  YJOTC
//
//  Created by l on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "GetListApi.h"
//#import "ListModel.h"
@interface GetListApi()

@property (nonatomic,strong)NSString *type;

@property (nonatomic,strong)NSString *lan;

@end

@implementation GetListApi

- (instancetype)initWithType:(NSString *)type lanage:(NSString *)lanage{
    self = [super init];
    if (self) {
        self.type = type;
        self.lan = lanage;
    }
    return self;
}

- (void)refresh {
    NSDictionary *params = @{@"type_name": self.type ?: @"",
                             @"language":self.lan ?: @""
                             };
    [self refreshWithParams:params];
}

- (void)loadNextPage {
    NSDictionary *params = @{@"type_name": self.type ?: @"",
                             @"language":self.lan ?: @""
                             };
    [self loadNextPageWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(quotation_detail);
    return command;
}

- (id)reformData:(id)responseObject {
//    NSArray *list = [ListModel mj_objectArrayWithKeyValuesArray:responseObject[@""]];
    return responseObject;
}

@end
