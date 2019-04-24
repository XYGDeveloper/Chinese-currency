//
//  MyAsetTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@class current_userModel, MyAsetTableViewCell;

@protocol MyAsetTableViewCellDelegate <NSObject>

- (void)myAsetTableViewCell:(MyAsetTableViewCell *)cell showTipsWithModel:(current_userModel *)model;

@end

@interface MyAsetTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgview;

@property (weak, nonatomic) IBOutlet UILabel *coinType; //货币

@property (weak, nonatomic) IBOutlet UILabel *rightTopLabel;//数量
@property (weak, nonatomic) IBOutlet UILabel *sumLabel; //可用

@property (weak, nonatomic) IBOutlet UILabel *freezeLabel;

@property (weak, nonatomic) IBOutlet UILabel *availableLabel;

@property (weak, nonatomic) IBOutlet UILabel *sumContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *freezecontent;
@property (weak, nonatomic) IBOutlet UILabel *avaliableContentLabel;

- (void)refreshWithModel:(current_userModel *)model;

@property (nonatomic, weak) id<MyAsetTableViewCellDelegate> delegate;

@end

