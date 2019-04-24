//
//  PayModel.h
//  YJOTC
//
//  Created by l on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bankModel : NSObject

@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *bank_id;
@property (nonatomic,copy)NSString *bname;
@property (nonatomic,copy)NSString *cardnum;
@property (nonatomic,copy)NSString *inname;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *truename;
@end

@interface AlipayModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *cardnum;
@property (nonatomic,copy)NSString *img;
@property (nonatomic,copy)NSString *status;
@end

@interface WechatModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *cardnum;
@property (nonatomic,copy)NSString *img;
@property (nonatomic,copy)NSString *status;

@end

@interface PayModel : NSObject
@property (nonatomic,copy)NSArray *yinhang;
@property (nonatomic,copy)NSArray *alipay;
@property (nonatomic,copy)NSArray *wechat;

@end

