//
//  KTActionSheet.m
//  
//
//  Created by hcl on 15/10/13.
//
//

#import "HClActionSheet.h"
#import "HClSheetView.h"
#import "HClSheetHead.h"
#import "HClSheetFoot.h"

#define kWH ([[UIScreen mainScreen] bounds].size.height)
#define kWW ([[UIScreen mainScreen] bounds].size.width)
#define kMW (kWW - 2 * kMargin)
#define kCellH 50
#define kMargin 5

@interface HClActionSheet()<KTSheetViewDelegate>
@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UIButton *bgButton;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) HClSheetView *sheetView;
@property (strong, nonatomic) HClSheetHead *titleView;
@property (strong, nonatomic) HClSheetFoot *footView;
@property (strong, nonatomic) UIView *marginView;
@property (assign, nonatomic) CGFloat contentVH;
@property (assign, nonatomic) CGFloat contentViewY;
@property (assign, nonatomic) CGFloat footViewY;

@property (strong, nonatomic) NSIndexPath *selectIndex;
@property (strong, nonatomic) SelectIndexBlock selectBlock;
@property (strong, nonatomic) NSArray *dataSource;
@property (assign, nonatomic) HClSheetStyle sheetStyle;
@end

@implementation HClActionSheet

- (instancetype)initWithTitle:(NSString *)title style:(HClSheetStyle)style itemTitles:(NSArray *)itemTitles
{
    if (self = [super init]) {
        _sheetStyle = style;
        if (style == HClSheetStyleDefault) {
            self = [self upDefaultStyeWithItems:itemTitles title:title selfView:self];
            [self pushDefaultStyeSheetView];
        }
        else if (style == HClSheetStyleWeiChat) {
            self = [self upWeiChatStyeWithItems:itemTitles title:title selfView:self];
            [self pushWeiChatStyeSheetView];
        }
    }
    return self;
}

///初始化默认样式
- (id)upDefaultStyeWithItems:(NSArray *)itemTitles title:(NSString *)title selfView:(HClActionSheet *)selfView
{
    selfView.dataSource = itemTitles;
    int cellCount = (int)itemTitles.count;
    [[[UIApplication sharedApplication].delegate window].rootViewController.view addSubview:selfView];
    selfView.view = [[UIApplication sharedApplication].delegate window].rootViewController.view;
    //半透明背景按钮
    selfView.bgButton = [[UIButton alloc] init];
    [selfView.view addSubview:selfView.bgButton];
    [selfView.bgButton addTarget:self action:@selector(dismissDefaulfSheetView) forControlEvents:UIControlEventTouchUpInside];
    selfView.bgButton.backgroundColor = [UIColor blackColor];
    selfView.bgButton.alpha = 0.35;
    selfView.bgButton.frame = CGRectMake(0, 0, kWW, kWH);
    
    selfView.contentView = [[UIView alloc] init];
    [selfView.view addSubview:selfView.contentView];
    
    selfView.footView = [[NSBundle mainBundle] loadNibNamed:@"HClSheetFoot" owner:selfView options:nil].lastObject;
    [selfView.view addSubview:selfView.footView];
    
    //标题
    BOOL isTitle = NO;
    if (title.length > 0) {
        selfView.titleView = [[NSBundle mainBundle] loadNibNamed:@"HClSheetHead" owner:selfView options:nil].lastObject;
        selfView.titleView.headLabel.text = title;
        isTitle = YES;
        [selfView.contentView addSubview:selfView.titleView];
    }
    
    //选择TableView
    selfView.sheetView = [[NSBundle mainBundle] loadNibNamed:@"HClSheetView" owner:selfView options:nil].lastObject;
    selfView.sheetView.delegate = selfView;
    selfView.sheetView.dataSource = selfView.dataSource;
    [selfView.contentView addSubview:selfView.sheetView];
    
    //布局子控件
    selfView.contentVH = kCellH * (cellCount + isTitle);
    CGFloat maxH = 350;
    if (selfView.contentVH > maxH) {
        selfView.contentVH = maxH;
        selfView.sheetView.tableView.scrollEnabled = YES;
    } else {
        selfView.sheetView.tableView.scrollEnabled = NO;
    }
    
    selfView.footViewY = kWH - kCellH - kMargin;
    selfView.footView.frame = CGRectMake(kMargin, selfView.footViewY + selfView.contentVH, kMW, kCellH);
    
    selfView.contentViewY = kWH - CGRectGetHeight(selfView.footView.frame) - selfView.contentVH - 10;
    selfView.contentView.frame = CGRectMake(kMargin, kWH, kMW, selfView.contentVH);
    
    CGFloat sheetY = 0;
    CGFloat sheetH = CGRectGetHeight(selfView.contentView.frame);
    if (isTitle) {
        selfView.titleView.frame = CGRectMake(0, 0, kMW, kCellH);
        sheetY = CGRectGetHeight(selfView.titleView.frame);
        sheetH = CGRectGetHeight(selfView.contentView.frame) - CGRectGetHeight(selfView.titleView.frame);
    }
    selfView.sheetView.frame = CGRectMake(0, sheetY, kMW, sheetH);
    [UIColor darkGrayColor];
    //设置圆角
    selfView.contentView.layer.cornerRadius = 3;
    selfView.contentView.layer.masksToBounds = YES;
    selfView.footView.layer.cornerRadius = 3;
    selfView.footView.layer.masksToBounds = YES;
    
    [selfView.footView.footButton addTarget:selfView action:@selector(dismissDefaulfSheetView) forControlEvents:UIControlEventTouchUpInside];
    return selfView;
}

