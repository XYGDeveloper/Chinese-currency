//
//  TPOTCOrderListController.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

typedef enum {
    TPOTCOrderListControllerTypeCancel,
    TPOTCOrderListControllerTypePaid,
    TPOTCOrderListControllerTypeNotPay,
    TPOTCOrderListControllerTypeDone,
    TPOTCOrderListControllerTypeAppeal,
    TPOTCOrderListControllerTypeAll

}TPOTCOrderListControllerType;



@interface TPOTCOrderListController : YJBaseViewController<ZJScrollPageViewChildVcDelegate>

@property(nonatomic,assign)TPOTCOrderListControllerType type;

@end
