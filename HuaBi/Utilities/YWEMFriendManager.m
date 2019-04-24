//
//  YWEMFriendManager.m
//  ywshop
//
//  Created by 周勇 on 2017/11/25.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWEMFriendManager.h"

static YWEMFriendManager *sharedInstance = nil;

@implementation YWEMFriendManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)saveFriendWith:(YJUserInfo *)model;
{
    NSString *kSaveFriendInfoKey = [NSString stringWithFormat:@"kSaveFriendInfoKey%zd",kUserInfo.uid];
    
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:[kSaveFriendInfoKey appendDocument]];
    NSMutableArray *Marr = [NSMutableArray arrayWithArray:arr];
    
    for (YJUserInfo *obj in Marr) {
        if (obj.uid == model.uid) {
            [Marr removeObject:obj];
            break;
        }
    }
    [Marr addObject:model];
    
    [NSKeyedArchiver archiveRootObject:Marr.mutableCopy toFile:[kSaveFriendInfoKey appendDocument]];
}

-(YJUserInfo *)getInfoWithUserID:(NSInteger)uid;
{
    NSString *kSaveFriendInfoKey = [NSString stringWithFormat:@"kSaveFriendInfoKey%zd",kUserInfo.uid];
    NSArray *resultArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[kSaveFriendInfoKey appendDocument]];
    if (resultArray.count == 0) {
        return nil;
    }else{
        for (YJUserInfo *model in resultArray) {
            if (model.uid == uid) {
                return model;
            }
        }
    }
    return nil;
}


@end
