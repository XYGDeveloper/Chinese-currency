//
//  YWCircleGroupModel.h
//  ywshop
//
//  Created by 周勇 on 2017/10/30.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWCircleGroupModel : NSObject<NSCoding>

@property(nonatomic,copy)NSString *group_id;
@property(nonatomic,copy)NSString *group_name;
@property(nonatomic,copy)NSString *group_logo;
@property(nonatomic,copy)NSString *note_count;
@property(nonatomic,copy)NSString *popularity_count;
@property(nonatomic,copy)NSString *group_city;
@property(nonatomic,copy)NSString *city_name;


+(instancetype)circleGroupModel;

-(void)saveCirclrGroupModel;

@end
