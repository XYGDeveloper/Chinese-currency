//
//  YTMyassetDetailModel+Request.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/5.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTMyassetDetailModel.h"


@interface YTMyassetDetailModel (Request)

+ (void)requestMyAssetDetailWithCurrencyID:(NSString *)ID
                                   success:(void(^)(YTMyassetDetailModel *model, YWNetworkResultModel *obj))success
                                   failure:(void(^)(NSError *error))failure;

@end

