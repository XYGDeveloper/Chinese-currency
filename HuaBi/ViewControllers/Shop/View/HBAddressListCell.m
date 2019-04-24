//
//  HBAddressListCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/7.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBAddressListCell.h"
#import "HBMallAddressModel.h"

@interface HBAddressListCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *isDefaultButton;

@end

@implementation HBAddressListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
    self.preservesSuperviewLayoutMargins = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Actions

- (IBAction)checkedDefaultButtonAction:(UIButton *)sender {
}

- (IBAction)editAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addressListCell:editWithModel:)]) {
        [self.delegate addressListCell:self editWithModel:self.model];
    }
}

- (IBAction)deleteAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addressListCell:deleteWithModel:)]) {
        [self.delegate addressListCell:self deleteWithModel:self.model];
    }
}
#pragma mark - Setter

- (void)setModel:(HBMallAddressModel *)model {
    _model = model;
    
    self.nameLabel.text = model.name;
    self.phoneLabel.text = model.phone;
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@", model.area_info, model.address];
    self.isDefaultButton.selected =  [model.is_default isEqualToString:@"1"];
}

@end
