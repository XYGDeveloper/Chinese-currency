//
//  UpdateVersionManager.h
//  YJOTC
//
//  Created by l on 2018/9/18.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYZUpdateView.h"
@interface UpdateVersionManager : NSObject<BaseMessageViewDelegate>

@property (nonatomic,strong)NSString *url;

+ (instancetype)sharedUpdate;

- (void)versionControl;

- (void)versionControlWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;

@end
