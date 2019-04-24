

//
//  YWCircleGroupModel.m
//  ywshop
//
//  Created by 周勇 on 2017/10/30.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWCircleGroupModel.h"
NSString *saveCircleKey = @"saveCircleKey";

@implementation YWCircleGroupModel


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.group_id = [aDecoder decodeObjectForKey:@"group_id"];
        self.group_name = [aDecoder decodeObjectForKey:@"group_name"];
        self.group_logo = [aDecoder decodeObjectForKey:@"group_logo"];
        self.note_count = [aDecoder decodeObjectForKey:@"note_count"];
        self.popularity_count = [aDecoder decodeObjectForKey:@"popularity_count"];
        self.group_city = [aDecoder decodeObjectForKey:@"group_city"];
        self.city_name = [aDecoder decodeObjectForKey:@"city_name"];

    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    //    NSLog(@"调用了encodeWithCoder:方法");
    [aCoder encodeObject:self.group_id forKey:@"group_id"];
    [aCoder encodeObject:self.group_name forKey:@"group_name"];
    [aCoder encodeObject:self.group_logo forKey:@"group_logo"];
    [aCoder encodeObject:self.note_count forKey:@"note_count"];
    [aCoder encodeObject:self.popularity_count forKey:@"popularity_count"];
    [aCoder encodeObject:self.group_city forKey:@"group_city"];
    [aCoder encodeObject:self.city_name forKey:@"city_name"];
    
}

+(instancetype)circleGroupModel
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSString stringWithFormat:@"%@",[kUserDefaults objectForKey:saveCircleKey]] appendDocument]];
}

-(void)saveCirclrGroupModel
{
    [NSKeyedArchiver archiveRootObject:self toFile:[[NSString stringWithFormat:@"%@",[kUserDefaults objectForKey:saveCircleKey]] appendDocument]];
    
}



@end
