//
//  TPOTCMyADModel.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/30.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCMyADModel.h"

@interface TPOTCMyADModel ()

@property(nonatomic, copy, readwrite) NSString *statusString;
@property (nonatomic, strong, readwrite) UIColor *statusColor;

@end

@implementation TPOTCMyADModel

- (UIColor *)typeColor {
    return [self.type isEqualToString:@"sell"] ? kOrangeColor : kGreenColor;
}

- (NSString *)statusString {
    if (!_statusString) {
        
        switch (self.status.intValue) {
            case 0:
            case 1:
                _statusString = kLocat(@"OTC_view_dealing");
                break;
            case 2:
                _statusString = kLocat(@"OTC_view_sellover");
                break;
            case 3:
                _statusString = kLocat(@"OTC_view_selfcancel");
                break;
            default:
                break;
        }
    }
    
    return _statusString;
}

- (UIColor *)statusColor {
    if (!_statusColor) {
        
        switch (self.status.intValue) {
            case 0:
            case 1:
                _statusColor = kColorFromStr(@"#4173C8");
                break;
            default:
                _statusColor = kColorFromStr(@"#7582A4");
                break;
        }
    }
    
    return _statusColor;
}

@end
