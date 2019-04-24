//
//  HBSelectCodeOfCountryView.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/13.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HBSelectCodeOfCountryView, ICNNationalityModel;

@protocol HBSelectCodeOfCountryViewDelegate <NSObject>

- (void)selectCodeOfCountryView:(HBSelectCodeOfCountryView *)view didSelectModel:(ICNNationalityModel *)model;

@end


@interface HBSelectCodeOfCountryView : UIView

@property (nonatomic, copy) NSArray<ICNNationalityModel *> *codesOfCountry;

@property (nonatomic, weak) id<HBSelectCodeOfCountryViewDelegate> delegate;

- (void)showInWindow;

- (void)showInView:(UIView *)view;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
