//
//  YTTradeUserOrderModel.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTTradeUserOrderModel.h"

@interface YTTradeUserOrderModel ()

@property (nonatomic ,copy, readwrite) NSString *statusString;
@property (nonatomic ,copy, readwrite) NSString *comMarkName;

@end

@implementation YTTradeUserOrderModel

- (NSString *)statusString {
    if (!_statusString) {
        switch (self.status) {
            case YTTradeUserOrderModelStatusCancel:
                _statusString = kLocat(@"Canceled");
                break;
            case YTTradeUserOrderModelStatusPending:
                _statusString = kLocat(@"Pending_order");
                break;
            case YTTradeUserOrderModelStatusDoneOfPart:
                _statusString = kLocat(@"Part_Done");
                break;
            case YTTradeUserOrderModelStatusDone:
                _statusString = kLocat(@"Trade_Done");
                break;
        }
    }
    return _statusString;
}

- (NSString *)comMarkName {
    if (!_comMarkName) {
        _comMarkName = [NSString stringWithFormat:@"%@/%@", self.currenc_mark ?: @"", self.trade_currency_mark ?: @""];
    }
    
    return _comMarkName;
}

- (BOOL)isDone {
    return self.status == YTTradeUserOrderModelStatusDone;
}

- (UIColor *)typeColor {
    return [self.type isEqualToString:@"sell"] ? kOrangeColor : kGreenColor;
}

@end
