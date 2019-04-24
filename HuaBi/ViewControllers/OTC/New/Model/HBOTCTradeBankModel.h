//
//  HBOTCTradeBankModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/16.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBOTCTradeBankModel : NSObject

@property (nonatomic, copy) NSString *bank_id;

/**
 bank, wechat, alipay
 */
@property (nonatomic, copy) NSString *bankname;
@property (nonatomic, copy) NSString *bname;

/**
 卡号
 */
@property (nonatomic, copy) NSString *cardnum;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *inname;

/**
 姓名
 */
@property (nonatomic, copy) NSString *truename;
@property (nonatomic, copy) NSString *status;


/**
 QR
 */
@property (nonatomic, copy) NSString *img;

- (NSString *)bankTypeString;

- (NSString *)bankIconString;


/**
 是否为银行卡

 @return 是否为银行卡
 */
- (BOOL)isYHK;


/**
 返回卡号后4位

 @return 返回卡号后4位
 */
- (NSString *)last4CharactersOfCardNumber;

@end

NS_ASSUME_NONNULL_END
