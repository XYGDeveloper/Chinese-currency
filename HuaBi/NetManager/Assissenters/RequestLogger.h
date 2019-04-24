

#import <Foundation/Foundation.h>


@class ApiCommand;
@interface RequestLogger : NSObject

/**
 *  打印发起请求的相关信息
 *
 *  @param command  请求配置
 *  @param dataTask 请求对应的task
 */
+ (void)logRequestWithCommand:(ApiCommand *)command task:(NSURLSessionDataTask *)dataTask;

/**
 *  打印请求返回的相关信息
 *
 *  @param dataTask       请求任务
 *  @param responseObject 请求返回的数据
 *  @param error          请求失败时的错误信息
 */
+ (void)logResponsWithTask:(NSURLSessionDataTask *)dataTask
                 startTime:(NSDate *)startDate
             responsObject:(id)responseObject
                     error:(NSError *)error;

@end
