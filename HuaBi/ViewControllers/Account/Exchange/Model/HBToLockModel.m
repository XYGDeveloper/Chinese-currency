//
//  HBToLockModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/20.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBToLockModel.h"

@interface HBToLockModel ()

@property (nonatomic, copy, readwrite) NSString *statusString;

@end

@implementation HBToLockModel

- (NSString *)statusString {
    if (!_statusString) {
        switch (self.status) {
            case 1:
                _statusString = kLocat(@"Locked_successfully");
                break;
            case 2:
                _statusString = kLocat(@"Presented_successfully");
                break;
            default:
                break;
        }
    }
    
    return _statusString;
}

@end
