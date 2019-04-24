//
//  XNEffectListViewController.h
//  YJOTC
//
//  Created by l on 2018/7/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "SegmentContainer.h"

#import "SafeCategory.h"
#define itemView_start_tag 111


@interface SegmentContainer ()<UIScrollViewDelegate> {
    BOOL _didLoadData;
}


@property (nonatomic, strong) UIImageView *indicatorView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) NSUInteger itemCount;
@property (nonatomic, strong) NSMutableArray *itemViewArray;

@property (nonatomic, strong) NSMutableDictionary *contentsDic;//存储内容文件

@end

@implementation SegmentContainer

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.minIndicatorWidth = 0;//indicator的最小宽度
        self.topBarHeight = 40;//顶部选项条默认高度
        self.itemPadding = 20;//项与项之间默认距离
        self.allowGesture = YES;//默认可以通过滑动来切换选项
        self.indicatorOffset = 10;//选项选中时标记的红条比文字长出的长度(效果图标记为10)
        self.indicatorHeight = 2.0;//标记选中的红线的高度
        self.bottomLineHeight = 0.5;//分隔线默认高度
        self.expandToTopBarWidth = YES;//默认铺满topBar的宽度
        self.containerBackgroundColor = [UIColor lightGrayColor];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.lineView];
        [self.topBar addSubview:self.indicatorView];
        [self addSubview:self.topBar];
        [self addSubview:self.containerView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_didLoadData) {
        _didLoadData = YES;
        [self reloadData];//在layoutsubview中(本控件第一次显示时)调用reloadData可以保证reload时，所依赖的视图大小都已是实际显示大小。
    }
    
    self.containerView.frame = CGRectMake(0, self.topBar.bottom, self.width, self.height - self.topBar.height);
    self.containerView.contentSize = CGSizeMake(self.containerView.contentSize.width, self.containerView.height);
}




#pragma mark - reloadData
- (void)reloadData
{
    if (!_didLoadData || !self.delegate || ![self.delegate respondsToSelector:@selector(numberOfItemsInSegmentContainer:)] || ![self.delegate respondsToSelector:@selector(segmentContainer:titleForItemAtIndex:)] || ![self.delegate respondsToSelector:@selector(segmentContainer:contentForIndex:)]) {
        return;
    }
    
    self.itemCount = [self.delegate numberOfItemsInSegmentContainer:self];
    self.indicatorView.backgroundColor = self.indicatorColor;
    [self reloadTopBar];
    [self reloadContainerView];
    
    if (self.currentIndex >= self.itemCount) {
        _currentIndex = 0;
    }
    [self setSelectedIndex:self.currentIndex withAnimated:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentContainerDidReloadData:)]) {
        [self.delegate segmentContainerDidReloadData:self];
    }
}

- (void)reloadTopBar
{
    if (self.itemCount < 1) {//只有一个选项时隐藏顶部导航条
        self.topBar.frame = CGRectMake(0, 0, self.topBar.width, 0);
        self.lineView.bottom = self.topBar.bottom;
        return;
    }
    
    self.topBar.frame = CGRectMake(0, 0, self.topBar.width, self.topBarHeight);
    self.lineView.bottom = self.topBar.bottom;
    
    for (UIButton *btn in self.itemViewArray) {
        [btn removeFromSuperview];
    }
    [self.itemViewArray removeAllObjects];
    
    for (NSInteger i = 0; i < self.itemCount; i++) {
        UIButton *btn = [self itemButtonForIndex:i];
        [self.topBar addSubview:btn];
        [self.itemViewArray safeAddObject:btn];
    }
    
    if (self.averageSegmentation) {
        [self reLayoutTopBarUseAverageMode];
    } else {
        [self reLayoutTopBar];
    }
    
    [self.topBar bringSubviewToFront:self.indicatorView];
}

