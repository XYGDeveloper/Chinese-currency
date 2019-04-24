//
//  HBQuotationListHeaderView.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HBQuotationListHeaderViewStatus) {
    HBQuotationListHeaderViewStatusOriginal = 1,
    HBQuotationListHeaderViewStatusAscending = 2,
    HBQuotationListHeaderViewStatusDescending = 3,
};

@class HBQuotationListHeaderView;
@protocol HBQuotationListHeaderViewDelegate <NSObject>

- (void)quotationListHeaderView:(HBQuotationListHeaderView *)view selectedName:(NSString *)selectedName status:(HBQuotationListHeaderViewStatus)status;

@end

@interface HBQuotationListHeaderView : UIView

@property (nonatomic, weak) id<HBQuotationListHeaderViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
