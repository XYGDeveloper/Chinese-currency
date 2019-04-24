//
//  YWEMFriendRequestCell.h
//  ywshop
//
//  Created by 周勇 on 2017/12/5.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWEMFriendRequestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@property (weak, nonatomic) IBOutlet UILabel *topLine;

@end
