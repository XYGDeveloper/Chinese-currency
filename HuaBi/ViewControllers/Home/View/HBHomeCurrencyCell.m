//
//  HBHomeCurrencyCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBHomeCurrencyCell.h"
#import "YTData_listModel.h"
#import "NSString+Operation.h"

@interface HBHomeCurrencyCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UILabel *currencyMarkLabel1;
@property (weak, nonatomic) IBOutlet UILabel *priceOfChange24HLabel1;
@property (weak, nonatomic) IBOutlet UILabel *changeOf24HLabel1;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel1;

@property (weak, nonatomic) IBOutlet UILabel *currencyMarkLabel2;
@property (weak, nonatomic) IBOutlet UILabel *priceOfChange24HLabel2;
@property (weak, nonatomic) IBOutlet UILabel *changeOf24HLabel2;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel2;

@property (weak, nonatomic) IBOutlet UILabel *currencyMarkLabel3;
@property (weak, nonatomic) IBOutlet UILabel *priceOfChange24HLabel3;
@property (weak, nonatomic) IBOutlet UILabel *changeOf24HLabel3;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel3;


@end

@implementation HBHomeCurrencyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.containerView.backgroundColor = kThemeColor;
    [self _cleanData];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toStack0)];
    [self.stack0 addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toStack1)];
    [self.stack1 addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toStack2)];
    [self.stack2 addGestureRecognizer:tap2];

}

- (ListModel *)modelAtIndex:(NSInteger)index {
    if (index < self.quotations.count) {
        return self.quotations[index];
    }
    
    return nil;
}

- (void)toStack0{
    ListModel *m = [self modelAtIndex:0];
    [self selectModel:m];
}

- (void)toStack1{
    ListModel *m = [self modelAtIndex:1];
    [self selectModel:m];
}

- (void)toStack2{
    ListModel *m = [self modelAtIndex:2];
    [self selectModel:m];
}

- (void)selectModel:(ListModel *)model {
    if (self.quotationDidSelectBlock) {
        self.quotationDidSelectBlock(model);
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self _cleanData];
}

#pragma mark - Private

- (void)_cleanData {
//    self.currencyMarkLabel1.text = @"--";
//    self.priceOfChange24HLabel1.text = @"--";
//    self.changeOf24HLabel1.text = @"--";
//    self.priceLabel1.text = @"--";
//
//    self.currencyMarkLabel2.text = @"--";
//    self.priceOfChange24HLabel2.text = @"--";
//    self.changeOf24HLabel2.text = @"--";
//    self.priceLabel2.text = nil;
//
//    self.currencyMarkLabel3.text = nil;
//    self.priceOfChange24HLabel3.text = nil;
//    self.changeOf24HLabel3.text = nil;
//    self.priceLabel3.text = nil;
}

#pragma mark - Setters

- (void)setQuotations:(NSArray<ListModel *> *)quotations {
    _quotations = quotations;
    
    [_quotations enumerateObjectsUsingBlock:^(ListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *price2 = [NSString stringWithFormat:@"≈%@", [obj.price_current_currency _addSuffixCurrentCurrency] ?: @""];
        if (idx == 0) {
            self.currencyMarkLabel1.text = [NSString stringWithFormat:@"%@/%@", obj.currency_mark, obj.trade_currency_mark] ?: @"--";
            self.priceOfChange24HLabel1.text = obj.price ?: @"--";
            self.changeOf24HLabel1.text = obj.change_24 ?: @"--";
            self.priceOfChange24HLabel1.textColor = obj.statusColor;
            self.changeOf24HLabel1.textColor = obj.statusColor;
            self.priceLabel1.text = price2 ?: @"--";
            
        } else if (idx == 1) {
            self.currencyMarkLabel2.text = [NSString stringWithFormat:@"%@/%@", obj.currency_mark, obj.trade_currency_mark] ?: @"--";
            self.priceOfChange24HLabel2.text = obj.price ?: @"--";
            self.changeOf24HLabel2.text = obj.change_24 ?: @"--";
            self.priceOfChange24HLabel2.textColor = obj.statusColor;
            self.changeOf24HLabel2.textColor = obj.statusColor;
            self.priceLabel2.text = price2 ?: @"--";
        } else if (idx == 2) {
            self.currencyMarkLabel3.text = [NSString stringWithFormat:@"%@/%@", obj.currency_mark, obj.trade_currency_mark] ?: @"--";
            self.priceOfChange24HLabel3.text = obj.price ?: @"--";
            self.changeOf24HLabel3.text = obj.change_24 ?: @"--";
            self.priceOfChange24HLabel3.textColor = obj.statusColor;
            self.changeOf24HLabel3.textColor = obj.statusColor;
            self.priceLabel3.text = price2 ?: @"--";
        }
    }];
}




@end
