//
//  TPOTCADCurrentTopCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPOTCMyADModel.h"

@interface TPOTCADCurrentTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIButton *msgButton;

@property (weak, nonatomic) IBOutlet UILabel *lienView;

@property(nonatomic,strong)TPOTCMyADModel *model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lftMargin;

@end
