//
//  HBTokenListModel.h
//  HuaBi
//
//  Created by l on 2019/2/21.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBTokenListModel : NSObject
@property (nonatomic,copy)NSString *currency_id;
@property (nonatomic,copy)NSString *currency_name;
@property (nonatomic,copy)NSString *currency_mark;
@property (nonatomic,copy)NSString *currency_all_tibi;
@property (nonatomic,copy)NSString *currency_min_tibi;
@property (nonatomic,copy)NSString *tcoin_fee;

@end

NS_ASSUME_NONNULL_END
