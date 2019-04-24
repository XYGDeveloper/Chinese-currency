//
//  HClSheetHead.m
//  
//
//  Created by hcl on 15/10/15.
//
//

#import "HClSheetHead.h"

@implementation HClSheetHead

- (void)awakeFromNib
{
    _headLabel.backgroundColor = [UIColor whiteColor];
    _headLabel.textColor = [UIColor darkGrayColor];
    _headLabel.font = [UIFont systemFontOfSize:18];
    
    if ([[UIScreen mainScreen] bounds].size.height == 667) {
        _headLabel.font = [UIFont systemFontOfSize:20];
    }
    else if ([[UIScreen mainScreen] bounds].size.height > 667) {
        _headLabel.font = [UIFont systemFontOfSize:21];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}

@end
