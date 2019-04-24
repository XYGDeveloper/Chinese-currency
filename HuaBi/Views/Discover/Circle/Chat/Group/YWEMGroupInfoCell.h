//
//  YWEMGroupInfoCell.h
//  ywshop
//
//  Created by 周勇 on 2017/12/8.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWEMGroupInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@property(nonatomic,assign)BOOL isOwner;


@end