///初始化微信样式
- (id)upWeiChatStyeWithItems:(NSArray *)itemTitles title:(NSString *)title selfView:(HClActionSheet *)selfView
{
    selfView.dataSource = itemTitles;
    int cellCount = (int)itemTitles.count;
    [[[UIApplication sharedApplication].delegate window].rootViewController.view addSubview:selfView];
    selfView.view = [[UIApplication sharedApplication].delegate window].rootViewController.view;
    //半透明背景按钮
    selfView.bgButton = [[UIButton alloc] init];
    [selfView.view addSubview:selfView.bgButton];
    [selfView.bgButton addTarget:selfView action:@selector(dismissWeiChatStyeSheetView) forControlEvents:UIControlEventTouchUpInside];
    selfView.bgButton.backgroundColor = [UIColor blackColor];
    selfView.bgButton.alpha = 0.35;
    selfView.bgButton.frame = CGRectMake(0, 0, kWW, kWH);
    
    selfView.contentView = [[UIView alloc] init];
    [selfView.view addSubview:selfView.contentView];
    
    selfView.footView = [[NSBundle mainBundle] loadNibNamed:@"HClSheetFoot" owner:selfView options:nil].lastObject;
    [selfView.view addSubview:selfView.footView];
    [selfView.footView.footButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selfView.footView.footButton.titleLabel.font = [UIFont systemFontOfSize:18];
    if ([[UIScreen mainScreen] bounds].size.height == 667) {
        selfView.footView.footButton.titleLabel.font = [UIFont systemFontOfSize:20];
    }
    else if ([[UIScreen mainScreen] bounds].size.height > 667) {
        selfView.footView.footButton.titleLabel.font = [UIFont systemFontOfSize:21];
    }
    
    //中间空隙
    selfView.marginView = [[UIView alloc] init];
    selfView.marginView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    selfView.alpha = 0.0;
    [selfView.view addSubview:selfView.marginView];
    
    //标题
    BOOL isTitle = NO;
    if (title.length > 0) {
        selfView.titleView = [[NSBundle mainBundle] loadNibNamed:@"HClSheetHead" owner:selfView options:nil].lastObject;
        selfView.titleView.headLabel.text = title;
        isTitle = YES;
        [selfView.contentView addSubview:selfView.titleView];
    }
    
    //选择TableView
    selfView.sheetView = [[NSBundle mainBundle] loadNibNamed:@"HClSheetView" owner:selfView options:nil].lastObject;
    selfView.sheetView.delegate = selfView;
    selfView.sheetView.dataSource = selfView.dataSource;
    selfView.sheetView.cellTextColor = [UIColor blackColor];
    [selfView.contentView addSubview:selfView.sheetView];
    
    //布局子控件
    selfView.contentVH = kCellH * (cellCount + isTitle);
    CGFloat maxH = 350;
    if (selfView.contentVH > maxH) {
        selfView.contentVH = maxH;
        selfView.sheetView.tableView.scrollEnabled = YES;
    } else {
        selfView.sheetView.tableView.scrollEnabled = NO;
    }
    
    selfView.footViewY = kWH - kCellH;
    selfView.footView.frame = CGRectMake(0, selfView.footViewY + selfView.contentVH, kWW, kCellH);
    
    selfView.contentViewY = kWH - CGRectGetHeight(selfView.footView.frame) - selfView.contentVH - kMargin;
    selfView.contentView.frame = CGRectMake(0, kWH, kWW, selfView.contentVH);
    
    CGFloat sheetY = 0;
    CGFloat sheetH = CGRectGetHeight(selfView.contentView.frame);
    if (isTitle) {
        selfView.titleView.frame = CGRectMake(0, 0, kWW, kCellH);
        sheetY = CGRectGetHeight(selfView.titleView.frame);
        sheetH = CGRectGetHeight(selfView.contentView.frame) - CGRectGetHeight(selfView.titleView.frame);
    }
    selfView.sheetView.frame = CGRectMake(0, sheetY, kWW, sheetH);
    selfView.marginView.frame = CGRectMake(0, kWH + sheetH, kWW, kMargin);
    
    [selfView.footView.footButton addTarget:self action:@selector(dismissWeiChatStyeSheetView) forControlEvents:UIControlEventTouchUpInside];
    return selfView;
}

//显示默认样式
- (void)pushDefaultStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.contentView.frame = CGRectMake(kMargin, weakSelf.contentViewY, kMW, weakSelf.contentVH);
        weakSelf.footView.frame = CGRectMake(kMargin, weakSelf.footViewY, kMW, kCellH);
        weakSelf.bgButton.alpha = 0.35;
    }];
}

