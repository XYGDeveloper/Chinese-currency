//
//  YTTradeCancellationsCell.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTTradeCancellationsCell.h"
#import "YTTradeUserOrderModel.h"
#import "NSString+RemoveZero.h"

@interface YTTradeCancellationsCell ()

@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


@end

@implementation YTTradeCancellationsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.typeNameLabel.text = kLocat(@"Entrustment_type");
    self.priceNameLabel.text = kLocat(@"Entrust_price");
    self.numberNameLabel.text = kLocat(@"Quantity_entrusted");
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.priceLabel.text = nil;
    self.numberLabel.text = nil;
    self.typeLabel.text = nil;
}

- (void)setModel:(YTTradeUserOrderModel *)model {
    _model = model;
    self.priceLabel.text = [model.price _removeZeroOfDoubleString];
    self.numberLabel.text = [model.num _removeZeroOfDoubleString];
    self.typeLabel.text = kLocat(model.type);
    self.typeLabel.textColor = [model typeColor];
}

- (IBAction)deleteAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tradeCancellationsCell:deleteModel:)]) {
        [self.delegate tradeCancellationsCell:self deleteModel:self.model];
    }
}

@end
