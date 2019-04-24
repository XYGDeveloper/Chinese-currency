//
//  YTTradeRecordCell.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTTradeRecordCell.h"
#import "YTTradeRecordModel.h"
#import "NSString+RemoveZero.h"

@interface YTTradeRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation YTTradeRecordCell

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.typeLabel.text = nil;
    self.timeLabel.text = nil;
    self.priceLabel.text = nil;
    self.numberLabel.text = nil;
}

#pragma mark - Setters

- (void)setModel:(YTTradeRecordModel *)model {
    _model = model;
    NSString *typeKey = [NSString stringWithFormat:@"%@_2", model.type];
    self.typeLabel.text = kLocat(typeKey);
    self.timeLabel.text = [Utilities returnTimeWithSecond:[model.add_time integerValue] formatter:@"yyyy-MM-dd HH:mm:ss"];
    self.priceLabel.text = [model.price _removeZeroOfDoubleString];
    self.numberLabel.text = [model.num _removeZeroOfDoubleString];
    self.typeLabel.textColor = [model typeColor];
}

@end
