//
//  YWMineNickNameController.h
//  ywshop
//
//  Created by 周勇 on 2017/11/16.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

//typedef void(^nickName)(NSString *);

@interface YWMineNickNameController : YJBaseViewController

/**  0 修改昵称  1修改群名  */
@property(nonatomic,assign)NSInteger type;


@property(nonatomic,copy)NSString *niceName;


//@property(nonatomic,copy)nickName nick;
@end
