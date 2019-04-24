

#import <Foundation/Foundation.h>
#import "ApiCommand.h"

#define APIM [ApiManager sharedManager]

@interface ApiManager : NSObject

+ (instancetype)sharedManager;

- (NSURLSessionDataTask *)requestWithCommand:(ApiCommand *)command
                   constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                                     success:(void(^)(NSURLSessionDataTask *task, ApiCommand *command, id responseObject))success
                                     failure:(void(^)(NSURLSessionDataTask *task, ApiCommand *command, NSError *error))failure;

@end
