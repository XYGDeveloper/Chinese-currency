//
//  ICNNationalityModel.h
//  icn
//
//  Created by 周勇 on 2018/1/31.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICNNationalityModel : NSObject

@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * phone_code;
@property(nonatomic,copy)NSString * countrycode;
@property(nonatomic,assign)BOOL isSelected;

- (BOOL)isChina;

@end