- (void)reLayoutTopBarUseAverageMode {
    self.topBar.contentSize = self.topBar.bounds.size;
    
    CGFloat leftPos = 0;
    CGFloat averageWidth = self.topBar.width / self.itemCount;
    for (NSInteger i = 0; i < self.itemViewArray.count; i++) {
        UIButton *btn = [self.itemViewArray safeObjectAtIndex:i];
        btn.left = leftPos;
        btn.width = averageWidth;
        leftPos = btn.right;
    }
}

- (void)reLayoutTopBar
{
    
    CGFloat horizeonMargin = self.horizontalInset > 0 ? self.horizontalInset : 0.5*self.itemPadding;//左右缩进量默认为padding的一半，如果设置了horizontalInset,则按horizontalInset计算
    CGFloat leftPos = horizeonMargin;
    for (NSInteger i = 0; i < self.itemViewArray.count; i++) {
        UIButton *btn = [self.itemViewArray safeObjectAtIndex:i];
        btn.left = leftPos;
        leftPos += btn.width + self.itemPadding;
    }
    
    CGFloat rigthPos = leftPos - self.itemPadding + horizeonMargin;//所有控件布局完成后，最右边的位置
    
    self.topBar.contentSize = CGSizeMake(rigthPos, self.topBar.height);
    
    if (rigthPos >= self.topBar.width + 20) {//超过屏幕宽度20个像素才滑动，否则调整间距，使之刚好铺满屏幕
        self.topBar.contentSize = CGSizeMake(rigthPos, self.topBar.height);
    }
    else{
        self.topBar.contentSize = self.topBar.bounds.size;
        
        CGFloat delta = (self.topBar.width - rigthPos) / self.itemCount;
        if (delta < 0 || self.expandToTopBarWidth) {
            for (NSInteger i = 0; i < self.itemViewArray.count; i++) {
                UIButton *btn = [self.itemViewArray safeObjectAtIndex:i];
                btn.left += (i + 0.5) * delta;
            }
        }
    }
}

- (void)reloadContainerView
{
    for (UIView *subView in self.containerView.subviews) {
        [subView removeFromSuperview];
    }
    if (self.parentVC) {
        for (UIViewController *child in self.parentVC.childViewControllers) {
            [child removeFromParentViewController];
        }
    }
    [self.contentsDic removeAllObjects];
    
    self.containerView.contentSize = CGSizeMake(self.itemCount * self.containerView.width, self.containerView.height);
}


#pragma mark - item switch
- (void)itemButtonsClicked:(UIButton *)sender
{
    [self scrollToItemAtIndex:sender.tag - itemView_start_tag withAnimation:YES slide:NO];
}

