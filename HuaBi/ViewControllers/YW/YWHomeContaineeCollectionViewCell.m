//
//  YWHomeContaineeCollectionViewCell.m
//  ywshop
//
//  Created by 前海数交（ZJ） on 2018/8/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YWHomeContaineeCollectionViewCell.h"
#import "UIView+RoundCorner.h"
#import "HBShopGoodModel.h"

@interface YWHomeContaineeCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *supportCurrenciesLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnyPriceLabel;

@end

@implementation YWHomeContaineeCollectionViewCell


#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.imageView setImageURL:[NSURL URLWithString:@"http://5b0988e595225.cdn.sohucs.com/images/20171112/aaa68702f9884babb8ba38abc6d977be.jpeg"]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.containerView.frame = self.bounds;
    [self.containerView roundWithRadius:8.];
}


#pragma mark - Setter

- (void)setModel:(HBShopGoodModel *)model {
    _model = model;
    
    self.titleLabel.text = _model.goods_name;
    self.priceLabel.text = _model.kok_price ?: @"";
    self.cnyPriceLabel.text = _model.shop_price ? [NSString stringWithFormat:@"(%@)", _model.shop_price] : @"";
    [self.imageView setImageURL:[NSURL URLWithString:_model.goods_img]];
    self.supportCurrenciesLabel.text = [NSString stringWithFormat:@"%@ %@", kLocat(@"HBShopViewController_Support"), _model.currencys ?: @"-"];;
}

@end
