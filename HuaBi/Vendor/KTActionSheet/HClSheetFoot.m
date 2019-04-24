//
//  HClSheetFoot.m
//  
//
//  Created by hcl on 15/10/15.
//
//

#import "HClSheetFoot.h"

@implementation HClSheetFoot

- (void)awakeFromNib
{
    _footButton.backgroundColor = [UIColor whiteColor];
    
    [_footButton setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_footButton setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    
    _footButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    if ([[UIScreen mainScreen] bounds].size.height == 667) {
        _footButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    else if ([[UIScreen mainScreen] bounds].size.height > 667) {
        _footButton.titleLabel.font = [UIFont boldSystemFontOfSize:21];
    }
}

@end
