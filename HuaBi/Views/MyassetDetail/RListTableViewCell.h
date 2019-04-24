//
//  RListTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/9/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *eType;  //兑换类型

@property (weak, nonatomic) IBOutlet UILabel *eStatus; //兑换状态

@property (weak, nonatomic) IBOutlet UILabel *address; //地址
@property (weak, nonatomic) IBOutlet UILabel *addressTag; //地址标签

@property (weak, nonatomic) IBOutlet UILabel *recorderType; //记录类型


@property (weak, nonatomic) IBOutlet UILabel *countLabel; //数量

@property (weak, nonatomic) IBOutlet UILabel *realKC;   //实际扣除

@property (weak, nonatomic) IBOutlet UILabel *shouxu;  //手续费

@property (weak, nonatomic) IBOutlet UILabel *tradeTime;  //交易日期



@end
