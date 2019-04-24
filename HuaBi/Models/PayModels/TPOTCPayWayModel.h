//
//  TPOTCPayWayModel.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPOTCPayWayModel : NSObject


@property(nonatomic,copy)NSString * pid;
@property(nonatomic,copy)NSString * bankname;
@property(nonatomic,copy)NSString * cardnum;
@property(nonatomic,copy)NSString * img;
@property(nonatomic,copy)NSString * status;
@property(nonatomic,copy)NSString * name;
/**  支行名称  */
@property(nonatomic,copy)NSString * inname;
/**  银行名称  */
@property(nonatomic,copy)NSString * bname;
/*   银行id  */
@property(nonatomic,copy)NSString * bank_id;

@property(nonatomic,copy)NSString * type;


@property(nonatomic,assign)BOOL isSelected;



@end
