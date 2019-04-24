//
//  ListModel+HomeRequest.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/24.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "ListModel+HomeRequest.h"
#import "YTData_listModel.h"
@implementation ListModel (HomeRequest)



+ (void)requestHomeQuotationsWithSuccess:(void(^)(NSArray<ListModel *> *quotations, NSArray<YTData_listModel *> *allRankingArray, YWNetworkResultModel *model))success
                                          
                                          failure:(void(^)(NSError *error))failure {
                                              
    [kNetwork_Tool objPOST:@"/Api/Index/quotation" parameters:nil success:^(YWNetworkResultModel *model, id responseObject) {
        if ([model succeeded]) {
            id quotiationData = [model.result valueForKey:@"quotation"];
            id ranking_all = [model.result valueForKey:@"ranking_all"];
            
            NSArray<YTData_listModel *> *allRankingArray = [YTData_listModel mj_objectArrayWithKeyValuesArray:ranking_all];
            NSArray<ListModel *> *quotations = [ListModel mj_objectArrayWithKeyValuesArray:quotiationData];
            if (success) {
                success(quotations, allRankingArray, model);
            }
        }
    } failure:failure];
}


@end
