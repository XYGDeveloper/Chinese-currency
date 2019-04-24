//
//  HBReleaseRecordListViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBReleaseRecordListViewController : YJBaseViewController

@property (nonatomic, copy) NSString *ID;

+ (instancetype)fromStoryboard;

@end

NS_ASSUME_NONNULL_END
