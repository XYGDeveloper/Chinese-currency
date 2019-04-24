//
//  HBShoppingCartItemCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/3/26.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBShoppingCartItemCell.h"
#import "UIView+RoundCorner.h"
#import "HBShopCartModel.h"

@interface HBShoppingCartItemCell () <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIView *separatorLineView;

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@end

@implementation HBShoppingCartItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectedBackgroundView = [UIView new];
    [self.itemImageView roundWithRadius:8];
    self.numberTextField.delegate = self;
    
    [self.minusButton setTitleColor:kColorFromStr(@"c4c7cc") forState:UIControlStateDisabled];
    [self.plusButton setTitleColor:kColorFromStr(@"c4c7cc") forState:UIControlStateDisabled];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
      self.separatorLineView.backgroundColor = kColorFromStr(@"#F4F4F4");
    self.numberTextField.backgroundColor = kColorFromStr(@"#F4F4F4");
}

- (void)updateNumber {
    self.numberTextField.text = self.model.goods_number;
    self.minusButton.enabled = self.model.goods_number.integerValue > 1;
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:self.model.goods_number]) {
        return;
    }
    
    if (textField.text.integerValue < 1) {
        textField.text = @"1";
    }
    if ([self.delegate respondsToSelector:@selector(shoppingCartItemCell:changedNumber:model:)]) {
        [self.delegate shoppingCartItemCell:self changedNumber:textField.text.integerValue model:self.model];
    }
    [self _selectedCart];
}


#pragma mark - Actions

- (IBAction)checkUpAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.model.isSelected = sender.selected;
    
    [self _checkBoxChanged];
    
}


- (void)_checkBoxChanged {
    if ([self.delegate respondsToSelector:@selector(checkBoxChangedWithShoppingCartItemCell:)]) {
        [self.delegate checkBoxChangedWithShoppingCartItemCell:self];
    }
}

- (IBAction)minusAction:(id)sender {
    
    NSInteger number = [self.numberTextField.text integerValue];
    number--;
    [self.delegate shoppingCartItemCell:self changedNumber:number model:self.model];
    [self _selectedCart];
    
}
- (IBAction)plusAction:(id)sender {
    
    NSInteger number = [self.numberTextField.text integerValue];
    number++;
    [self.delegate shoppingCartItemCell:self changedNumber:number model:self.model];
    [self _selectedCart];
}

- (void)_selectedCart {
    self.model.isSelected = YES;
    self.checkBoxButton.selected = YES;
    [self _checkBoxChanged];
}

#pragma mark - Setter

- (void)setModel:(HBShopCartModel *)model {
    _model = model;
    self.numberTextField.text = model.goods_number;
    self.nameLabel.text = model.goods_name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@KOK", model.price_kok];
    [self.itemImageView setImageURL:[NSURL URLWithString:model.goods_thumb]];
    self.checkBoxButton.selected = model.isSelected;
    self.minusButton.enabled = model.goods_number.integerValue > 1;
}

@end
