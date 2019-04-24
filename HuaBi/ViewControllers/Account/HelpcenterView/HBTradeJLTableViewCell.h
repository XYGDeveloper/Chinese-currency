//
//  HBTradeJLTableViewCell.h
//  HuaBi
//
//  Created by l on 2018/10/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^toPay)(void);
@class HBGetCListModel;
@interface HBTradeJLTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;               //time
@property (weak, nonatomic) IBOutlet UILabel *timeContent;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;               //类别
@property (weak, nonatomic) IBOutlet UILabel *typeContent;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberContent;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *countContent;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceContent;
@property (weak, nonatomic) IBOutlet UILabel *sumPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumPriceContent;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusContent;
@property (weak, nonatomic) IBOutlet UILabel *operationLabel;
@property (weak, nonatomic) IBOutlet UIButton *operationContent;

@property (nonatomic,strong)toPay pay;
- (void)refreshWithModel:(HBGetCListModel *)model;

@end