- (void)scrollToItemAtIndex:(NSUInteger)index withAnimation:(BOOL)animation slide:(BOOL)slide
{
    if (index >= self.itemCount) {
        return;
    }
    
    [self willScrollToIndex:index];//在需要的时候添加视图
    
    NSUInteger oldIndex = self.currentIndex;
    _currentIndex = index;
    
    id originContent = [self contentAtIndex:oldIndex];
    if ([originContent respondsToSelector:@selector(setShouldScrollToTop:)]) {
        [originContent setShouldScrollToTop:NO];
    }
    
    id newContent = [self contentAtIndex:_currentIndex];
    if ([newContent respondsToSelector:@selector(setShouldScrollToTop:)]) {
        [newContent setShouldScrollToTop:YES];
    }
    
    UIButton *originBtn = (UIButton *)[self.itemViewArray safeObjectAtIndex:oldIndex];
    originBtn.selected = NO;
    
    UIButton *newBtn = (UIButton *)[self.itemViewArray safeObjectAtIndex:index];
    newBtn.selected = YES;
    
    CGPoint containOffset = CGPointMake(index*self.containerView.width, 0);
    
    if (animation) {
        __weak typeof(self) wSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            __strong typeof(wSelf) sSelf = self;
            [sSelf reLayoutIndicatorView];
            sSelf.containerView.contentOffset = containOffset;
            [sSelf scrollRectToVisibleCenteredOn:newBtn.frame animated:NO];
        } completion:^(BOOL finished) {
            __strong typeof(wSelf) sSelf = self;
            if (sSelf.delegate && [sSelf.delegate respondsToSelector:@selector(segmentContainer:didSelectedItemAtIndex:)]) {
                [sSelf.delegate segmentContainer:sSelf didSelectedItemAtIndex:index];
            }
            if (slide) {
                if (sSelf.delegate && [sSelf.delegate respondsToSelector:@selector(segmentContainer:didSlideToItemAtindex:)]) {
                    [sSelf.delegate segmentContainer:sSelf didSlideToItemAtindex:index];
                }
            }
            else{
                if (sSelf.delegate && [sSelf.delegate respondsToSelector:@selector(segmentContainer:didClickedItemAtIndex:)]) {
                    [self.delegate segmentContainer:sSelf didClickedItemAtIndex:index];
                }
            }
        }];
    }
    else{
        [self reLayoutIndicatorView];
        self.containerView.contentOffset = containOffset;
        [self scrollRectToVisibleCenteredOn:newBtn.frame animated:NO];
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentContainer:didSelectedItemAtIndex:)]) {
            [self.delegate segmentContainer:self didSelectedItemAtIndex:index];
        }
        if (slide) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(segmentContainer:didSlideToItemAtindex:)]) {
                [self.delegate segmentContainer:self didSlideToItemAtindex:index];
            }
        }
        else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(segmentContainer:didClickedItemAtIndex:)]) {
                [self.delegate segmentContainer:self didClickedItemAtIndex:index];
            }
        }
    }
}

- (CGRect)indicatorFrameForIndex:(NSInteger)index {
    CGRect rect = CGRectZero;
    
    if (self.averageSegmentation) {//平均分割模式下的indicator布局
        CGFloat averageWidth = self.topBar.width / self.itemCount;
        rect = CGRectMake(index * averageWidth, self.topBar.height - self.indicatorHeight, averageWidth, self.indicatorHeight);
    } else {
        UIButton *itemView = [self.itemViewArray safeObjectAtIndex:index];
        CGFloat realItemWidth = itemView.width - itemView.titleEdgeInsets.right;
        CGFloat indicatorWith = realItemWidth >= self.minIndicatorWidth ? realItemWidth : self.minIndicatorWidth;
        CGRect indicatorFrame = CGRectMake(itemView.left + 0.5*realItemWidth - 0.5*indicatorWith, self.topBar.height - self.indicatorHeight, indicatorWith, self.indicatorHeight);
        
        rect = indicatorFrame;
    }
    
    return rect;
}

- (void)reLayoutIndicatorView
{
    if (self.averageSegmentation) {//平均分割模式下的indicator布局
        CGFloat averageWidth = self.topBar.width / self.itemCount;
        self.indicatorView.frame = CGRectMake(self.currentIndex * averageWidth,
                                              self.topBar.height - self.indicatorHeight,
                                              averageWidth,
                                              self.indicatorHeight);
    } else {
        UIButton *itemView = [self.itemViewArray safeObjectAtIndex:self.currentIndex];
        CGFloat realItemWidth = itemView.width - itemView.titleEdgeInsets.right;
        CGFloat indicatorWith = realItemWidth >= self.minIndicatorWidth ? realItemWidth : self.minIndicatorWidth;
        CGRect indicatorFrame = CGRectMake(itemView.left + 0.5*realItemWidth - 0.5*indicatorWith, self.topBar.height - self.indicatorHeight, indicatorWith, self.indicatorHeight);
        self.indicatorView.frame = indicatorFrame;
    }
}

- (void)willScrollToIndex:(NSUInteger)index
{//做视图预加载，显示index页时，提前添加其前后页面
    //    [self addContentAtIndex:index - 1];
    [self addContentAtIndex:index];
    //    [self addContentAtIndex:index + 1];
}

