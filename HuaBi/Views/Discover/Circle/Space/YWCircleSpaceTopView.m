//
//  YWCircleSpaceTopView.m
//  ywshop
//
//  Created by 周勇 on 2017/11/6.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWCircleSpaceTopView.h"


@interface YWCircleSpaceTopView ()



@end

@implementation YWCircleSpaceTopView


-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    _nameLabrl.text = dataDic[@"nickname"];
    if ([dataDic[@"personsign"] isKindOfClass:[NSNull class]] || dataDic[@"personsign"] == nil) {
        _signLabel.text = @"";
    }else{
        _signLabel.text = dataDic[@"personsign"];
    }
    
    
    NSString *headUrl = dataDic[@"userhead"];
    if (![headUrl containsString:@"http"]) {
        headUrl = [NSString stringWithFormat:@"%@%@",kBasePath,headUrl];
    }
    [_avatar setImageWithURL:headUrl.ks_URL placeholder:nil];

    if (kUserInfo.uid == [dataDic[@"member_id"] integerValue]) {
        _attentionButton.hidden = YES;
    }else{
        _attentionButton.hidden = NO;
    }
    _attentionButton.selected = [dataDic[@"is_follow"] boolValue];
    
    _infoLabel.text = [NSString stringWithFormat:@"%@ %@  %@ %@",LocalizedString(@"Dis_Follow"),dataDic[@"fans"],LocalizedString(@"Dis_VistsCount"),dataDic[@"views"]];

    
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    
    _avatar.userInteractionEnabled = YES;
    
    
    _nameLabrl.font = PFRegularFont(14);
    _infoLabel.font = PFRegularFont(10);
    _signLabel.font = PFRegularFont(14);
    _attentionButton.titleLabel.font = PFRegularFont(12);
    
    _attentionButton.backgroundColor = kWhiteColor;
    
    [_attentionButton setTitle:LocalizedString(@"Dis_AddAttention") forState:UIControlStateNormal];
    [_attentionButton setTitle:LocalizedString(@"Dis_AttentionEd") forState:UIControlStateSelected];
    [_attentionButton setTitleColor:kColorFromStr(@"3fb1f9") forState:UIControlStateNormal];
    
    _attentionButton.hidden = YES;
    _attentionButton.SG_eventTimeInterval = 1;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_attentionButton.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _attentionButton.bounds;
    maskLayer.path = maskPath.CGPath;
    _attentionButton.layer.mask = maskLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
