//
//  HBHomeQuotationCell.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HBHomeQuotationCellStyle) {
    HBHomeQuotationCellStyleDefault,
    HBHomeQuotationCellStyleOther
};

@class ListModel;
@interface HBHomeQuotationCell : UITableViewCell


- (void)configWithModel:(ListModel *)model
              indexPath:(NSIndexPath *)indexPath
              cellStyle:(HBHomeQuotationCellStyle)cellStyle;

@end


