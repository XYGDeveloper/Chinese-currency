//
//  HBNoticeTableViewCell.m
//  HuaBi
//
//  Created by l on 2018/10/18.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBNoticeTableViewCell.h"
#import "YTDetailModel.h"
@implementation HBNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = kThemeColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
    
}

- (void)refreshWithMOdel:(YTDetailModel *)model{
    self.titleLabel.text = model.title;
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"[ _`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]|\n|\r|\t"];
    self.contentLabel.text = [model.content stringByTrimmingCharactersInSet:set];
    self.timeLabel.text = [self timestampSwitchTime:[model.add_time integerValue] andFormatter:@"yyyy-MM-dd HH:mm:ss"];
}

@end
