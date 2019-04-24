//
//  HBLoginRequest.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBLoginRequest.h"

@implementation HBLoginRequest

+ (void)loginWithPhone:(NSString *)phone
      isNeedVerifyCode:(BOOL)isNeedVerifyCode
              password:(NSString *)password
              validate:(NSString *)validate
             phoneCode:(NSString *)phoneCode
               success:(void(^)(YWNetworkResultModel *model))success
               failure:(void(^)(NSError *error))failure {
    NSDictionary *parameters = @{
                                 @"platform" : @"ios",
                                 @"username" : phone ?: @"",
                                 @"password" : password ?: @"",
                                 @"validate" : validate ?: @"",
                                 @"phone_code" : phoneCode ?: @"",
                                 @"uuid" : [Utilities randomUUID],
                                 };
    NSString *apiURI = isNeedVerifyCode ? @"/Api/Account/login" : @"/Api/Account/is_login_code";
    [kNetwork_Tool objPOST:apiURI parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if (success) {
            success(model);
        }
    } failure:failure];
}

+ (void)registerEmailWithParameters:(NSDictionary *)parameters
                            success:(void(^)(YWNetworkResultModel *model))success
                            failure:(void(^)(NSError *error))failure {
    
    [self registerWithParameters:parameters isEmail:YES success:success failure:failure];
}

+ (void)registerWithParameters:(NSDictionary *)parameters
                       success:(void(^)(YWNetworkResultModel *model))success
                       failure:(void(^)(NSError *error))failure {
    
    [self registerWithParameters:parameters isEmail:NO success:success failure:failure];
}


+ (void)registerWithParameters:(NSDictionary *)parameters
                       isEmail:(BOOL)isEmail
                       success:(void (^)(YWNetworkResultModel *))success failure:(void (^)(NSError *))failure {
    
    NSString *URI = isEmail ? @"/Api/Account/emailAddReg" : @"/Api/Account/phoneAddReg";
    [kNetwork_Tool objPOST:URI parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            success(model);
        }
    } failure:failure];
}

+ (void)getRegisterVerifyCodeWithUserName:(NSString *)userName
                                  isEmail:(BOOL)isEmail
                             codeOfContry:(NSString *)codeOfContry
                                 validate:(NSString *)validate
                                  success:(void(^)(YWNetworkResultModel *model))success
                                  failure:(void(^)(NSError *error))failure {
    if (isEmail) {
        [self sendRegisterEmail:userName validate:validate success:success failure:failure];
    } else {
        [self sendRegisterSMSWithPhone:userName
                          codeOfContry:codeOfContry
                              validate:validate
                               success:success
                               failure:failure];
    }
}

+ (void)sendFindtradepwdEmail:(NSString *)email
                     validate:(NSString *)validate
                      success:(void(^)(YWNetworkResultModel *model))success
                      failure:(void(^)(NSError *error))failure {
    
    [self sendEmail:email validate:validate type:@"findtradepwd" success:success failure:failure];
}

+ (void)sendFindpwdEmail:(NSString *)email
                validate:(NSString *)validate
                 success:(void(^)(YWNetworkResultModel *model))success
                 failure:(void(^)(NSError *error))failure {
    
    [self sendEmail:email validate:validate type:@"findpwd" success:success failure:failure];
}

+ (void)sendRegisterEmail:(NSString *)email
                 validate:(NSString *)validate
                  success:(void(^)(YWNetworkResultModel *model))success
                  failure:(void(^)(NSError *error))failure {
    
    [self sendEmail:email validate:validate type:@"register" success:success failure:failure];
}

+ (void)sendEmail:(NSString *)email
         validate:(NSString *)validate
             type:(NSString *)type
          success:(void(^)(YWNetworkResultModel *model))success
          failure:(void(^)(NSError *error))failure {
    NSDictionary *parameters = @{
                                 @"email" : email ?: @"",
                                 @"type" : type ?: @"",
                                 @"validate" : validate ?: @"",
                                 };
    [kNetwork_Tool objPOST:@"/Api/Email/code" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if (success) {
            success(model);
        }
    } failure:failure];
}

+ (void)sendRegisterSMSWithPhone:(NSString *)phone
                    codeOfContry:(NSString *)codeOfContry
                        validate:(NSString *)validate
                         success:(void(^)(YWNetworkResultModel *model))success
                         failure:(void(^)(NSError *error))failure {
    
    [self sendSMSWithPhone:phone
              codeOfContry:codeOfContry
                  validate:validate
                      type:@"register"
                   success:success
                   failure:failure];
}



+ (void)sendFindtradepwdSMSWithPhone:(NSString *)phone
                            validate:(NSString *)validate
                             success:(void(^)(YWNetworkResultModel *model))success
                             failure:(void(^)(NSError *error))failure {
    
    [self sendSMSWithPhone:phone
              codeOfContry:nil
                  validate:validate
                      type:@"findtradepwd"
                   success:success
                   failure:failure];
}

+ (void)sendFindpwdSMSWithPhone:(NSString *)phone
                       validate:(NSString *)validate
                         success:(void(^)(YWNetworkResultModel *model))success
                         failure:(void(^)(NSError *error))failure {
    
    [self sendSMSWithPhone:phone
              codeOfContry:nil
                  validate:validate
                      type:@"findpwd"
                   success:success
                   failure:failure];
}

+ (void)sendSMSWithPhone:(NSString *)phone
            codeOfContry:(NSString *)codeOfContry
                validate:(NSString *)validate
                    type:(NSString *)type
                 success:(void(^)(YWNetworkResultModel *model))success
                 failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"phone" : phone ?: @"",
                                 @"country_code" : codeOfContry ?: @"",
                                 @"validate" : validate ?: @"",
                                 @"type" : type ?: @"",
                                 };
    [kNetwork_Tool objPOST:@"/Api/Account/sendsms" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if (success) {
            success(model);
        }
    } failure:failure];
}

+ (void)findpassWithPhone:(NSString *)phone
                     code:(NSString *)code
                  success:(void(^)(YWNetworkResultModel *model))success
                  failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = @{
                                 @"phone" : phone ?: @"",
                                 @"phone_code" : code ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/Account/findpass" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if (success) {
            success(model);
        }
    } failure:failure];
}

+ (void)resetpassWithPhone:(NSString *)phone
                     token:(NSString *)token
                       pwd:(NSString *)pwd
                     repwd:(NSString *)repwd
                   success:(void(^)(YWNetworkResultModel *model))success
                   failure:(void(^)(NSError *error))failure {
    NSDictionary *parameters = @{
                                 @"phone" : phone ?: @"",
                                 @"token" : token ?: @"",
                                 @"pwd" : pwd ?: @"",
                                 @"repwd" : repwd ?: @"",
                                 };
    
    [kNetwork_Tool objPOST:@"/Api/Account/resetpass" parameters:parameters success:^(YWNetworkResultModel *model, id responseObject) {
        if (success) {
            success(model);
        }
    } failure:failure];
}

@end
