//
//  TPOTCPostStatusController.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/30.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"


typedef enum {
    TPOTCPostStatusControllerTypeSuccess,//成功
    TPOTCPostStatusControllerTypeWait//等待
}TPOTCPostStatusControllerType;

@interface TPOTCPostStatusController : YJBaseViewController

@property(nonatomic,assign)TPOTCPostStatusControllerType type;




@end
