//
//  YWNetworkResultModel.m
//  ywshop
//
//  Created by 前海数交（ZJ） on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YWNetworkResultModel.h"
#import "YTLoginManager.h"

@implementation YWNetworkResultModel

- (BOOL)succeeded {
    return self.code == 10000;
}

- (void)setCode:(NSInteger)code {
    _code = code;
    [YTLoginManager checkIsLogOutByCode:code];
}

- (NSString *)message {
    if (_message) {
        return _message;
    }
    
    return _message ?: [NSString stringWithFormat:@"未知错误，错误码：%@。", @(self.code)];
}

- (NSError *)error {
    if ([self succeeded]) {
        return nil;
    }
    
    return [NSError errorWithDomain:[NSString stringWithFormat:@"%@", @(self.code)] code:self.code userInfo:@{NSLocalizedDescriptionKey : self.message}];
}

@end
