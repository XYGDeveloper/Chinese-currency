//
//  YTQuotationMenuViewController.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTQuotationMenuViewController.h"
#import "JXCategoryView.h"
#import "YTQuotationTableViewController.h"
#import "QuotationListViewController.h"

@interface YTQuotationMenuViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomConstraint;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryTitleView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *quotationLabel;

@property (nonatomic, strong) QuotationListViewController *atQuotationVC;
@property (nonatomic, strong) QuotationListViewController *optionQuotationVC;

@end

@implementation YTQuotationMenuViewController

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Trade" bundle:nil] instantiateViewControllerWithIdentifier:@"YTQuotationMenuViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CGFloat bottomInset = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.containerViewTopConstraint.constant = window.safeAreaInsets.top;
        self.containerViewBottomConstraint.constant = window.safeAreaInsets.bottom;
    } else {
        self.containerViewTopConstraint.constant = 20;
    }
    
//    self.containerViewBottomConstraint.constant = bottomInset;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
    lineView.indicatorLineViewColor = kPurpleColor;
    self.categoryTitleView.indicators = @[lineView];
    self.categoryTitleView.titles = @[kLocat(@"Option"), @"AT"];
    self.categoryTitleView.titleSelectedColor = kPurpleColor;
    self.categoryTitleView.contentScrollView = self.scrollView;
    self.categoryTitleView.titleColor = kColorFromStr(@"#333333");
    
    [self.categoryTitleView setDefaultSelectedIndex:1];
    
    self.atQuotationVC = [QuotationListViewController new];
    self.atQuotationVC.tag = @"AT";
    __weak typeof(self) weakSelf = self;
    self.atQuotationVC.didSelectCellBlock = ^(ListModel *model) {
        [weakSelf _didSelectModel:model];
    };
    
    self.optionQuotationVC = [QuotationListViewController new];
    self.optionQuotationVC.tag = @"ZX";
    self.optionQuotationVC.didSelectCellBlock = ^(ListModel *model) {
        [weakSelf _didSelectModel:model];
    };
    
    [self _addChildVC:self.optionQuotationVC];
    [self _addChildVC:self.atQuotationVC];
    
    self.quotationLabel.text = kLocat(@"Quotation");
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat width = kScreenW * 0.85;
    self.scrollView.contentSize = CGSizeMake(width * self.childViewControllers.count, 0);
    
    
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = idx *width;
        frame.size.width = width;
        obj.view.frame = frame;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

#pragma mark - Private

- (void)_didSelectModel:(ListModel *)model {
    if (self.didSelectModelBlock) {
        self.didSelectModelBlock(model);
    }
    [self hide];
}

- (void)_addChildVC:(UIViewController *)vc {
    [self addChildViewController:vc];
    [self.scrollView addSubview:vc.view];
    [vc didMoveToParentViewController:self];
}

- (IBAction)_backAction:(id)sender {
    [self hide];
}

#pragma mark - Public

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController addChildViewController:self];
    [self didMoveToParentViewController:window.rootViewController];
    [window addSubview:self.view];
    
    
    self.containerView.x = - kScreenW * 0.85;
    self.view.alpha = 0.01;
    [UIView animateWithDuration:0.1 animations:^{
        self.view.alpha = 1;
    }];
    [UIView animateWithDuration:0.2 delay:0.1 options:(7 << 16) |UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.containerView.x = 0;
    } completion:nil];
}

- (void)hide {
    
    [UIView animateWithDuration:0.2 delay:0 options:(7 << 16) animations:^{
        self.containerView.x = - kScreenW * 0.85;
    } completion:nil];
    
    [UIView animateWithDuration:0.1 delay:0.15 options:(7 << 16) animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

@end
