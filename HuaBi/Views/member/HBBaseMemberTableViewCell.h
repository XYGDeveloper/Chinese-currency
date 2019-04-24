//
//  HBBaseMemberTableViewCell.h
//  HuaBi
//
//  Created by XI YANGUI on 2018/10/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBBaseMemberTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTrailingConstraint;

@end
