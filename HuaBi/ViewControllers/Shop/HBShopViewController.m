//
//  HBShopViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/3/22.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBShopViewController.h"
#import "YWHomeContainerTableViewController.h"
#import "YBPopupMenu.h"
#import "HBShoppingCartViewController.h"
#import "NSObject+SVProgressHUD.h"
#import "HBAddressListViewController.h"
#import "HBOrderManagementWebViewController.h"

@interface HBShopViewController () <YBPopupMenuDelegate, UISearchBarDelegate>

@property (nonatomic, strong) YWHomeContainerTableViewController *containerVC;
@property (nonatomic, strong) UIButton *itemButton;
@property (nonatomic, strong) UIButton *trackButton;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation HBShopViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.containerVC = [YWHomeContainerTableViewController fromStoryboard];
    [self addChildViewController:self.containerVC];
    [self.view addSubview:self.containerVC.view];
    [self.containerVC didMoveToParentViewController:self];
    [self _setupNavigationItem];
    
    [self.view addSubview:self.trackButton];
    self.trackButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view.trailingAnchor constraintEqualToAnchor:self.trackButton.trailingAnchor constant:28].active = YES;
    [self.view.bottomAnchor constraintEqualToAnchor:self.trackButton.bottomAnchor constant:42].active = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.containerVC.view.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.trackButton.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.7 delay:0.1 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.trackButton.transform = CGAffineTransformIdentity;
    } completion:nil];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.view setNeedsLayout];// force update layout
    [self.navigationController.view layoutIfNeeded]; // to fix height of the navigation bar
}

#pragma mark - Private

- (void)_setupNavigationItem {
    UIButton *itemButton = [UIButton new];
    [itemButton setImage:[UIImage imageNamed:@"gdl_icon"] forState:UIControlStateNormal];
    [itemButton addTarget:self action:@selector(_showMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    itemButton.size = CGSizeMake(30, 44.);
    self.itemButton = itemButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    
    self.navigationItem.titleView = self.searchBar;
//    if (@available(iOS 11.0, *)) {
//        [self.searchBar.heightAnchor constraintEqualToConstant:44].active = YES;
//    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kLocat(@"HBShopViewController_Title") style:UIBarButtonItemStylePlain target:nil action:nil];
}

-(void)_showMenuPop{
    
    CGFloat y = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGPoint point = [self.itemButton convertPoint:CGPointMake(self.itemButton.centerX, y + 10) toView:nil];
    NSArray<NSString *> *titles = @[
                                    kLocat(@"HBShopViewController_Order_management"),
                                    kLocat(@"HBShopViewController_shopping cart"),
                                    kLocat(@"HBShopViewController_Shipping address"),
                                    kLocat(@"HBShopViewController_Merchant"),
                                    kLocat(@"HBShopViewController_Expenses record")
                                    ];
    NSArray<NSString *> *icons = @[
                                   @"xl01_icon-item",
                                   @"xl02_icon-item",
                                   @"xl03_icon-item",
                                   @"xl04_icon",
                                   @"xl05_icon"
                                   ];
    [YBPopupMenu showAtPoint:point titles:titles icons:icons menuWidth:185 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.fontSize = 14;
        popupMenu.textColor = kWhiteColor;
        popupMenu.delegate = self;
        popupMenu.backColor = [kColorFromStr(@"#37415C") colorWithAlphaComponent:0.8];
        popupMenu.itemHeight = 42;
        popupMenu.borderWidth = 0;
    }];
}


#pragma mark - YBPopupMenuDelegate

-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    
    if ([Utilities isExpired]) {
        [self gotoLoginVC];
        return;
    }
    
    switch (index) {
        case 0: {
            HBOrderManagementWebViewController *vc = [[HBOrderManagementWebViewController alloc] initOrderManagmentVC];
            kNavPush(vc);
        }
            break;
            
        case 1: {
            HBShoppingCartViewController *vc = [HBShoppingCartViewController fromStroyboard];
            kNavPush(vc);
        }
            break;
            
        case 2: {
            HBAddressListViewController *vc = [HBAddressListViewController new];
            kNavPush(vc);
        }
            break;
            
        default:
            [self showInfoWithMessage:kLocat(@"HBShopViewController_Coming_Soon")];
            break;
    }
}

- (void)ybPopupMenuBeganDismiss {
    [self _rerotateButton];
}

#pragma mark - Actions

- (void)_showMenuAction:(UIButton *)button {
   
    [self _showMenuPop];
    [self _rotateButton];
}

- (void)_rotateButton {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI_4);
    animation.duration = 0.2;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.itemButton.layer addAnimation:animation forKey:nil];
}

- (void)_rerotateButton {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = @(M_PI_4);
    animation.toValue = @(0);
    animation.duration = 0.2;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.itemButton.layer addAnimation:animation forKey:nil];
}

- (void)_showTracksAction {
    [self showInfoWithMessage:kLocat(@"HBShopViewController_Coming_Soon")];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    searchBar.becomeFirstResponder = NO;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //
    [self showInfoWithMessage:kLocat(@"HBShopViewController_Coming_Soon")];
    return NO;
}

#pragma mark - Getters & Setters

- (UIButton *)trackButton {
    if (!_trackButton) {
        _trackButton = [UIButton new];
        [_trackButton setImage:[UIImage imageNamed:@"zji_icon"] forState:UIControlStateNormal];
        [_trackButton sizeToFit];
        [_trackButton addTarget:self action:@selector(_showTracksAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _trackButton;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [UISearchBar new];
        _searchBar.delegate = self;
        _searchBar.placeholder = kLocat(@"HBShopViewController_Search_Goods");
//        _searchBar.barStyle = UISearchBarStyleMinimal;
//        _searchBar.userInteractionEnabled = NO;
    }
    
    return _searchBar;
}

@end
