//
//  BankModel.h
//  YJOTC
//
//  Created by l on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankModel : NSObject
@property (nonatomic,copy)NSString *bid;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *englishname;
@property (nonatomic,copy)NSString *logo;
@property (nonatomic,copy)NSString *value;

@end

NS_ASSUME_NONNULL_END
