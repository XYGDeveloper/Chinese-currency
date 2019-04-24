//
//  TPOTCOrderDetailController.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"


typedef enum {
    TPOTCOrderDetailControllerTypeCancel,//取消
    TPOTCOrderDetailControllerTypePaid,//已付款
    TPOTCOrderDetailControllerTypeNotPay,//未付款
    TPOTCOrderDetailControllerTypeDone,//已完成
    TPOTCOrderDetailControllerTypeAppleal//申诉中

}TPOTCOrderDetailControllerType;




/**  我的订单->详情  */

@interface TPOTCOrderDetailController : YJBaseViewController

@property(nonatomic,assign)TPOTCOrderDetailControllerType type;

@property(nonatomic,strong)TPOTCTradeListModel *model;


@property(nonatomic,copy)NSString * tradeID;


/**  从BuyConfirmOrderVC进来  */
@property(nonatomic,assign)BOOL isFromBuyConfirmOrderVC;


@end
