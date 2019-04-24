//
//  HeaderTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/9/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *headImg;

@property (weak, nonatomic) IBOutlet UILabel *uid;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
