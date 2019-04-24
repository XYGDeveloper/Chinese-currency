

#import "BaseApi.h"

#define START_PAGE 1

@interface BaseListApi : BaseApi

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger pageSize;

/** 若除页码外，无其他参数，子类可直接使用以下两方法，如果有其他参数，则需重写这两个方法 */
- (void)refresh;
- (void)loadNextPage;
 
/** 有页码外的其他参数时，子类重写以上两个方法时，调用这两个方法，并将其他参数带入 */
- (void)refreshWithParams:(NSDictionary *)params;
- (void)loadNextPageWithParams:(NSDictionary *)params;

/** 根据网络请求后得到数据的解析，判断是否有更多数据，默认将reformedData视为数组，数组元素个数大于0返回yes，反之返回NO;若不是数组直接返回yes,逻辑由子类来实现 */
- (BOOL)hasMoreWithReformedData:(id)reformedData;

@end
