//
//  YJUserInfo.h
//  YJOTC
//
//  Created by 周勇 on 2017/12/23.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,AuthenticationType){
    AuthenticationTypeNot       =-1,
    AuthenticationTypeRejected  =0,
    AuthenticationTypeAuthented =1,
    AuthenticationTypeAuditing  =2,
};

@interface YJUserInfo : NSObject


/**  用户id  */
@property(nonatomic,assign)NSInteger uid;
/**  token  */
@property(nonatomic,copy)NSString * token;
/**  头像  */
@property(nonatomic,copy)NSString * avatar;
/**  token  */
@property(nonatomic,copy)NSString * inviter_id;
/**  token  */
@property(nonatomic,copy)NSString * user_uuid;

@property(nonatomic,copy)NSString * phone;

@property(nonatomic,copy)NSString * email;
/**  token  */
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString *user_name;

/**  昵称  */
@property(nonatomic,copy)NSString *nick;//user_nick

@property(nonatomic,copy)NSString *user_nick;

/**  环信id  */
@property(nonatomic,copy)NSString * hx_username;
/**  环信密码  */
@property(nonatomic,copy)NSString * hx_password;

@property(nonatomic,copy)NSString * user_id;

@property(nonatomic,copy)NSString * user_head;
@property(nonatomic,copy)NSString * verify_state;
@property(nonatomic,copy)NSString * jm_phone;


@property(nonatomic, copy, readonly)NSString * emailOrPhone;
@property(nonatomic, copy, readonly)NSString * seurityName;
- (NSString *)seurityEmailOrPhone;


/**  是否是商家  */
@property(nonatomic,assign)BOOL isSeller;








+(YJUserInfo *)userInfo;

-(void)saveUserInfo;

-(void)clearUserInfo;


@end
