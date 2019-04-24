//
//  HBGetCurrenInfoModel.h
//  HuaBi
//
//  Created by l on 2019/2/22.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface addressModel : NSObject
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *qianbao_url;
@end

@interface HBGetCurrenInfoModel : NSObject
@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *currency_id;
@property (nonatomic,copy)NSString *num;
@property (nonatomic,copy)NSString *currency_name;
@property (nonatomic,copy)NSString *currency_mark;
@property (nonatomic,copy)NSString *currency_all_tibi;
@property (nonatomic,copy)NSString *currency_min_tibi;
@property (nonatomic,copy)NSString *tcoin_fee;
@property (nonatomic,strong)addressModel *address;

@end
