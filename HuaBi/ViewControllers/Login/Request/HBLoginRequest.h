//
//  HBLoginRequest.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HBLoginRequest : NSObject

+ (void)loginWithPhone:(NSString *)phone
      isNeedVerifyCode:(BOOL)isNeedVerifyCode
              password:(NSString *)password
              validate:(NSString *)validate
             phoneCode:(NSString *)phoneCode
               success:(void(^)(YWNetworkResultModel *model))success
               failure:(void(^)(NSError *error))failure;

/**
 手机\邮箱注册
 
 @param parameters 注册参数，参考文档格式
 @param isEmail 是否为邮箱注册
 @param success success block
 @param failure failure block
 */
+ (void)registerWithParameters:(NSDictionary *)parameters
                       isEmail:(BOOL)isEmail
                       success:(void (^)(YWNetworkResultModel *))success failure:(void (^)(NSError *))failure;

/**
 邮箱注册
 
 @param parameters 注册参数，参考文档格式
 @param success success block
 @param failure failure block
 */
+ (void)registerEmailWithParameters:(NSDictionary *)parameters
                            success:(void(^)(YWNetworkResultModel *model))success
                            failure:(void(^)(NSError *error))failure;

/**
 手机注册

 @param parameters 注册参数，参考文档格式
 @param success success block
 @param failure failure block
 */
+ (void)registerWithParameters:(NSDictionary *)parameters
                       success:(void(^)(YWNetworkResultModel *model))success
                       failure:(void(^)(NSError *error))failure;

/**
 获取注册时验证码

 @param userName 手机号或邮箱
 @param isEmail 是否为邮箱
 @param codeOfContry 国家码（手机）
 @param validate 图形校验码
 @param success success block
 @param failure failure block
 */
+ (void)getRegisterVerifyCodeWithUserName:(NSString *)userName
                                  isEmail:(BOOL)isEmail
                             codeOfContry:(NSString *)codeOfContry
                                 validate:(NSString *)validate
                                  success:(void(^)(YWNetworkResultModel *model))success
                                  failure:(void(^)(NSError *error))failure;



+ (void)sendRegisterSMSWithPhone:(NSString *)phone
                    codeOfContry:(NSString *)codeOfContry
                        validate:(NSString *)validate
                         success:(void(^)(YWNetworkResultModel *model))success
                         failure:(void(^)(NSError *error))failure;

+ (void)sendFindpwdEmail:(NSString *)email
                validate:(NSString *)validate
                 success:(void(^)(YWNetworkResultModel *model))success
                 failure:(void(^)(NSError *error))failure;


+ (void)sendFindtradepwdEmail:(NSString *)email
                     validate:(NSString *)validate
                      success:(void(^)(YWNetworkResultModel *model))success
                      failure:(void(^)(NSError *error))failure;

+ (void)sendFindpwdSMSWithPhone:(NSString *)phone
                       validate:(NSString *)validate
                        success:(void(^)(YWNetworkResultModel *model))success
                        failure:(void(^)(NSError *error))failure;

+ (void)sendFindtradepwdSMSWithPhone:(NSString *)phone
                            validate:(NSString *)validate
                             success:(void(^)(YWNetworkResultModel *model))success
                             failure:(void(^)(NSError *error))failure;

+ (void)sendSMSWithPhone:(NSString *)phone
            codeOfContry:(NSString *)codeOfContry
                validate:(NSString *)validate
                    type:(NSString *)type
                 success:(void(^)(YWNetworkResultModel *model))success
                 failure:(void(^)(NSError *error))failure;



+ (void)findpassWithPhone:(NSString *)phone
                     code:(NSString *)code
                  success:(void(^)(YWNetworkResultModel *model))success
                  failure:(void(^)(NSError *error))failure;

+ (void)resetpassWithPhone:(NSString *)phone
                     token:(NSString *)token
                       pwd:(NSString *)pwd
                     repwd:(NSString *)repwd
                   success:(void(^)(YWNetworkResultModel *model))success
                   failure:(void(^)(NSError *error))failure;

@end


