//
//  YWHomeContainerTableViewController.m
//  ywshop
//
//  Created by 前海数交（ZJ） on 2018/8/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YWHomeContainerTableViewController.h"
#import "HMSegmentedControl.h"
#import "YWHomeContaineeCollectionViewController.h"
#import "YWHomeContainerCell.h"
#import "SDCycleScrollView.h"
#import "HBShopCategoryModel+Request.h"
#import "UIViewController+HBLoadingView.h"
#import "HBShopBannerModel+Request.h"

@interface YWHomeContainerTableViewController () <YWHomeContainerCellDelegate, SDCycleScrollViewDelegate>

@property (strong, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet YWHomeContainerCell *containerCell;

@property (nonatomic, assign) CGFloat containerCellHeight;

@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, strong) NSMutableArray<YWHomeContaineeCollectionViewController *> *containeeVCs;

@property (nonatomic, strong) NSArray<HBShopCategoryModel *> *categories;
@property (nonatomic, strong) NSArray<HBShopBannerModel *> *banners;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation YWHomeContainerTableViewController

#pragma mark - Lifecycle

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Shop" bundle:nil] instantiateViewControllerWithIdentifier:@"YWHomeContainerTableViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self _init];
    [self _setupView];
    [self _registerNotification];
    [self _requestCategories];
    [self _requestBanners];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.containerCellHeight = CGRectGetHeight(self.view.bounds) - kSegmentedControlHeight;
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    
//    self.containerCellHeight = CGRectGetHeight(self.view.bounds) - kSegmentedControlHeight;
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
}

#pragma mark - Private



- (void)_registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_homeContaineeViewControllerLeaveTop) name:YWHomeContaineeViewControllerLeaveTop object:nil];
}

- (void)_homeContaineeViewControllerLeaveTop {
    self.canScroll = YES;
}

- (void)_init {
    
    self.containerCell.delegate = self;
    self.canScroll = YES;
    
}


- (void)_createAndAddVCs {
    [self.containeeVCs enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj willMoveToParentViewController:nil];
        [obj.view removeFromSuperview];
        [obj removeFromParentViewController];
    }];
    
    
    self.containeeVCs = @[].mutableCopy;
    __weak typeof(self) weakSelf = self;
    [self.categories enumerateObjectsUsingBlock:^(HBShopCategoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YWHomeContaineeCollectionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YWHomeContaineeViewController"];
        [self addChildViewController:vc];
        [self.containeeVCs addObject:vc];
        vc.categoryModel = obj;
        vc.requestDidComplete = ^(NSError *error) {
            [weakSelf.tableView.mj_header endRefreshing];
            if (idx == 0) {
                [weakSelf.parentViewController hideLoadingView];
            }
        };
        [vc refresh];
    }];
    self.containerCell.containeeVCs = self.containeeVCs;
}


- (void)_setupView {
    
    self.tableView.scrollsToTop = NO;
    [self _setupCycleScrollView];
    [self _setupSegmentedControl];
    [self _setupTableView];
}

- (void)_setupTableView {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_refreshData)];
}

- (void)_refreshData {
//    [self.tableView.mj_header endRefreshing];
    YWHomeContaineeCollectionViewController *vc = [self _currentVC];
    [vc refresh];
    [self _requestBanners];
}

- (YWHomeContaineeCollectionViewController *)_currentVC {
    if ( self.segmentedControl.selectedSegmentIndex < self.containeeVCs.count) {
        return self.containeeVCs[self.segmentedControl.selectedSegmentIndex];
    }
    
    return nil;
}

- (void)_setupCycleScrollView {
    self.cycleScrollView.backgroundColor = kGrayLineColor;
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.autoScrollTimeInterval = 6.;
    self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
}

