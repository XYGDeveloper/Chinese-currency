//
//  HBExchangeModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBExchangeModel.h"

@interface HBExchangeModel ()

@property (nonatomic, copy, readwrite) NSString *statusString;
@property (nonatomic, strong, readwrite) UIColor *statusColor;

@end

@implementation HBExchangeModel

- (NSString *)statusString {
    if (!_statusString) {
        switch (self.status) {
            case -1:
                _statusString = @"兌換失敗";
                break;
            case 0:
                _statusString = @"審核中";
                break;
            case 1:
                _statusString = @"兌換成功";
                break;
            default:
                break;
        }
    }
    return _statusString;
}

- (UIColor *)statusColor {
    if (!_statusColor) {
        switch (self.status) {
            case -1:
            case 0:
                _statusColor = kColorFromStr(@"#4173C8");
                break;
            case 1:
                _statusColor = kColorFromStr(@"#DEE5FF");
                break;
            default:
                break;
        }
        
    }
    
    return _statusColor;
}

@end
