//
//  YTQuotationMenuViewController.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTQuotationMenuViewController.h"
#import "JXCategoryView.h"
#import "QuotationListViewController.h"
#import "QuotationViewController.h"

@interface YTQuotationMenuViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomConstraint;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryTitleView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *quotationLabel;


@property (nonatomic, strong) QuotationViewController *quotationViewController;

@end

@implementation YTQuotationMenuViewController

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Trade" bundle:nil] instantiateViewControllerWithIdentifier:@"YTQuotationMenuViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.containerView.backgroundColor = kThemeColor;
    
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.containerViewTopConstraint.constant = window.safeAreaInsets.top;
        self.containerViewBottomConstraint.constant = window.safeAreaInsets.bottom;
    } else {
        self.containerViewTopConstraint.constant = 20;
    }
    
    
    self.quotationLabel.text = kLocat(@"Quotation");
    
    self.quotationViewController = [[QuotationViewController alloc] initWithWidth:kScreenW * 0.85 + 2];
    __weak typeof(self) weakSelf = self;
    self.quotationViewController.isTypeOfMenu = YES;
    self.quotationViewController.didSelectCellBlock = ^(ListModel *model) {
        [weakSelf _didSelectModel:model];
    };
    [self _addChildVC:self.quotationViewController];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    //    CGFloat width = kScreenW * 0.85;
    CGRect frame = self.scrollView.bounds;
    frame.size.width = kScreenW;
    
    self.quotationViewController.view.frame = frame;
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
    [self.quotationViewController didMoveToParentViewController:self];
    [self.quotationViewController loadData];
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
    
    [self.quotationViewController didMoveToParentViewController:nil];
}

@end
