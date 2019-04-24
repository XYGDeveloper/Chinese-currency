//
//  MineModel.h
//  YJOTC
//
//  Created by l on 2018/9/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mlistModel : NSObject
@property (nonatomic,copy)NSString *amount;
@property (nonatomic,copy)NSString *create_time;
@property (nonatomic,copy)NSString *currency_field;
@property (nonatomic,copy)NSString *currency_id;
@property (nonatomic,copy)NSString *current;
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *kok_num;
@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *operation;
@property (nonatomic,copy)NSString *result;
@property (nonatomic,copy)NSString *ralation_id;
@property (nonatomic,copy)NSString *remark;
@property (nonatomic,copy)NSString *serial_no;
@property (nonatomic,copy)NSString *type;
@end

@interface MineModel : NSObject
@property (nonatomic,copy)NSString *total;
@property (nonatomic,strong)NSArray *list;
@end
