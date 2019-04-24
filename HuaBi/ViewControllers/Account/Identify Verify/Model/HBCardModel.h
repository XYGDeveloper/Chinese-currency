//
//  HBCardModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 证件类型

 - HBCardModelTypeIdentifyCard: 身份证
 - HBCardModelTypePassport: 护照
 - HBCardModelTypeOther: 其他
 - HBCardModelTypeDriverLicense: 驾照
 */
typedef NS_ENUM(NSInteger, HBCardModelType) {
    HBCardModelTypeIdentifyCard = 1,
    HBCardModelTypePassport = 2,
    HBCardModelTypeOther = 4,
    HBCardModelTypeDriverLicense = 5,
};


/**
 认证结果

 - HBCardModelVerifyStateUnverify: 未认证
 - HBCardModelVerifyStateFailure: 未通过
 - HBCardModelVerifyStateVerified: 已认证
 - HBCardModelVerifyStateVerifying: 审核中
 */
typedef NS_ENUM(NSInteger, HBCardModelVerifyState)  {
    HBCardModelVerifyStateUnverify = -1,
    HBCardModelVerifyStateFailure = 0,
    HBCardModelVerifyStateVerified = 1,
    HBCardModelVerifyStateVerifying = 2,
};

@interface HBCardModel : NSObject


/**
 用户姓名
 */
@property (nonatomic, copy) NSString *name;

/**
 证件类型 1身份证 2护照 5驾照
 */
@property (nonatomic, assign) HBCardModelType cardtype;
@property (nonatomic, copy, readonly) NSString *cardtypeString;

/**
 证件号
 */
@property (nonatomic, copy) NSString *idcard;

/**
 正面照
 */
@property (nonatomic, copy) NSString *pic1;

/**
 背面照
 */
@property (nonatomic, copy) NSString *pic2;

/**
 手持照
 */
@property (nonatomic, copy) NSString *pic3;

@property (nonatomic, copy) NSString *country_code;


@property (nonatomic, assign) HBCardModelVerifyState verify_state;

+ (NSArray<HBCardModel *> *)geneateCards;

@end

NS_ASSUME_NONNULL_END
