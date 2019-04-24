//
//  YWCircleSpaceTopView.h
//  ywshop
//
//  Created by 周勇 on 2017/11/6.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWCircleSpaceTopView : UIView

@property(nonatomic,strong)NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabrl;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;

@end
