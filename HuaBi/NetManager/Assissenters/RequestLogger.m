

#import "RequestLogger.h"
#import "ApiCommand.h"

@implementation RequestLogger

+ (void)logRequestWithCommand:(ApiCommand *)command task:(NSURLSessionDataTask *)dataTask{
#ifdef DEBUG
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                          请求开始                           *\n**************************************************************\n"];
   
    [logString appendFormat:@"请求方式：%@\n", [self stringForMethod:command.method]];
    [logString appendFormat:@"超时时间：%@\n", @(command.timeoutInterval)];
    [logString appendFormat:@"请求地址：%@\n", command.requestURLString];
    [logString appendFormat:@"请求参数：%@\n", command.parameters];
    [logString appendFormat:@"请求头部：%@\n", dataTask.originalRequest.allHTTPHeaderFields];
    [logString appendFormat:@"**************************************************************\n\n"];
    
    NSLog(@"%@", logString);
#endif
}

+ (void)logResponsWithTask:(NSURLSessionDataTask *)dataTask
                 startTime:(NSDate *)startDate
             responsObject:(id)responseObject
                     error:(NSError *)error {
#ifdef DEBUG
    BOOL shouldLogError = error ? YES : NO;
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                           请求返回                          =\n==============================================================\n"];
    NSTimeInterval timeDuring =[[NSDate date] timeIntervalSinceDate:startDate];
    
    NSURLRequest *request = dataTask.currentRequest;
    [logString appendFormat:@"请求耗时：%.3f秒\n\n", timeDuring];
    [logString appendFormat:@"请求地址：%@://%@%@\n\n", request.URL.scheme, request.URL.host, request.URL.path];
    [logString appendFormat:@"get子串：\n\t%@\n\n", request.URL.query];
    
    if ([NSJSONSerialization isValidJSONObject:responseObject]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:NULL];
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [logString appendFormat:@"返回数据：\n\n%@\n", responseString];
      

    } else {
        [logString appendFormat:@"返回数据：\n\n%@\n", responseObject];
    }
    
    if (shouldLogError) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    }
    
    [logString appendFormat:@"==============================================================\n\n"];
//    if ([MyRequestApiClient sharedClient].networkStatus == AFNetworkReachabilityStatusNotReachable) {
//        [Utils showErrorMsg:[AppDelegate APP].window type:0 msg:@"网络连接有问题,稍后重试"];
//    }
    NSLog(@"%@", logString);
#endif
}


#pragma mark - Helper
+ (NSString *)stringForMethod:(QQWRequestMethod)method {
    switch (method) {
        case QQWRequestMethodGet:
            return @"GET";
            break;
        case QQWRequestMethodPost:
            return @"POST";
            break;
        default:
            break;
    }
    return @"unknow";
}

@end
