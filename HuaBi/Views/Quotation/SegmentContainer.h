//
//  XNEffectListViewController.h
//  YJOTC
//
//  Created by l on 2018/7/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentScrollView.h"
@protocol SegmentContainerDelegate;
@interface SegmentContainer : UIView

@property (nonatomic, strong) SegmentScrollView *containerView;

/** 如果该值为YES，则会忽略对顶部选项条的所有配置的间隔值，且选项条与父视图同宽，不能滑动，对选项条进行平均分割，即每一个选项的宽度相同。
 平均分割模式下不支持角标。默认为NO。 */
@property (nonatomic, assign) BOOL averageSegmentation;

/** 顶部选项文字正常颜色，默认和首页对应颜色相同 */
@property (nonatomic, strong) UIColor *titleNormalColor;

/** 顶部选项文字选中时的颜色,默认和首页对应颜色相同 */
@property (nonatomic, strong) UIColor *titleSelectedColor;

/** 顶部文字字体大小 */
@property (nonatomic, strong) UIFont *titleFont;

/** 内容背景颜色 */
@property (nonatomic, strong) UIColor *containerBackgroundColor;

/** 顶部菜单底部的线条颜色 */
@property (nonatomic, strong) UIColor *bottomLineColor;

/** 顶部菜单底部的线条高度 */
@property (nonatomic, assign) CGFloat bottomLineHeight;

/** 标记选中状态线的颜色 */
@property (nonatomic, strong) UIColor *indicatorColor;

/**  标记选中状态的红线超出文字的宽度 */
@property (nonatomic, assign) CGFloat indicatorOffset;

/**  标记选中的红线的高度 */
@property (nonatomic, assign) CGFloat indicatorHeight;

/**  顶部选项条的高度，默认和首页高度相同 */
@property (nonatomic, assign) CGFloat topBarHeight;

/**  顶部选中项下边沿红标记条的最小宽度，默认为0（宽度和控件宽度相等，但比该属性小时会取该属性的值） */
@property (nonatomic, assign) CGFloat minIndicatorWidth;

/**
 *  顶部选项条左边秋右边的缩进量，默认为itemPadding的二分之一。根据选项数，间距和缩进进行调整超过屏幕宽度时顶部选项条可以进行左右滑动，未超过且expandToTopBarWidth为yes时，则忽略该属性和itemPadding属性，重新计算间距以铺满topBar的宽度。
 */
@property (nonatomic, assign) CGFloat horizontalInset;

/**
 *  顶部选项条选项之间的间距,默认为20,该值不包含选项控件本身两边沿距文字的距离。根据选项数，间距和缩进进行调整超过屏幕宽度时顶部选项条可以进行左右滑动，未超过且expandToTopBarWidth为yes时，则忽略该属性和horizontalInset属性，重新计算间距以铺满topBar的宽度。
 */
@property (nonatomic, assign) CGFloat itemPadding;

/**
 *  该参数为YES时，topBar上元素较少时，会重新计算间距，使之铺满整个topBar的宽度；为NO时不会铺满整个topBar的宽度。默认为YES。
 */
@property (nonatomic, assign) BOOL expandToTopBarWidth;

/**
 *  是否可以通过滑动来切换选项，默认为YES
 */
@property (nonatomic, assign) BOOL allowGesture;

/**
 *  获取当前选中项的index
 */
@property (nonatomic, assign, readonly) NSUInteger currentIndex;

/**
 *  如果在代理方法- (id)segmentContainer:(SegmentContainer *)segmentContainer contentForIndex:(NSUInteger)index;中返回的是UIViewController类型，再设置该属性时，会将代理提供的viewController添加为该属性的childViewController,这样在viewController中使用self.navigationController方法得到的就是parentVC.navigationController。
 */

@property (nonatomic, strong) UIScrollView *topBar;

@property (nonatomic, weak) UIViewController *parentVC;
@property (nonatomic, weak) id<SegmentContainerDelegate> delegate;

/**
 *  手动设置选中的项
 *
 *  @param index    要选择项的index
 *  @param animated 切换过程是否使用动画
 */
- (void)setSelectedIndex:(NSUInteger)index withAnimated:(BOOL)animated;

/**
 *  重新加载加载内容
 */
- (void)reloadData;

/**
 *  第index项顶部的显示用的button
 *
 *  @param index 序号
 *
 *  @return index项顶部的button
 */
- (UIButton *)itemAtIndex:(NSUInteger)index;

/**
 *  获取第index项的内容
 *
 *  @param index 序号
 *
 *  @return index项对应的UIView或UIViewController对象
 */
- (id)contentAtIndex:(NSUInteger)index;

@end


@protocol SegmentContainerDelegate <NSObject>

@required
/**
 *  返回segment控件一共有多少项
 *
 *  @param segmentContainer segmentContainer description
 *
 *  @return segment控件的项数
 */
- (NSUInteger)numberOfItemsInSegmentContainer:(SegmentContainer *)segmentContainer;

/**
 *  返回控件在index项的标题
 *
 *  @param segmentContainer segmentContainer description
 *  @param index            项的序号index
 *
 *  @return 返回控件在index项的标题
 */
- (NSString *)segmentContainer:(SegmentContainer *)segmentContainer titleForItemAtIndex:(NSUInteger)index;

/**
 *  返回在第index项需要显示的内容，支持UIView和UIViewController类型，返回UIViewConroller类型时建议提供parentVC属性，parentVC应该是包含该控件的UIViewController对象
 *  该方法每次reloadData后只会调用一次，调用时间为第一次切换到第index、index-1或都index+1项时
 *
 *  @param segmentContainer segmentContainer description
 *  @param index            项的序号
 *
 *  @return 返回在第index项需要显示的内容
 */
- (id)segmentContainer:(SegmentContainer *)segmentContainer contentForIndex:(NSUInteger)index;


@optional
/**
 *  该方法每次reloadData后只会调用一次，调用时间为第一次切换到第index、index-1或者index+1项时
 *
 *  @param segmentContainer segmentContainer description
 *  @param index            项的序号
 */
- (void)segmentContainer:(SegmentContainer *)segmentContainer preDisplayItemAtIndex:(NSUInteger)index;

/**
 *  选中第index项时的回调,每次切换(不论是滑动还是点击切换都会调用)到第index项都会调用该方法
 *
 *  @param segmentContainer segmentContainer description
 *  @param index            项的序号
 */
- (void)segmentContainer:(SegmentContainer *)segmentContainer didSelectedItemAtIndex:(NSUInteger)index;

/**
 *  每次滑动切换到第index项时调用
 *
 *  @param segmentContainer segmentContainer description
 *  @param index            index description
 */
- (void)segmentContainer:(SegmentContainer *)segmentContainer didSlideToItemAtindex:(NSUInteger)index;

/**
 *  每次点击切换到第index项时调用
 *
 *  @param segmentContainer segmentContainer description
 *  @param index            index description
 */
- (void)segmentContainer:(SegmentContainer *)segmentContainer didClickedItemAtIndex:(NSUInteger)index;

/**
 *  每次完成reloadData后都会调用
 *
 *  @param segmentContainer segmentContainer description
 */
- (void)segmentContainerDidReloadData:(SegmentContainer *)segmentContainer;

@end


@protocol ScrollToTopDelegate <NSObject>

- (void)setShouldScrollToTop:(BOOL)scrollToTop;

@end
