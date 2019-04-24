//
//  KTSheetCell.m
//  
//
//  Created by hcl on 15/10/13.
//
//

#import "HClSheetCell.h"

@interface HClSheetCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *divLineHeight;

@end

@implementation HClSheetCell

- (void)awakeFromNib {
    _divLineHeight.constant = 0.5;
    _myLabel.backgroundColor = [UIColor whiteColor];
    _myLabel.textColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0];
    _myLabel.font = [UIFont systemFontOfSize:20];
    if ([[UIScreen mainScreen] bounds].size.height == 667) {
        _myLabel.font = [UIFont systemFontOfSize:20];
    }
    else if ([[UIScreen mainScreen] bounds].size.height > 667) {
        _myLabel.font = [UIFont systemFontOfSize:21];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
