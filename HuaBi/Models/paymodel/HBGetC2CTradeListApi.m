//
//  HBGetC2CTradeListApi.m
//  HuaBi
//
//  Created by XI YANGUI on 2018/10/25.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBGetC2CTradeListApi.h"
#import "HBGetCListModel.h"
@interface HBGetC2CTradeListApi()

@property (nonatomic,strong)NSString *key;
@property (nonatomic,strong)NSString *tokenid;
@property (nonatomic,strong)NSString *lan;

@end
@implementation HBGetC2CTradeListApi

- (instancetype)initWithType:(NSString *)key tokid:(NSString *)tokenid lanage:(NSString *)lanage{
    self = [super init];
    if (self) {
        self.key = key;
        self.lan = lanage;
        self.tokenid = tokenid;
    }
    return self;
}

- (void)refresh {
    NSDictionary *params = @{@"key": self.key ?: @"",
                             @"token_id":self.tokenid ?: @"",
                             @"language":self.lan ?: @""
                             };
    [self refreshWithParams:params];
}

- (void)loadNextPage {
    NSDictionary *params = @{@"key": self.key ?: @"",
                             @"token_id":self.tokenid ?: @"",
                             @"language":self.lan ?: @""
                             };
    [self loadNextPageWithParams:params];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(new_c2c_list);
    return command;
}

- (id)reformData:(id)responseObject {
    NSArray *list = [HBGetCListModel mj_objectArrayWithKeyValuesArray:responseObject];
    NSLog(@"/////////%@",list);
    return list;
}

@end
