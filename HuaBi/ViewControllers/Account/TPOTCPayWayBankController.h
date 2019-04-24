//
//  TPOTCPayWayBankController.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"
#import "TPOTCPayWayModel.h"

typedef enum {
    TPOTCPayWayBankControllerTypeAdd,
    TPOTCPayWayBankControllerTypeEdit,
    TPOTCPayWayBankControllerTypeList
    
}TPOTCPayWayBankControllerType;



@interface TPOTCPayWayBankController : YJBaseViewController

@property(nonatomic,assign)TPOTCPayWayBankControllerType type;

@property(nonatomic,strong)TPOTCPayWayModel *model;

//新增支付方式入口
@property(nonatomic,assign)BOOL isNew;


@end
