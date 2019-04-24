//
//  YWCircleSpaceController.h
//  ywshop
//
//  Created by 周勇 on 2017/11/6.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"


typedef enum new
{
    YWCircleSpaceControllerMine,
    YWCircleSpaceControllerOther
    
}YWCircleSpaceControllerType;

@interface YWCircleSpaceController : YJBaseViewController

/**  0 我的,  1 别人的  */
@property(nonatomic,assign)YWCircleSpaceControllerType type;

@property(nonatomic,copy)NSString *memberId;



@end
