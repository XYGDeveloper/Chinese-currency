

#import "BaseListApi.h"
#import "SafeCategory.h"
@implementation BaseListApi

- (id)init {
    if (self = [super init]) {
        self.page = START_PAGE;
        self.pageSize = 20;
    }
    return self;
}

- (void)refresh {
    [self refreshWithParams:nil];
}

- (void)loadNextPage {
    [self loadNextPageWithParams:nil];
}

- (void)refreshWithParams:(NSDictionary *)params {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:params];
    [dic safeSetObject:@(START_PAGE) forKey:@"page"];
    [dic safeSetObject:@(self.pageSize) forKey:@"rows"];
    [self startRequestWithParams:dic];
}

- (void)loadNextPageWithParams:(NSDictionary *)params {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:params];
    [dic safeSetObject:@(self.page + 1) forKey:@"page"];
    [dic safeSetObject:@(self.pageSize) forKey:@"rows"];
    
    [self startRequestWithParams:dic];
    
}

- (void)delegateSuccessWithCommand:(ApiCommand *)command reformedData:(id)reformedData {
    NSInteger reqPage = [[command.parameters objectForKey:@"page"] integerValue];
    
    if ([self isSuccessedRequestWithCommand:command reformedData:reformedData]) {
        if (reqPage == START_PAGE) {
            self.page = START_PAGE;
            if (self.delegate && [self.delegate respondsToSelector:@selector(api:successWithCommand:responseObject:)]) {
                [self.delegate api:self successWithCommand:command responseObject:reformedData];
            }
        } else if (reqPage > START_PAGE) {
            self.page ++;
            if (self.delegate && [self.delegate respondsToSelector:@selector(api:loadMoreSuccessWithCommand:responseObject:)]) {
                [self.delegate api:self loadMoreSuccessWithCommand:command responseObject:reformedData];
            }
        }
        
        BOOL hasMore = [self hasMoreWithReformedData:reformedData];
        if (!hasMore) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(api:loadMoreEndWithCommand:)]) {
                [self.delegate api:self loadMoreEndWithCommand:command];
            }
        }
    } else {
        [self delegateFailedWithCommand:command error:nil];
    }
}

- (void)delegateFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    NSInteger reqPage = [[command.parameters objectForKey:@"page"] integerValue];
    
    if (reqPage == START_PAGE) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(api:failedWithCommand:error:)]) {
            [self.delegate api:self failedWithCommand:command error:error];
        }
    } else if (reqPage > START_PAGE) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(api:loadMoreFailedWithCommand:error:)]) {
            [self.delegate api:self loadMoreFailedWithCommand:command error:error];
        }
    }
}



#pragma mark -
- (BOOL)hasMoreWithReformedData:(id)reformedData {
    if ([reformedData isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)reformedData;
        return array.count > 0;
    }
    return NO;
}

@end