- (void)_setupSegmentedControl {
    self.segmentedControl.sectionTitles = @[@""];
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionIndicatorHeight = 2.5f;
    self.segmentedControl.selectionIndicatorColor = kColorFromStr(@"#4173C8");
    
    NSDictionary *attributesNormal = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Regular" size:17],NSFontAttributeName, [UIColor colorWithHexString:@"#666666"], NSForegroundColorAttributeName,nil];
    NSDictionary *attributesSelected = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Semibold" size:17],NSFontAttributeName, kColorFromStr(@"#4173C8"), NSForegroundColorAttributeName,nil];
    self.segmentedControl.titleTextAttributes = attributesNormal;
    self.segmentedControl.selectedTitleTextAttributes = attributesSelected;
    
    __weak typeof(self) weakSelf = self;
    self.segmentedControl.indexChangeBlock = ^(NSInteger index) {
        weakSelf.containerCell.selectedIndex = index;
        weakSelf.currentIndex = index;
    };
//    CALayer *layer = self.segmentedControl.layer;
//    layer.shadowOpacity = 0.3;
//    layer.shadowColor = [UIColor grayColor].CGColor;
//    layer.shadowRadius = 1.;
//    layer.shadowOffset = CGSizeMake(0, 1);
}

- (void)_requestCategories {
    [self.parentViewController showLoadingView];
    [HBShopCategoryModel requestCategoriesWithSuccess:^(NSArray<HBShopCategoryModel *> * _Nonnull models, YWNetworkResultModel * _Nonnull obj) {
        self.categories = models;
//        [self.parentViewController hideLoadingView];
        [[EmptyManager sharedManager] removeEmptyFromView:self.parentViewController.view];
    } failure:^(NSError * _Nonnull error) {
        [[EmptyManager sharedManager] showNetErrorOnView:self.parentViewController.view operationBlock:^{
            [self _requestCategories];
            [self _requestBanners];
        }];
        [self.parentViewController hideLoadingView];
        
    }];
}

- (void)_requestBanners {
    [HBShopBannerModel requestBannersWithSuccess:^(NSArray<HBShopBannerModel *> * _Nonnull models, YWNetworkResultModel * _Nonnull obj) {
        self.banners = models;
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - UITableViewDelegate

static CGFloat const kSegmentedControlHeight = 45.;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.segmentedControl;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSegmentedControlHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.containerCellHeight;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionY = [self.tableView rectForSection:0].origin.y;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= sectionY) {
        self.canScroll = NO;
        [self.tableView setContentOffset:CGPointMake(0, sectionY)];
    } else {
        if (!self.canScroll) {
            [self.tableView setContentOffset:CGPointMake(0, sectionY)];
        }
    }
}

#pragma mark - YWHomeContainerCellDelegate

- (void)containerCellScrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = scrollView.contentOffset.x / kScreenW;
    [self.segmentedControl setSelectedSegmentIndex:index animated:YES];
    self.currentIndex = index;
}

- (void)containerCellScrollViewBeginDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = scrollView.contentOffset.x / kScreenW;
    [self.segmentedControl setSelectedSegmentIndex:index animated:YES];
    self.currentIndex = index;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (index >= self.banners.count) {
        return;
    }
    
    HBShopBannerModel *model = self.banners[index];
    if (![model.link hasPrefix:@"http"]) {
        return;
    }
    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:model.link];
    
    kNavPush(vc);
}

#pragma mark - Setters

- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    
    [self.containeeVCs enumerateObjectsUsingBlock:^(UIViewController<YWHomeCanScrollConatineeProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.canScroll = !_canScroll;
    }];
}

- (void)setCategories:(NSArray<HBShopCategoryModel *> *)categories {
    if ([_categories isEqualToArray:categories]) {
        return;
    }
    _categories = categories;
    NSMutableArray *titles = @[].mutableCopy;
    [categories enumerateObjectsUsingBlock:^(HBShopCategoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titles addObject:obj.cat_name];
    }];
    
    self.segmentedControl.sectionTitles = titles.copy;
    [self _createAndAddVCs];
}


- (void)setBanners:(NSArray<HBShopBannerModel *> *)banners  {
    _banners = banners;
    
    NSMutableArray<NSString *> *imageURLs = @[].mutableCopy;
    [banners enumerateObjectsUsingBlock:^(HBShopBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageURLs addObject:obj.pic ?: @""];
    }];
    
    self.cycleScrollView.imageURLStringsGroup = imageURLs;
}

@end
