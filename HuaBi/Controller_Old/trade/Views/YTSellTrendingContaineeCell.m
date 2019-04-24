//
//  YTSellTrendingContaineeCell.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTSellTrendingContaineeCell.h"
#import "YTTradeIndexModel.h"
#import "NSString+RemoveZero.h"

@interface YTSellTrendingContaineeCell ()

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


@end

@implementation YTSellTrendingContaineeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(Buy_list *)model {
    _model = model;
    
    
}

- (void)configureWithModel:(Buy_list *)model index:(NSInteger)index color:(UIColor *)color {
    self.model = model;
    
    self.typeLabel.text = [NSString stringWithFormat:@"%@%@", kLocat(_model.type), @(index)];
    self.priceLabel.textColor = color;
    self.priceLabel.text = [_model.price _removeZeroOfDoubleString];
    self.numberLabel.text = [_model.num _removeZeroOfDoubleString];
}

@end
