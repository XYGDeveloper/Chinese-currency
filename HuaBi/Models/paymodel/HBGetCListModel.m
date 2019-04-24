//
//  HBGetCListModel.m
//  HuaBi
//
//  Created by XI YANGUI on 2018/10/25.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBGetCListModel.h"

@implementation HBGetCListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"orderStatus" : @"_status",
             };
}
@end
