//
//  MyrecommandTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
@class reListModel;
@class list1Model;
@class mlistModel;
@interface MyrecommandTableViewCell_old : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *quyu;

- (void)refreshWithModel:(reListModel *)model;
- (void)refreshWithModel1:(list1Model *)model;
- (void)refreshWithModel2:(mlistModel *)model;

@end
