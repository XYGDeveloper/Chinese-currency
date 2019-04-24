//
//  HBKOKAndKOKcyCurrencyInfoRequest.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/8.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ListModel;
@interface HBKOKAndKOKcyCurrencyInfoRequest : NSObject

@property (nonatomic, strong) NSArray<ListModel *> *koks;

+ (instancetype)sharedInstance;
- (void)requestMyKokWithCompletion:(void(^)(ListModel *kok, ListModel *kokcy, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
