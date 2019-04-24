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
@property (nonatomic, assign) BOOL isTypeOfBuy;

@property (nonatomic, strong) CAShapeLayer *progressLayer;
@end

@implementation YTSellTrendingContaineeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    [self.contentView.layer addSublayer:self.progressLayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.typeLabel.text = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    UIColor *color = self.isTypeOfBuy ? [kGreenColor colorWithAlphaComponent:0.1] : [kOrangeColor colorWithAlphaComponent:0.1];
    
    self.progressLayer.strokeColor = color.CGColor;
    self.progressLayer.lineWidth = CGRectGetHeight(self.bounds);
    self.progressLayer.path = [self progressLayerPath].CGPath;
}


#pragma mark - Private

- (UIBezierPath *)progressLayerPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetHeight(self.bounds) / 2.)];
    [path addLineToPoint:CGPointMake(0,  CGRectGetHeight(self.bounds) / 2.)];
    return path;
}

#pragma mark - Public

- (void)configureWithModel:(Buy_list *)model index:(NSInteger)index isTypeOfBuy:(BOOL)isTypeOfBuy {
    self.model = model;
    if (!self.model.isHolder) {
        self.typeLabel.text = [NSString stringWithFormat:@"%@", @(index)];
    } else {
        self.typeLabel.text = nil;
    }
    self.selectionStyle = self.model.isHolder ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    self.isTypeOfBuy = isTypeOfBuy;
    UIColor *color = isTypeOfBuy ? kGreenColor : kOrangeColor;
    self.priceLabel.textColor = color;
    self.priceLabel.text = _model.price;
    self.numberLabel.text = _model.num;
    self.progressLayer.strokeEnd = MIN(1, MAX(_model.new_bili / 100., 0));
}

@end
