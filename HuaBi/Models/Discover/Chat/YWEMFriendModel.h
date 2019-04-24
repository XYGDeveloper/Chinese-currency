//
//  YWEMFriendModel.h
//  ywshop
//
//  Created by 周勇 on 2017/12/7.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWEMFriendModel : NSObject

@property(nonatomic,copy)NSString *member_avatar;
@property(nonatomic,copy)NSString *member_nick;
@property(nonatomic,copy)NSString *member_id;
@property(nonatomic,assign)BOOL isSelected;

@end

