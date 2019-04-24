//
//  BountModel.h
//  YJOTC
//
//  Created by l on 2018/9/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface list1Model : NSObject

@property (nonatomic,copy)NSString *add_time;
@property (nonatomic,copy)NSString *num;
@property (nonatomic,copy)NSString *mining_type;

@end

@interface BountModel : NSObject
@property (nonatomic,copy)NSString *count;
@property (nonatomic,strong)NSArray *list;

@end
