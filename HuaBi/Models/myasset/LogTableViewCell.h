//
//  LogTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/10/10.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FinModel;
@interface LogTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (weak, nonatomic) IBOutlet UILabel *bdLabel;

@property (weak, nonatomic) IBOutlet UILabel *zrLabel;

@property (weak, nonatomic) IBOutlet UILabel *jfLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeContent;
@property (weak, nonatomic) IBOutlet UILabel *desContent;
@property (weak, nonatomic) IBOutlet UILabel *bdContent;
@property (weak, nonatomic) IBOutlet UILabel *zrContent;
@property (weak, nonatomic) IBOutlet UILabel *jfContent;
@property (weak, nonatomic) IBOutlet UILabel *timeContent;


- (void)refreshWIthModel:(FinModel *)model;


@end

NS_ASSUME_NONNULL_END
