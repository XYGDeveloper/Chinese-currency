//
//  HBNonomalTableViewCell.h
//  HuaBi
//
//  Created by l on 2019/2/23.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HBChongCurrencyRecorModel;
typedef void (^tocancel)(void);
typedef void (^todetail)(void);

@interface HBNonomalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong)tocancel cancel;
@property (nonatomic,strong)todetail detail;

- (void)refreshWithModel:(HBChongCurrencyRecorModel *)model;


@property (weak, nonatomic) IBOutlet UIButton *cancelAction;


@end
