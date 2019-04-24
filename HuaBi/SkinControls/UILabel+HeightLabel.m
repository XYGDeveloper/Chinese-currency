//
//  UILabel+HeightLabel.m
//  AutoLabelHeightAndWidth
//
//  Created by LenovoMac on 16/9/1.
//  Copyright © 2016年 LenovoMac. All rights reserved.
//

#import "UILabel+HeightLabel.h"

@implementation UILabel (HeightLabel)

- (CGSize)contentSize {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    NSDictionary * attributes = @{NSFontAttributeName : self.font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize contentSize = [self.text boundingRectWithSize:CGSizeMake(kScreenW - 40, MAXFLOAT)
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:attributes
                                                 context:nil].size;
    return contentSize;
}

@end
