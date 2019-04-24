//
//  YWHomeCanScrollConatineeProtocol.h
//  ywshop
//
//  Created by 前海数交（ZJ） on 2018/8/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

static CGFloat const YWHomeEmptyDataSetDataSourceVerticalyOffset = -80.;
static NSString *const YWHomeContaineeViewControllerLeaveTop = @"YWHomeContaineeViewControllerLeaveTop";

typedef void(^HomeContaineeVCRequestDidCompleteBlock)(NSError *error);

@protocol YWHomeCanScrollConatineeProtocol<NSObject>

@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, copy) HomeContaineeVCRequestDidCompleteBlock requestDidComplete;

- (void)refresh;

@end
