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
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


@end

@implementation YTLatestDealContaineeCell


- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.typeLabel.text = nil;
    self.priceLabel.text = nil;
    self.tradeNumberLabel.text = nil;
    self.numberLabel.text = nil;
    self.timeLabel.text = nil;
}

- (void)setModel:(Trade_list *)model {
    _model = model;
    
    
    NSString *typeKey = [NSString stringWithFormat:@"%@_2", model.type];
    self.typeLabel.text = kLocat(typeKey);
    self.typeLabel.textColor = [model typeColor];
    self.priceLabel.text = [model.price _removeZeroOfDoubleString];
    self.tradeNumberLabel.text = [model.trade_num _removeZeroOfDoubleString];
    self.numberLabel.text = [model.num _removeZeroOfDoubleString];
    self.timeLabel.text = [Utilities returnTimeWithSecond:[model.add_time integerValue] formatter:@"HH:mm:ss"];
}

@end
