//
//  YWCircleDetailTopCell.h
//  ywshop
//
//  Created by 周勇 on 2017/11/2.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DistrictWidth (kScreenW - 17 - 64)



@interface YWCircleDetailTopCell : UITableViewCell

@property(nonatomic,strong)YWDynamicModel *model;

@property (weak, nonatomic) IBOutlet UIButton *attentionButton;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIView *picView;


@end