- (void)addContentAtIndex:(NSInteger)index
{
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(segmentContainer:contentForIndex:)]) {
        return;
    }
    
    if (index < 0 || index >= self.itemCount) {
        return;
    }
    
    id content = [self.contentsDic safeObjectForKey:[self savedKeyForContentAtIndex:index]];
    if (content) {
        UIView *view = nil;
        if ([content isKindOfClass:[UIView class]]) {
            view = content;
        }else if ([content isKindOfClass:[UIViewController class]]){
            view = [(UIViewController *)content view];
        }
        if (view.left != index*self.containerView.width) {
            view.frame = CGRectMake(index*self.containerView.width, 0, self.containerView.width, self.containerView.height);
        }
    }
    else{
        content = [self.delegate segmentContainer:self contentForIndex:index];
        if (content) {
            if ([content respondsToSelector:@selector(setShouldScrollToTop:)]) {
                [content setShouldScrollToTop:NO];
            }
            [self.contentsDic safeSetObject:content forKey:[self savedKeyForContentAtIndex:index]];
            if ([content isKindOfClass:[UIView class]]) {
                UIView *contentView = (UIView *)content;
                contentView.frame = CGRectMake(index*self.containerView.width, 0, self.containerView.width, self.containerView.height);
                contentView.autoresizingMask |= UIViewAutoresizingFlexibleHeight;
                [self.containerView addSubview:contentView];
            }
            else if ([content isKindOfClass:[UIViewController class]]){
                UIViewController *vc = (UIViewController *)content;
                if (self.parentVC) {
                    [self.parentVC addChildViewController:vc];
                    [vc didMoveToParentViewController:self.parentVC];
                }
                vc.view.frame = CGRectMake(index*self.containerView.width, 0, self.containerView.width, self.containerView.height);
                [self.containerView addSubview:vc.view];
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(segmentContainer:preDisplayItemAtIndex:)]) {
                [self.delegate segmentContainer:self preDisplayItemAtIndex:index];
            }
        }
    }
}

- (NSString *)savedKeyForContentAtIndex:(NSUInteger)index
{
    return [NSString stringWithFormat:@"%lu",(unsigned long)index];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / scrollView.width;
    if (page != self.currentIndex) {
        [self scrollToItemAtIndex:page withAnimation:YES slide:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat factor = self.topBar.contentSize.width / self.containerView.contentSize.width;
    
    CGFloat moveWidth = scrollView.contentOffset.x - self.currentIndex*scrollView.width;
    
    CGRect rect = [self indicatorFrameForIndex:self.currentIndex];
    self.indicatorView.left = rect.origin.x + moveWidth*factor;
}




#pragma mark - config
- (void)setSelectedIndex:(NSUInteger)index withAnimated:(BOOL)animated
{
    if (!_didLoadData) {
        _currentIndex = index;
    }
    else{
        [self scrollToItemAtIndex:index withAnimation:animated slide:NO];
    }
}

- (UIButton *)itemAtIndex:(NSUInteger)index
{
    return [self.itemViewArray safeObjectAtIndex:index];
}

- (id)contentAtIndex:(NSUInteger)index
{
    return [self.contentsDic safeObjectForKey:[self savedKeyForContentAtIndex:index]];
}






#pragma mark - help
- (UIButton *)itemButtonForIndex:(NSUInteger)index
{
    if (self.delegate && index < self.itemCount && [self.delegate respondsToSelector:@selector(segmentContainer:titleForItemAtIndex:)]) {
        NSString *title = [self.delegate segmentContainer:self titleForItemAtIndex:index];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = itemView_start_tag + index;
        //        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2);
        
        button.titleLabel.font = self.titleFont;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        [button setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(itemButtonsClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [button sizeToFit];
        button.frame = CGRectMake(0, 0, button.width + self.indicatorOffset, self.topBar.height);
        
        return button;
        
    }
    return nil;
}

- (void)scrollRectToVisibleCenteredOn:(CGRect)visibleRect
                             animated:(BOOL)animated {
    CGRect centeredRect = CGRectMake(visibleRect.origin.x + visibleRect.size.width/2.0 - self.topBar.width/2.0,
                                     visibleRect.origin.y + visibleRect.size.height/2.0 - self.topBar.height/2.0,
                                     self.topBar.width,
                                     self.topBar.height);
    [self.topBar scrollRectToVisible:centeredRect
                            animated:animated];
}





#pragma mark - properties
- (UIScrollView *)topBar
{
    if (!_topBar) {
        _topBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.topBarHeight)];
        _topBar.showsHorizontalScrollIndicator = NO;
        _topBar.showsVerticalScrollIndicator = NO;
        _topBar.bounces = NO;
        _topBar.directionalLockEnabled = YES;
        _topBar.scrollsToTop = NO;
    }
    return _topBar;
}

- (UIScrollView *)containerView
{
    if (!_containerView) {
        _containerView = [[SegmentScrollView alloc] initWithFrame:CGRectMake(0, self.topBar.bottom, self.width, self.height - self.topBar.height)];
        _containerView.showsHorizontalScrollIndicator = NO;
        _containerView.showsVerticalScrollIndicator = NO;
        _containerView.bounces = NO;
        _containerView.pagingEnabled = YES;
        _containerView.directionalLockEnabled = YES;
        _containerView.delegate = self;
        _containerView.scrollsToTop = NO;
        _containerView.backgroundColor = self.containerBackgroundColor;
    }
    return _containerView;
}

- (UIImageView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.topBar.height - self.indicatorHeight, 1.0, self.indicatorHeight)];
        _indicatorView.backgroundColor = [UIColor redColor];
    }
    return _indicatorView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBar.bottom - self.bottomLineHeight, self.width, self.bottomLineHeight)];
        _lineView.backgroundColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
    }
    return _lineView;
}

