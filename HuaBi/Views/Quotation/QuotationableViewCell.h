//
//  QuotationableViewCell.h
//  YJOTC
//
//  Created by l on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListModel;

@interface QuotationableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *coinType;
@property (weak, nonatomic) IBOutlet UILabel *h24Label;

@property (weak, nonatomic) IBOutlet UILabel *topV;
@property (weak, nonatomic) IBOutlet UILabel *bottomV;
@property (weak, nonatomic) IBOutlet UILabel *endV;
@property (weak, nonatomic) IBOutlet UILabel *currName;

- (void)refreshWithModel:(ListModel *)model currencyName:(NSString *)currencyName;

@end
