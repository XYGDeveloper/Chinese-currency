

#import "BaseApi.h"
#import "ApiManager.h"
#import "SafeCategory.h"
#import "NSDictionary+HBWrapperParameters.h"

@interface BaseApi ()

@property (nonatomic, strong) NSMutableArray *tasks;

@end

@implementation BaseApi

- (void)dealloc {
    //请求主体释放时，取消对应的所有请求
    for (NSURLSessionTask *task in self.tasks) {
        if ([task respondsToSelector:@selector(cancel)]) {
            [task cancel];
        }
    }
}

- (void)startRequestWithParams:(NSDictionary *)params {
    [self startRequestWithParams:params multipart:nil];
}

- (void)startRequestWithParams:(NSDictionary *)params multipart:(void(^)(id<AFMultipartFormData>))multipartBlock {
    params = [NSDictionary _wrappedParametersFor:params];
    ApiCommand *cmd = [self buildCommand];
    cmd.parameters = params;
    
    __weak typeof(self) wself = self;
    NSURLSessionTask *task = [APIM requestWithCommand:cmd
                            constructingBodyWithBlock:multipartBlock
                                              success:^(NSURLSessionDataTask *task, ApiCommand *command, id responseObject) {
                                                  __strong typeof(wself) sself = wself;
                                                  [sself successWithTask:task command:command responseObject:responseObject];
                                              }
                                              failure:^(NSURLSessionDataTask *task, ApiCommand *command, NSError *error) {
                                                  __strong typeof(wself) sself = wself;
                                                  [sself failedWithTask:task command:command error:error];
                                              }];
    
    @synchronized (self.tasks) {
        [self.tasks safeAddObject:task];
    }
}

- (void)successWithTask:(NSURLSessionTask *)task command:(ApiCommand *)command responseObject:(id)responseObject {
    @synchronized (self.tasks) {
        [self.tasks removeObject:task];
    }
    
    command.task = task;
    command.response = [ApiResponse responseWithTask:task response:responseObject error:nil];
    id reformedData = [self reformData:responseObject[@"result"]];
    
    [self delegateSuccessWithCommand:command reformedData:reformedData];
}

- (void)failedWithTask:(NSURLSessionTask *)task command:(ApiCommand *)command error:(NSError *)error {
    @synchronized (self.tasks) {
        [self.tasks removeObject:task];
    }
    
    command.task = task;
    command.response = [ApiResponse responseWithTask:task response:nil error:error];
    [self delegateFailedWithCommand:command error:error];
}

#pragma mark - 调用代理方法
- (void)delegateSuccessWithCommand:(ApiCommand *)command reformedData:(id)reformedData {
    if ([self isSuccessedRequestWithCommand:command reformedData:reformedData]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(api:successWithCommand:responseObject:)]) {
            [self.delegate api:self successWithCommand:command responseObject:reformedData];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(api:failedWithCommand:error:)]) {
            [self.delegate api:self failedWithCommand:command error:nil];
        }
    }
}

- (void)delegateFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(api:failedWithCommand:error:)]) {
        [self.delegate api:self failedWithCommand:command error:error];
    }
}

#pragma mark - 子类重写
- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}

- (BOOL)isSuccessedRequestWithCommand:(ApiCommand *)command reformedData:(id)reformedData {
    return [kCodeSuccess isEqualToString:@"10000"];//默认只有状态码为0时才认为请求成功
}

- (id)reformData:(id)responseObject {
    return responseObject;
}

#pragma mark - Properties
- (NSMutableArray *)tasks {
    if (!_tasks) {
        _tasks = [[NSMutableArray alloc] init];
    }
    return _tasks;
}

@end
