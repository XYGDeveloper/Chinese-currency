//
//  HBReleaseRecordModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBReleaseRecordModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *release_num;
@property (nonatomic, copy) NSString *add_time;//
@property (nonatomic, copy) NSString *currency_name;
@end

NS_ASSUME_NONNULL_END
