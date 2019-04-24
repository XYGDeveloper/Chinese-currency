//
//  NetworkTool.h
//  ywshop
//
//  Created by 周勇 on 2017/10/19.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWNetworkResultModel.h"

@interface NetworkTool : AFHTTPSessionManager

#define kNetwork_Tool [NetworkTool sharedTool]


+ (instancetype)sharedTool;

/**  post请求  */
- (void)POST_HTTPS :(NSString *) req_URL andParam:(NSDictionary *)param completeBlock:(void (^)(BOOL success,NSDictionary *responseObj,NSError *error ))completeBlock;

/**  get请求  */
- (void)GET_HTTPS :(NSString *) req_URL andParam:(NSDictionary *)param completeBlock:(void (^)(BOOL success,NSDictionary *responseObj, NSError *error))completeBlock;

- (NSURLSessionDataTask *)objPOST:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                          success:(void(^)(YWNetworkResultModel *model, id responseObject))success
                          failure:(void(^)(NSError *error))failure;

- (NSURLSessionDataTask *)objGET:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void(^)(YWNetworkResultModel *data, id responseObject))success
                         failure:(void(^)(NSError *error))failure;

- (NSURLSessionDataTask *)uploadImage:(UIImage *)image
                              success:(void(^)(YWNetworkResultModel *data, id responseObject))success
                              failure:(void(^)(NSError *error))failure;

@end
