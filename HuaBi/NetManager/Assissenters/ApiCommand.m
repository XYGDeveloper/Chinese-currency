

#import "ApiCommand.h"

@implementation ApiCommand

+ (instancetype)defaultApiCommand {
    ApiCommand *command = [[ApiCommand alloc] init];
    command.method = QQWRequestMethodPost;
    command.timeoutInterval = 10;
    return command;
}


+ (instancetype)getApiCommand {
    ApiCommand *command = [[ApiCommand alloc] init];
    command.method = QQWRequestMethodGet;
//    [command.task.currentRequest.allHTTPHeaderFields setValue:[User LocalUser].cookieString forKey:@"Set-Cookie"];
    command.timeoutInterval = 10;

    return command;
    
}

+ (NSString *)requestURLWithRelativePath:(NSString *)relativePath {
    if ([relativePath hasPrefix:@"/"]) {
        return [NSString stringWithFormat:@"%@%@",kBasePath, relativePath];
    } else {
        return [NSString stringWithFormat:@"%@/%@",kBasePath, relativePath];
    }
}



@end