//显示像微信的样式
- (void)pushWeiChatStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.contentView.frame = CGRectMake(0, weakSelf.contentViewY, kWW, weakSelf.contentVH);
        weakSelf.footView.frame = CGRectMake(0, weakSelf.footViewY, kWW, kCellH);
        weakSelf.marginView.frame = CGRectMake(0, weakSelf.footViewY - kMargin, kWW, kMargin);
        weakSelf.bgButton.alpha = 0.35;
        weakSelf.marginView.alpha = 1.0;
    }];
}

//消失默认样式
- (void)dismissDefaulfSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.contentView.frame = CGRectMake(kMargin, kWH, kMW, weakSelf.contentVH);
        weakSelf.footView.frame = CGRectMake(kMargin, weakSelf.footViewY + weakSelf.contentVH, kMW, kCellH);
        weakSelf.bgButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.contentView removeFromSuperview];
        [weakSelf.footView removeFromSuperview];
        [weakSelf.bgButton removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

//消失微信样式
- (void)dismissWeiChatStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.contentView.frame = CGRectMake(0, kWH, kWW, weakSelf.contentVH);
        weakSelf.footView.frame = CGRectMake(0, weakSelf.footViewY + weakSelf.contentVH, kMW, kCellH);
        weakSelf.marginView.frame = CGRectMake(0, kWH + CGRectGetHeight(weakSelf.contentView.frame) + CGRectGetHeight(weakSelf.titleView.frame), kWW, kMargin);
        weakSelf.bgButton.alpha = 0.0;
        weakSelf.marginView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.contentView removeFromSuperview];
        [weakSelf.footView removeFromSuperview];
        [weakSelf.marginView removeFromSuperview];
        [weakSelf.bgButton removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

- (void)setTitleTextFont:(UIFont *)titleTextFont
{
    _titleView.headLabel.font = titleTextFont;
}

- (void)setTitleTextColor:(UIColor *)titleTextColor
{
    if (titleTextColor) {
        _titleView.headLabel.textColor = titleTextColor;
    }
}

- (void)setItemTextFont:(UIFont *)itemTextFont
{
    if (itemTextFont) {
        _sheetView.cellTextFont = itemTextFont;
    }
}

- (void)setItemTextColor:(UIColor *)itemTextColor
{
    if (itemTextColor) {
        _sheetView.cellTextColor = itemTextColor;
    }
}

- (void)setCancleTextFont:(UIFont *)cancleTextFont
{
    if (cancleTextFont) {
        [_footView.footButton.titleLabel setFont:cancleTextFont];
    }
}

- (void)setCancleTextColor:(UIColor *)cancleTextColor
{
    if (cancleTextColor) {
        [_footView.footButton setTitleColor:cancleTextColor forState:UIControlStateNormal];
    }
}

- (void)setCancleTitle:(NSString *)cancleTitle
{
    if (cancleTitle) {
        [_footView.footButton setTitle:cancleTitle forState:UIControlStateNormal];
    }
}

- (void)didFinishSelectIndex:(SelectIndexBlock)block
{
    _selectBlock = block;
}

//点击了哪行
- (void)sheetViewDidSelectIndex:(NSInteger)Index selectTitle:(NSString *)title
{
    if (_selectBlock) {
        _selectBlock(Index,title);
    }
    
    if ([self.delegate respondsToSelector:@selector(sheetViewDidSelectIndex:title:)]) {
        [self.delegate sheetViewDidSelectIndex:Index title:title];
    }
    
    if ([self.delegate respondsToSelector:@selector(sheetViewDidSelectIndex:title:sender:)]) {
        [self.delegate sheetViewDidSelectIndex:Index title:title sender:self];
    }
    if (_sheetStyle == HClSheetStyleDefault) {
        [self dismissDefaulfSheetView];
    }
    else if (_sheetStyle == HClSheetStyleWeiChat) {
        [self dismissWeiChatStyeSheetView];
    }
}

@end
