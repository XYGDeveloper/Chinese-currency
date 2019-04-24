//
//  MyrecommandTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MyrecommandTableViewCell_old.h"
#import "RecommandModel.h"
#import "MineModel.h"
#import "BountModel.h"
@implementation MyrecommandTableViewCell_old

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    
    NSLog(@"1296035591  = %@",confromTimesp);
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    //NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);
    
    return confromTimespStr;
    
}

- (void)refreshWithModel:(reListModel *)model{
    NSString *dataString = [self timestampSwitchTime:[model.add_time intValue] andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSArray *str1 = [dataString componentsSeparatedByString:@" "];
    self.startTime.text = [str1 firstObject];
    self.endTime.text = [str1 lastObject];
    self.typeLabel.text = model.account;
    self.quyu.text = [NSString stringWithFormat:@"M%@",model.tier];
}

- (void)refreshWithModel1:(list1Model *)model{
    NSString *dataString = [self timestampSwitchTime:[model.add_time intValue] andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSArray *str1 = [dataString componentsSeparatedByString:@" "];
    
    self.startTime.text = [str1 firstObject];
    
    self.endTime.text = [str1 lastObject];
    
    if ([model.mining_type isEqualToString:@"3"]) {
        self.typeLabel.text = kLocat(@"k_MymineViewController_top_label_fq");
    }else if([model.mining_type isEqualToString:@"4"]){
        self.typeLabel.text = kLocat(@"k_MymineViewController_top_label_hh");
    }else if([model.mining_type isEqualToString:@"5"]){
        self.typeLabel.text = kLocat(@"k_MymineViewController_top_label_hyjt");
    }else{
        self.typeLabel.text = kLocat(@"k_MymineViewController_top_label_hyfx");
    }
    self.quyu.text = model.num;

}

- (void)refreshWithModel2:(mlistModel *)model{
    NSString *dataString = [self timestampSwitchTime:[model.create_time intValue] andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSArray *str1 = [dataString componentsSeparatedByString:@" "];
    self.startTime.text = [str1 firstObject];
    
    self.endTime.text = [str1 lastObject];
    self.quyu.text = model.amount;
    if ([model.operation isEqualToString:@"1"]) {
        self.typeLabel.text = kLocat(@"k_MymineViewController_top_label_jtwk");
    }else{
        self.typeLabel.text = kLocat(@"k_MymineViewController_top_label_fxwk");
    }
    
}

@end
