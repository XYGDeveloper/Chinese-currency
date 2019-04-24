//
//  YTLatestDealContaineeCell.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTLatestDealContaineeCell.h"
#import "YTTradeIndexModel.h"
#import "NSString+RemoveZero.h"

@interface YTLatestDealContaineeCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeNumberLabel;


@end

@implementation YTLatestDealContaineeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
     self.contentView.backgroundColor = kThemeColor;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.typeLabel.text = nil;
    self.priceLabel.text = nil;
    self.tradeNumberLabel.text = nil;
    self.timeLabel.text = nil;
    
   
}

- (void)setModel:(Trade_list *)model {
    _model = model;
    
    
    NSString *typeKey = [NSString stringWithFormat:@"%@_2", model.type];
    self.typeLabel.text = kLocat(typeKey);
    self.typeLabel.textColor = [model typeColor];
    self.priceLabel.text = model.price;
    self.tradeNumberLabel.text = model.trade_num;
    self.timeLabel.text = [Utilities returnTimeWithSecond:[model.trade_time integerValue] formatter:@"HH:mm:ss"];
}

@end
