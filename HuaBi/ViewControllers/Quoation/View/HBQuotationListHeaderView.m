//
//  HBQuotationListHeaderView.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBQuotationListHeaderView.h"

@interface HBQuotationListHeaderView ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray<UIButton *> *buttons;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UIButton *priceButton;
@property (weak, nonatomic) IBOutlet UIButton *changeOf24HButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLeadingConstraint;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, assign) HBQuotationListHeaderViewStatus status;//1, 2, 3
@property (nonatomic, copy) NSArray<NSString *> *names;
@end

@implementation HBQuotationListHeaderView

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       obj.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    }];
    self.backgroundColor = kThemeColor;
   
    self.names = @[@"currency_mark", @"price", @"change24String",];
    [self.nameButton setTitle:[NSString stringWithFormat:@"%@ ", kLocat(@"HBQuotationListHeaderView_name")] forState:UIControlStateNormal];
    [self.priceButton setTitle:[NSString stringWithFormat:@"%@ ", kLocat(@"HBQuotationListHeaderView_Latest price")] forState:UIControlStateNormal];
    [self.changeOf24HButton setTitle:[NSString stringWithFormat:@"%@ ",  kLocat(@"HBQuotationListHeaderView_24h change")] forState:UIControlStateNormal];
//    self.priceLeadingConstraint.constant = kScreenW / 3. + 20;
}

-(void)updateConstraints {
    [super updateConstraints];
    
}

#pragma mark - Actions

- (IBAction)tapAction:(UIButton *)sender {
    
    self.selectedButton = sender;
}

#pragma mark - Setters

- (void)setSelectedButton:(UIButton *)selectedButton {
    if ([_selectedButton isEqual:selectedButton]) {
        if (self.status == HBQuotationListHeaderViewStatusDescending) {
            self.status = HBQuotationListHeaderViewStatusOriginal;
            
        } else {
            self.status += 1;
        }
    } else {
        [_selectedButton setImage:[UIImage imageNamed:@"quotation_sort_1"] forState:UIControlStateNormal];
        self.status = HBQuotationListHeaderViewStatusAscending;
    }
    
    
    _selectedButton = selectedButton;
    UIImage *buttonImage = [UIImage imageNamed:[NSString stringWithFormat:@"quotation_sort_%@", @(self.status)]];
    [_selectedButton setImage:buttonImage forState:UIControlStateNormal];
    
    
    if ([self.delegate respondsToSelector:@selector(quotationListHeaderView:selectedName:status:)]) {
        NSString *selectedName = self.names[selectedButton.tag];
        [self.delegate quotationListHeaderView:self selectedName:selectedName status:self.status];
    }
}

@end
