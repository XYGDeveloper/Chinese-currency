//
//  ZFBTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/9/13.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "ZFBTableViewCell.h"
#import "IndexModel.h"
#import "YTData_listModel.h"
#import "UILabel+PPCounter.h"
@implementation ZFBTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rank.layer.cornerRadius = 3;
    self.rank.layer.masksToBounds = YES;
    self.coinType.layer.cornerRadius = 15;
    self.coinType.layer.masksToBounds = YES;
    self.pre.layer.cornerRadius = 4;
    self.pre.layer.masksToBounds = YES;
    // Initialization code
    
}

- (void)refreshWith:(itemModel *)model indexPath:(NSIndexPath *)indexpath{
    self.rank.text = [NSString stringWithFormat:@"%ld",indexpath.row+1];
    [self.coinType setImageWithURL:[NSURL URLWithString:model.currency_logo] placeholder:[UIImage imageNamed:@""]];
    self.coinName.text = model.currency_name;
    self.desPre.text = model.price;
    self.crePre.text = [NSString stringWithFormat:@"≈%@CNY",model.price_usd];
    if ([model.price_status isEqualToString:@"0"]) {
        self.pre.backgroundColor = kRGBA(215, 114, 76, 1);
        self.pre.counterAnimationType = PPCounterAnimationTypeEaseOut;
        [self.pre pp_fromZeroToNumber:[model.H_change24 longLongValue] formatBlock:^NSString *(CGFloat number) {
            return [NSString stringWithFormat:@"%.2f%%",number];
        }];
    }else if ([model.price_status isEqualToString:@"1"]){
        self.pre.backgroundColor = kRGBA(84, 187, 139, 1);
        self.pre.counterAnimationType = PPCounterAnimationTypeEaseOut;
        [self.pre pp_fromZeroToNumber:[model.H_change24 longLongValue] formatBlock:^NSString *(CGFloat number) {
            return [NSString stringWithFormat:@"+%.2f%%",number];
        }];
    }else{
        self.pre.backgroundColor = kColorFromStr(@"#896FED");
        self.pre.counterAnimationType = PPCounterAnimationTypeEaseOut;
        [self.pre pp_fromZeroToNumber:[model.H_change24 longLongValue] formatBlock:^NSString *(CGFloat number) {
            return [NSString stringWithFormat:@"%.2f%%",number];
        }];
    }
}

- (void)refreshWith:(ListModel *)model{
    
//    self.rank.text = [NSString stringWithFormat:@"%ld",indexpath.row+1];
//    [self.coinType setImageWithURL:[NSURL URLWithString:model.currency_logo] placeholder:[UIImage imageNamed:@""]];
//    self.coinName.text = model.currency_name;
//    self.desPre.text = model.max_price;
//    self.crePre.text = [NSString stringWithFormat:@"≈%@",model.min_price];
//    self.pre.text = [NSString stringWithFormat:@"-%@%%",model.H_change24];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
