//
//  YWEMFriendManager.h
//  ywshop
//
//  Created by 周勇 on 2017/11/25.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWEMFriendManager : NSObject

+ (instancetype)sharedInstance;

-(void)saveFriendWith:(YJUserInfo *)model;

-(YJUserInfo *)getInfoWithUserID:(NSInteger)uid;

@end
