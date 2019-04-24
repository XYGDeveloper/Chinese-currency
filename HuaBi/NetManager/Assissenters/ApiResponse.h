
#import <Foundation/Foundation.h>

//请求成功的状态码
static NSString *kCodeSuccess = @"10000";

/**
 *  api请求结果信息，主要包括返回的状态码，说明信息等
 */
@interface ApiResponse : NSObject

/**
 *  api请求返回的状态码
 */
@property (nonatomic, copy, readonly) NSString *code;

/**
 *  api请求返回的http状态码
 */
@property (nonatomic, assign, readonly) NSInteger httpCode;

/**
 *  api请求返回的说明信息，如“请求成功”、“登陆失败等”
 */
@property (nonatomic, copy, readonly) NSString *msg;

+ (instancetype)responseWithTask:(NSURLSessionTask *)task response:(id)responseObject error:(NSError *)error;

@end
