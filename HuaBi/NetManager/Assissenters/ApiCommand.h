
#import <Foundation/Foundation.h>
#import "ApiResponse.h"

#define APIURL(relativePath) [ApiCommand requestURLWithRelativePath:relativePath]
typedef NS_ENUM(NSInteger, QQWRequestMethod) {
    
    QQWRequestMethodGet = 1,
    QQWRequestMethodPost = 2
    
};


@interface ApiCommand : NSObject

/**
 *  api请求地址
 */
@property (nonatomic, copy) NSString *requestURLString;

/**
 *  请求参数（为字典或数组）
 */
@property (nonatomic, strong) id parameters;

/**
 *  请求方式，默认为post，可以修改为get
 */
@property (nonatomic, assign) QQWRequestMethod method;

/**
 *  请求成功或失败后的一些基本信息
 */
@property (nonatomic, strong) ApiResponse *response;

/**
 *  和请求对应的task对象
 */
@property (nonatomic, strong) NSURLSessionTask *task;

/**
 *  请求超时时间
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 *  返回一个默认的请求
 *
 */
+ (instancetype)defaultApiCommand;
+ (instancetype)getApiCommand;


+ (NSString *)requestURLWithRelativePath:(NSString *)relativePath;


@end
