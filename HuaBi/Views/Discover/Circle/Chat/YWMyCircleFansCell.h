//
//  YWMyCircleFansCell.h
//  ywshop
//
//  Created by 周勇 on 2017/11/25.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWFansModel.h"

@interface YWMyCircleFansCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property(nonatomic,strong)YWFansModel *model;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
