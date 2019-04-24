
//
//  ListModel+Request.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/5.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "ListModel+Request.h"

@implementation ListModel (Request)

- (void)collectWithSuccess:(void(^)(BOOL isCollected))success
                   failure:(void(^)(NSError *error))failure {
    
    NSDictionary *param = @{@"currency_id" : self.currency_id ?: @"",
                            @"key" : kUserInfo.token ?: @"",
                            @"token_id" : kUserInfo.user_id ?: @"",
                            };
    [kNetwork_Tool objPOST:@"/Api/Trade/collect" parameters:param success:^(YWNetworkResultModel *model, id responseObject) {
        NSLog(@"%@",responseObject);
        if (model.code == 10020 || model.code == 10010 ) {
            BOOL isCollected =  model.code == 10010;
            if (success) {
                success(isCollected);
            }
        } else if (failure) {
            failure(model.error);
        }
        
    } failure:failure];
}

@end
