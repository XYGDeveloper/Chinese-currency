//
//  HBQuotationCollectionViewCell.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/2/13.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBQuotationCollectionViewCell.h"
#import "QuotationListViewController.h"
#import "YTData_listModel.h"

@interface HBQuotationCollectionViewCell ()

@property (nonatomic, strong) QuotationListViewController *vc;

@end

@implementation HBQuotationCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _vc.view.frame = self.bounds;
}

#pragma mark - Private

- (void)_commonInit {
    _vc = [QuotationListViewController new];
    [self.contentView addSubview:_vc.view];
}

#pragma mark - Setters

- (void)setModel:(YTData_listModel *)model {
    _model = model;
    _vc.list = model.data_list;
    _vc.tag = model.name;
}

@end
