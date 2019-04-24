//
//  IndexNoticeTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/9/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
@class articleModel;
@interface IndexNoticeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
- (void)refreshWithModel:(articleModel *)model;

@end
