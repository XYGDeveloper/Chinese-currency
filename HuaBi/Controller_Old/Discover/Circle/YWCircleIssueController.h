//
//  YWCircleIssueController.h
//  ywshop
//
//  Created by 周勇 on 2017/10/30.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"
#import "YWCircleGroupModel.h"


@interface YWCircleIssueController : YJBaseViewController
/**  0 视频  1 照片/拍摄  */
@property(nonatomic,assign)NSInteger type;

@property(nonatomic,strong)UIImage *thumbnail;

@property(nonatomic,copy)NSString * videoPath;

@property(nonatomic,assign)BOOL hasVideo;

@property(nonatomic,strong)YWCircleGroupModel *groupModel;


@end
