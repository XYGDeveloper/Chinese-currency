//
//  YWCircleDetailCommentCell.m
//  ywshop
//
//  Created by 周勇 on 2017/11/2.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWCircleDetailCommentCell.h"


@interface YWCircleDetailCommentCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;







@end

@implementation YWCircleDetailCommentCell

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
//    _timeLabel.text = dataDic[@"add_time"];
    _timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:[dataDic[@"add_time"] longLongValue]] diff2now];

    NSString * header = dataDic[@"userhead"];
    [_avatar setImageWithURL:header.ks_URL placeholder:[UIImage imageNamed:@"a_img"]];
    _commentLabel.text = dataDic[@"content"];
    
    
    
//    id obj = dataDic[@"parent_id"];
    
//    if ([obj isKindOfClass:[NSString class]]) {
//        NSLog(@"是字符串 %@",[[NSDate dateWithTimeIntervalSince1970:[dataDic[@"add_time"] longLongValue]] diff2now]);
//    }
    
    
    if ([dataDic[@"parent_id"] integerValue] == 0) {
        _nameLabel.text = dataDic[@"username"];
        _nameLabel.textColor = kColorFromStr(@"#486ca8");
    }else{
        _nameLabel.text = [NSString stringWithFormat:@"%@%@%@",dataDic[@"username"],kLocat(@"C_reply"),dataDic[@"reply_username"]];
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:_nameLabel.text];
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:kColorFromStr(@"#486ca8")
                              range:NSMakeRange(0, _nameLabel.text.length)];
        
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:k323232Color
                              range:[_nameLabel.text rangeOfString:kLocat(@"C_reply")]];
        _nameLabel.attributedText = attributedStr;
        
    }
    
    
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _nameLabel.font = PFRegularFont(16);
    _timeLabel.font = PFRegularFont(10);
    _commentLabel.font = PFRegularFont(12);
    _nameLabel.textColor = k323232Color;
    _timeLabel.textColor = kColorFromStr(@"787878");
    _commentLabel.textColor = k323232Color;
    kViewBorderRadius(_avatar, 22, 0, kYellowColor);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
