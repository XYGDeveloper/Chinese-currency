//
//  ICNNationalityCell.h
//  icn
//
//  Created by 周勇 on 2018/1/31.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ICNNationalityModel.h"


@interface ICNNationalityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *topLine;

@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UIButton *chooseButton;

@property(nonatomic,strong)ICNNationalityModel *model;


@end
