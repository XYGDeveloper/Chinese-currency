

#import <Foundation/Foundation.h>
#import "ApiCommand.h"


@protocol ApiRequestDelegate;
@interface BaseApi : NSObject

@property (nonatomic, weak) id<ApiRequestDelegate> delegate;

/**
 *  由子类或业务类调用，传入请求参数，发起请求
 *
 *  @param params 请求参数
 */
- (void)startRequestWithParams:(NSDictionary *)params;
- (void)startRequestWithParams:(NSDictionary *)params multipart:(void(^)(id<AFMultipartFormData>))multipartBlock;
#pragma mark - 以下方法，可以子类覆盖，以实现对应业务的功能
/** 配置请求的url，超时时间等信息 */
- (ApiCommand *)buildCommand;

/** 该方法用于判断一个请求是否是真的成功，子类可以覆盖实现 */
- (BOOL)isSuccessedRequestWithCommand:(ApiCommand *)command reformedData:(id)reformedData;

/** 将请求返回的json数据（字典）转化成业务方需的model。转化时使用MJExtentsion库，当需要转化出多个对象时，可将多个对象用字典组织来返回 */
- (id)reformData:(id)responseObject;

@end



/**
 *  子类可以扩展该协议，适应业务更加复杂的请求
 */
@protocol ApiRequestDelegate <NSObject>
/**
 *  请求成功后，提供给业务方的回调方法
 *
 *  @param api           请求的api对象
 *  @param command       请求的相关信息，包括入参、地址等
 *  @param responsObject 对应api类处理后的返回数据，可以直接提供给业务类使用
 */
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject;

/**
 *  请求失败后提供给业务方的回调方法
 *
 *  @param api     请求的api对象
 *  @param command 请求的相关信息，包括入参、地址等
 *  @param error   错误信息
 */
- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error;



@optional
/**
 *  分页请求，上拉加载更多请求成功
 *
 *  @param api           请求的api对象
 *  @param command       请求的相关信息，包括入参、地址等
 *  @param responsObject 对应api类处理后的返回数据，可以直接提供给业务类使用
 */
- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject;

/**
 *  分页请求，上拉加载更多时请求失败
 *
 *  @param api     请求的api对象
 *  @param command 请求的相关信息，包括入参、地址等
 *  @param error   错误信息
 */
- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error;

/**
 *  分页请求，上拉加载时，已没有更多数据
 *
 *  @param api     请求的api对象
 *  @param command 请求的相关信息，包括入参、地址等
 */
- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command;

@end
