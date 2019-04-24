//
//  HBConfirmOrderGoodsCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/9.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBConfirmOrderGoodsCell.h"
#import "HBShopGoodModel.h"

@interface HBConfirmOrderGoodsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *kokPriceLabel;

@end

@implementation HBConfirmOrderGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter

- (void)setModel:(HBShopGoodModel *)model {
    _model = model;
    
    [self.goodsImageView setImageURL:[NSURL URLWithString:model.goods_thumb]];
    self.nameLabel.text = model.goods_name ?: @"--";
    self.kokPriceLabel.text = model.kok ? [NSString stringWithFormat:@"%@ KOK", model.kok] : @"--";
    self.priceLabel.text = model.shop_price ? [NSString stringWithFormat:@"(%@ cny)", model.shop_price] : @"";
    self.numberLabel.text = model.goods_number ? [NSString stringWithFormat:@"X%@", model.goods_number] : @"--";
}

@end
