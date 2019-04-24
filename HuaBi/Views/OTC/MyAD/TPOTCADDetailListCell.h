//
//  TPOTCADDetailListCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPOTCSingleOrderModel.h"


@interface TPOTCADDetailListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lineView;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *currencyName;

@property (weak, nonatomic) IBOutlet UILabel *cnyLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@property (weak, nonatomic) IBOutlet UIButton *msgButton;

@property(nonatomic,strong)TPOTCSingleOrderModel *model;



@end
