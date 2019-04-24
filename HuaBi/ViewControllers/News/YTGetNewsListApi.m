//
//  YTGetNewsListApi.m
//  YJOTC
//
//  Created by l on 2018/10/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTGetNewsListApi.h"
#import "YTDetailModel.h"
@interface YTGetNewsListApi()

@property (nonatomic,strong)NSString *type;

@property (nonatomic,strong)NSString *lan;

@end
@implementation YTGetNewsListApi

- (instancetype)initWithType:(NSString *)type lanage:(NSString *)lanage{
    self = [super init];
    if (self) {
        self.type = type;
        self.lan = lanage;
    }
    return self;
}

- (void)refresh {
    NSDictionary *params = @{@"judge": self.type ?: @"",
                             @"language":self.lan ?: @""
                             };
    [self refreshWithParams:params];
}

- (void)loadNextPage {
    NSDictionary *params = @{@"judge": self.type ?: @"",
                             @"language":self.lan ?: @""
                             };
    [self loadNextPageWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(new_detail);
    return command;
}

- (id)reformData:(id)responseObject {
    NSArray *list = [YTDetailModel mj_objectArrayWithKeyValuesArray:responseObject];
    NSLog(@"/////////%@",list);
    return list;
}

@end
