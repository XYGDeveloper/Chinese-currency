//
//  HBHomeNewsCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBHomeNewsCell.h"
#import "HBHomeIndexModel.h"
#import "UIImageView+WebCache.h"

@interface HBHomeNewsCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

@end

@implementation HBHomeNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.containerView.backgroundColor = kThemeColor;
}


#pragma mark - Setters

- (void)setNews:(Zixun *)news {
    _news = news;
    
    self.myTitleLabel.text = _news.title;
    self.timeLabel.text = _news.add_time;
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:_news.art_pic]];
}

@end
