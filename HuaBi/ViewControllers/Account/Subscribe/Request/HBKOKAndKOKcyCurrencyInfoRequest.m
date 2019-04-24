//
//  HBKOKAndKOKcyCurrencyInfoRequest.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/8.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBKOKAndKOKcyCurrencyInfoRequest.h"
#import "YTData_listModel.h"

@interface HBKOKAndKOKcyCurrencyInfoRequest ()



@end

@implementation HBKOKAndKOKcyCurrencyInfoRequest

+ (instancetype)sharedInstance {
    static HBKOKAndKOKcyCurrencyInfoRequest *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [HBKOKAndKOKcyCurrencyInfoRequest new];
    });
    
    return instance;
}

- (void)requestMyKokWithCompletion:(void(^)(ListModel *kok, ListModel *kokcy, NSError *error))completion {
    
    if (self.koks.count == 2) {
        if (completion) {
            completion(self.koks[0], self.koks[1], nil);
        }
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
   
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/AccountManage/mykok"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        
        if (success) {
            id data = [responseObj ksObjectForKey:kData];
            self.koks = [ListModel mj_objectArrayWithKeyValuesArray:data ];
            if (completion) {
                completion(self.koks[0], self.koks[1], nil);
            }
        } else {
            if (completion) {
                completion(nil, nil, error);
            }
        }
    }];
    
}

@end
