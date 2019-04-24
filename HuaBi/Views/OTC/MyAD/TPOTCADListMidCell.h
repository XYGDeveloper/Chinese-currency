//
//  TPOTCADListMidCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPOTCMyADModel.h"

@interface TPOTCADListMidCell : UITableViewCell


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midMargin;

@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalMoney;

@property (weak, nonatomic) IBOutlet UILabel *exchangeVolumeLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftVolumeLabel;

@property (weak, nonatomic) IBOutlet UILabel *exchangeMoney;
@property (weak, nonatomic) IBOutlet UILabel *leftMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIImageView *icon1;
@property (weak, nonatomic) IBOutlet UIImageView *icon2;
@property (weak, nonatomic) IBOutlet UIImageView *icon3;



@property(nonatomic,strong)TPOTCMyADModel *model;


@end
