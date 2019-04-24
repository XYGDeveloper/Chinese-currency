//
//  HBConfirmOrderAddressCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/9.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBConfirmOrderAddressCell.h"
#import "HBMallAddressModel.h"

@interface HBConfirmOrderAddressCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;

@end

@implementation HBConfirmOrderAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - HBMallAddressModel

- (void)setModel:(HBMallAddressModel *)model {
    _model = model;
    if (model) {
        self.addLabel.hidden = YES;
    } else {
        self.addLabel.hidden = NO;
    }
    
    self.nameLabel.text = model.name ?: @"--";
    self.phoneLabel.text = model.phone ?: @"--";
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@", model.area_info ?: @"-", model.address ?: @"-"];
}

@end