- (NSMutableArray *)itemViewArray
{
    if (!_itemViewArray) {
        _itemViewArray = [[NSMutableArray alloc] init];
    }
    return _itemViewArray;
}

- (NSMutableDictionary *)contentsDic
{
    if (!_contentsDic) {
        _contentsDic = [[NSMutableDictionary alloc] init];
    }
    return _contentsDic;
}

- (UIColor *)titleNormalColor
{
    if (!_titleNormalColor) {
        _titleNormalColor = [UIColor darkGrayColor];
    }
    return _titleNormalColor;
}

- (UIColor *)titleSelectedColor
{
    if (!_titleSelectedColor) {
        _titleSelectedColor = [UIColor orangeColor];
    }
    return _titleSelectedColor;
}

- (UIColor *)indicatorColor {
    if (!_indicatorColor) {
        _indicatorColor = [UIColor orangeColor];
    }
    return _indicatorColor;
}

- (UIFont *)titleFont
{
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:13];
    }
    return _titleFont;
}

- (void)setContainerBackgroundColor:(UIColor *)containerBackgroundColor
{
    _containerBackgroundColor = containerBackgroundColor;
    self.containerView.backgroundColor = containerBackgroundColor;
}

- (void)setTopBarHeight:(CGFloat)topBarHeight
{
    _topBarHeight = topBarHeight;
    self.topBar.height = topBarHeight;
}

- (void)setAllowGesture:(BOOL)allowGesture
{
    _allowGesture = allowGesture;
    self.containerView.scrollEnabled = allowGesture;
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor
{
    _bottomLineColor = bottomLineColor;
    self.lineView.backgroundColor = bottomLineColor;
}

- (void)setBottomLineHeight:(CGFloat)bottomLineHeight
{
    _bottomLineHeight = bottomLineHeight;
    self.lineView.height = bottomLineHeight;
    self.lineView.bottom = self.topBar.height;
}

- (void)setIndicatorHeight:(CGFloat)indicatorHeight
{
    _indicatorHeight = indicatorHeight;
    self.indicatorView.height = indicatorHeight;
    self.indicatorView.bottom = self.topBar.height;
}


@end
