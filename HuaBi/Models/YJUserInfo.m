//
//  YJUserInfo.m
//  YJOTC
//
//  Created by 周勇 on 2017/12/23.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YJUserInfo.h"
#import "HBUserInfoCache.h"

@implementation YJUserInfo

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"uid" :@"member_id",
             @"avatar" :@"user_head",
             @"phone" :@"phone",
             @"token" :@"token",
             @"name" :@"name",
             @"isSeller" : @"is_seller",
             @"user_name" : @"user_name",
             @"user_head" : @"user_head",
             @"user_uuid" : @"user_uuid",
             @"verify_state" : @"verify_state",
             };
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.uid = [aDecoder decodeIntegerForKey:@"uid"];
        //        self.pid = [aDecoder decodeObjectForKey:@"pid"];
        //        self.account = [aDecoder decodeObjectForKey:@"account"];
        self.user_name = [aDecoder decodeObjectForKey:@"user_name"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.user_head = [aDecoder decodeObjectForKey:@"user_head"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.hx_password = [aDecoder decodeObjectForKey:@"hx_password"];
        self.hx_username = [aDecoder decodeObjectForKey:@"hx_username"];
        self.inviter_id = [aDecoder decodeObjectForKey:@"inviter_id"];
        self.user_uuid = [aDecoder decodeObjectForKey:@"user_uuid"];
        self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
        self.verify_state = [aDecoder decodeObjectForKey:@"verify_state"];
        self.isSeller = [aDecoder decodeBoolForKey:@"isSeller"];
//        self.ename = [aDecoder decodeObjectForKey:@"ename"];
        self.nick = [aDecoder decodeObjectForKey:@"nick"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    //    NSLog(@"调用了encodeWithCoder:方法");
    [aCoder encodeObject:self.name forKey:@"name"];
    //    [aCoder encodeObject:self.pid forKey:@"pid"];
    [aCoder encodeInteger:self.uid forKey:@"uid"];
    //    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.user_name forKey:@"user_name"];
    [aCoder encodeObject:self.user_head forKey:@"user_head"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.hx_username forKey:@"hx_username"];
    [aCoder encodeObject:self.hx_password forKey:@"hx_password"];
    [aCoder encodeObject:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.inviter_id forKey:@"inviter_id"];
    [aCoder encodeObject:self.user_uuid forKey:@"user_uuid"];
    [aCoder encodeObject:self.verify_state forKey:@"verify_state"];
    [aCoder encodeObject:self.nick forKey:@"nick"];
    [aCoder encodeBool:self.isSeller forKey:@"isSeller"];
//    [aCoder encodeObject:self.ename forKey:@"ename"];

}

-(void)saveUserInfo
{
    BOOL success = [NSKeyedArchiver archiveRootObject:self toFile:[[NSString stringWithFormat:@"%zd",[kUserDefaults integerForKey:kUserIDKey]] appendDocument]];
    NSLog(@"归档结果---<  %d  >",success);
     HBUserInfoCache *userInfoCache = [HBUserInfoCache sharedInstance];
    userInfoCache.userInfo = self;
}

- (NSInteger)uid {
    if (_uid == 0) {
        return [self.user_id integerValue];
    }
    return _uid;
}


- (void)setUser_nick:(NSString *)user_nick {
    _user_nick = user_nick;
    if (_user_nick.length > 0) {
        self.nick = user_nick;
    }
}


+(YJUserInfo *)userInfo
{
    HBUserInfoCache *userInfoCache = [HBUserInfoCache sharedInstance];
    YJUserInfo *userInfo = userInfoCache.userInfo;
    if (userInfo) {
        return userInfo;
    } else {
        YJUserInfo *model = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSString stringWithFormat:@"%zd",[kUserDefaults integerForKey:kUserIDKey]] appendDocument]];
        userInfoCache.userInfo = model;
        return model;
    }
    
}
-(void)clearUserInfo
{
    YJUserInfo *model = kUserInfo;
    model.token = @"";
    //    model.account = @"";
    model.uid = 0;
    model.phone = @"";
    model.email = @"";
    model.user_head = @"";
    model.name = @"";
    model.user_name = @"";
    model.nick = nil;
    [model saveUserInfo];
}

- (void)setNick:(NSString *)nick {
    _nick = nick;
}

- (NSString *)emailOrPhone {
    if (self.phone.length > 0) {
        return self.phone;
    } else if (self.email.length > 0) {
        return self.email;
    }
    
    return @"";
}

- (NSString *)seurityName {
    if (self.nick.length > 0) {
        return self.nick;
    }
    return [self seurityEmailOrPhone];
}

- (NSString *)seurityEmailOrPhone {
    if (self.emailOrPhone.length < 7) {
        return self.emailOrPhone;
    }
    return [self.emailOrPhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}


@end
