//
//  HBHomeIndexModel.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - flash -

@interface Flash: NSObject
@property (nonatomic ,copy)NSString * title;
@property (nonatomic ,copy)NSString * pic;
@property (nonatomic ,copy)NSString * link;
@end

#pragma mark - notice -

@interface Notice: NSObject
@property (nonatomic ,copy)NSString * article_id;
@property (nonatomic ,copy)NSString * title;
@end

#pragma mark - zixun -

@interface Zixun: NSObject
@property (nonatomic ,copy)NSString * article_id;
@property (nonatomic ,copy)NSString * art_pic;
@property (nonatomic ,copy)NSString * add_time;
@property (nonatomic ,copy)NSString * title;
@end

@interface HBHomeIndexModel : NSObject

@property (nonatomic ,copy)NSArray<Flash *> * flash;
@property (nonatomic ,strong)Notice * notice;
@property (nonatomic ,copy)NSArray<Zixun *> * zixun;

@end

NS_ASSUME_NONNULL_END
