//
//  RecommandModel.h
//  YJOTC
//
//  Created by l on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface reListModel : NSObject
@property (nonatomic,copy)NSString *level;
@property (nonatomic,copy)NSString *account;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *email;
@property (nonatomic,copy)NSString *reg_time;
@property (nonatomic,copy)NSString *child_id;
@property (nonatomic,copy)NSString *add_time;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *nick;
@property (nonatomic,copy)NSString *tier;
@end

@interface RecommandModel : NSObject
@property (nonatomic,copy)NSString *count;
@property (nonatomic,strong)NSArray *list;

@end
