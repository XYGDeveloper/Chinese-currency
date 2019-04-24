//
//  YWCircleChangeCell.h
//  ywshop
//
//  Created by 周勇 on 2017/10/30.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWCircleGroupModel.h"

@interface YWCircleChangeCell : UITableViewCell

@property(nonatomic,strong)YWCircleGroupModel *model;

@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@property (weak, nonatomic) IBOutlet UILabel *topLine;
@end
