//
//  MyassetDetailItemTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MyassetDetailItemTableViewCell.h"
#import "YTMyassetDetailModel.h"
@implementation MyassetDetailItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.leftLabel.text = kLocat(@"k_MyassetDetailViewController_tableview_cell_label");
//    self.rightLabel.text = kLocat(@"k_MyassetDetailViewController_tableview_cell_label1");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)refreshWithModel:(user_order *)model{
//    "sell_2" = "賣出";
//    "buy_2" = "買入";
    if ([model.type isEqualToString:@"1"]) {
        self.sellType.text = kLocat(@"buy_2");
        self.sellType.textColor = kColorFromStr(@"#03C086");
    }else{
        self.sellType.text = kLocat(@"sell_2");
        self.sellType.textColor = kColorFromStr(@"#EA6E44");
    }
    
//    self.coinName.text = [NSString stringWithFormat:@"%@/KOK",model.currency_mark];
    self.wtlLabel.text  =kLocat(@"k_MyassetDetailViewController_wt_ing");
    self.timeLabel.text = kLocat(@"k_MyassetDetailViewController_wt_time");
    self.timeContentLabel.text = model.trade_time;
    self.cjLabel.text = kLocat(@"k_MyassetDetailViewController_wt_wtze");
    self.cjcontent.text = model.trade_num;
    self.wtPriceLabel.text = kLocat(@"k_MyassetDetailViewController_wt_price");
    self.wtjContent.text = model.price;
    self.cjjjLabel.text = kLocat(@"k_MyassetDetailViewController_wt_cjjj");
    self.cjjjContent.text = model.price_usd;
    self.wtlLabel.text = kLocat(@"k_MyassetDetailViewController_wt_wtl");
    self.wtlContent.text = model.trade_num;
    self.cjlLbael.text = kLocat(@"k_MyassetDetailViewController_wt_cjl");
    self.cjlContentLabel.text = model.trade_num;
    self.WTstatus.text = @"委託中";
    
}

@end
