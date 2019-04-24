//
//  HBSubscribeCell.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBSubscribeModel;
typedef void(^HBSubscribeCellTappedSubscribeBlock)(HBSubscribeModel *model);


@interface HBSubscribeCell : UITableViewCell

@property (nonatomic, strong) HBSubscribeCellTappedSubscribeBlock tappedSubscribeBlock;

@property (nonatomic, strong) HBSubscribeModel *model;

@end
