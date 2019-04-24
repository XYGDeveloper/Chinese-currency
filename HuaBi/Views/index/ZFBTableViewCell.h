//
//  ZFBTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/9/13.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
@class itemModel;
@class ListModel;
@interface ZFBTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UIImageView *coinType;
@property (weak, nonatomic) IBOutlet UILabel *coinName;
@property (weak, nonatomic) IBOutlet UILabel *desPre;
@property (weak, nonatomic) IBOutlet UILabel *crePre;
@property (weak, nonatomic) IBOutlet UILabel *pre;

- (void)refreshWith:(itemModel *)model indexPath:(NSIndexPath *)indexpath;

- (void)refreshWith:(ListModel *)model;


@end
