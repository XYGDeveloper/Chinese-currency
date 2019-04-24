//
//  MybounsHeaderTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/9/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^starttime)(void);
typedef void (^endOftime)(void);
typedef void (^queryOf)(void);

@interface MybounsHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *countDes;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIButton *startTime;

@property (weak, nonatomic) IBOutlet UIButton *endTime;

@property (weak, nonatomic) IBOutlet UIButton *qButton;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (nonatomic,strong)starttime startAction;
@property (nonatomic,strong)endOftime endAction;
@property (nonatomic,strong)queryOf queryAction;

@end
