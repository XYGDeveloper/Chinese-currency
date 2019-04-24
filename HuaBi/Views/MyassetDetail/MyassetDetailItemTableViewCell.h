//
//  MyassetDetailItemTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@class user_order;
@interface MyassetDetailItemTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *coinName;

@property (weak, nonatomic) IBOutlet UILabel *sellType;  //买卖类型
@property (weak, nonatomic) IBOutlet UILabel *WTstatus;  //委托状态
@property (weak, nonatomic) IBOutlet UILabel *timeLabel; //时间
@property (weak, nonatomic) IBOutlet UILabel *timeContentLabel; //时间内容
@property (weak, nonatomic) IBOutlet UILabel *cjLabel;  //成交总额
@property (weak, nonatomic) IBOutlet UILabel *cjcontent; //成交总额内容

@property (weak, nonatomic) IBOutlet UILabel *rightBottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *wtPriceLabel; //委托价
@property (weak, nonatomic) IBOutlet UILabel *wtjContent;  //委托价内容
@property (weak, nonatomic) IBOutlet UILabel *cjjjLabel;  //成交均价
@property (weak, nonatomic) IBOutlet UILabel *cjjjContent; //成交均价内容
@property (weak, nonatomic) IBOutlet UILabel *wtlLabel;  //委托量
@property (weak, nonatomic) IBOutlet UILabel *wtlContent; //委托量内容

@property (weak, nonatomic) IBOutlet UILabel *cjlLbael; //成交量

@property (weak, nonatomic) IBOutlet UILabel *cjlContentLabel; //成交量内容

- (void)refreshWithModel:(user_order *)model;

@end


