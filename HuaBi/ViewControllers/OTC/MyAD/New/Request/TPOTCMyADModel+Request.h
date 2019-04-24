//
//  TPOTCMyADModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/3.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "TPOTCMyADModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TPOTCMyADModel (Request)

+ (void)requestMyADModelsWithCurrencyID:(NSString *)currencyID
                              isHistory:(BOOL)isHistory
                                   page:(NSInteger)page
                               pageSize:(NSInteger)pageSize
                                success:(void(^)(NSArray<TPOTCMyADModel *> *models, YWNetworkResultModel *obj))success
                                failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
