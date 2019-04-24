//
//  HBQuotationViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/2/13.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBQuotationViewController.h"
#import "HBQuotationCollectionViewCell.h"
#import "YTData_listModel+Request.h"
#import "SafeCategory.h"
#import "NSTimer+HB.h"
#import "HBQuotationListHeaderView.h"
#import "JXCategoryView.h"

@interface HBQuotationViewController () <UICollectionViewDelegate, UICollectionViewDataSource, HBQuotationListHeaderViewDelegate>

@property (strong, nonatomic) JXCategoryTitleView *categoryTitleView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) BOOL isFetchInProgress;

@property (nonatomic,strong)NSArray<YTData_listModel *> *originalModels;
@property (nonatomic,strong)NSArray<YTData_listModel *> *currentModels;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic,strong)NSArray<NSString *> *titles;
@property (nonatomic, strong) HBQuotationListHeaderView *sortHeaderView;
@property (nonatomic, strong) NSSortDescriptor *sortDescriptor;
@property (nonatomic, assign) BOOL isNeedReloadData;

@end

@implementation HBQuotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.categoryTitleView];
    [self.view addSubview:self.sortHeaderView];
    [self.view addSubview:self.collectionView];
    self.view.backgroundColor = kThemeBGColor;
    [self _fristLoadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _createTimer];
    [self.collectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _sortHeaderView.frame = CGRectMake(0, self.categoryTitleView.bottom, kScreenW, 30.);
    self.collectionView.frame = self.view.bounds;
    self.collectionView.y = self.sortHeaderView.bottom;
    self.collectionView.height = self.view.height - self.sortHeaderView.bottom;
    [self flowLayout].itemSize = self.collectionView.bounds.size;
}

#pragma mark - Private
- (void)_timerAction {
    [self loadData];
    [self _createTimer];
}

- (void)_createTimer {
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer _createRandomTimerWithTarget:self selector:@selector(_timerAction)];
}

- (void)_fristLoadData {
    kShowHud;
    [self loadData];
}

- (void)loadData{
    
    if (self.isFetchInProgress) {
        return;
    }
    self.isFetchInProgress = YES;
    
    [YTData_listModel requestQuotationsWithSuccess:^(NSArray<YTData_listModel *> * _Nonnull array, YWNetworkResultModel * _Nonnull obj) {
        self.isFetchInProgress = NO;
        kHideHud;
        self.originalModels  = array;
    } failure:^(NSError * _Nonnull error) {
        self.isFetchInProgress = NO;
        kHideHud;
        //        [self showTips:error.localizedDescription];
        if (error.code && self.originalModels.count == 0) {
            [[EmptyManager sharedManager] showNetErrorOnView:self.view response:error.localizedDescription operationBlock:^{
                [self loadData];
            }];
        }
    }];
    
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.currentModels.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HBQuotationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HBQuotationCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    cell.model = [self.currentModels safeObjectAtIndex:indexPath.item];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isNeedReloadData) {
        self.isNeedReloadData = NO;
        [self reloadCategoryTitleViewIfNeeded];
        [self.collectionView reloadData];
    }
}

#pragma mark - Getters & Setters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:HBQuotationCollectionViewCell.class forCellWithReuseIdentifier:@"HBQuotationCollectionViewCell"];
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumInteritemSpacing = 0.;
        _flowLayout.minimumLineSpacing = 0.;
    }
    return _flowLayout;
}

- (void)setOriginalModels:(NSArray<YTData_listModel *> *)originalModels {
    _originalModels = originalModels;
    if (self.sortDescriptor) {
        [self reloadDatatWithModels:_originalModels sortDescriptor:self.sortDescriptor];
    } else {
        [self reloadDataWithModels:_originalModels];
    }
}

- (JXCategoryTitleView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 45.)];
        _categoryTitleView.backgroundColor = kThemeColor;
        _categoryTitleView.titleSelectedColor = kColorFromStr(@"#FFD401");
        _categoryTitleView.titleColor = kColorFromStr(@"#7582A4");
        _categoryTitleView.titleFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
        lineView.indicatorLineViewColor = kColorFromStr(@"#FFD401");
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.contentScrollView = self.collectionView;
    }
    
    return _categoryTitleView;
}

- (HBQuotationListHeaderView *)sortHeaderView {
    if (!_sortHeaderView) {
        _sortHeaderView = [HBQuotationListHeaderView viewLoadNib];
        _sortHeaderView.delegate = self;
        
    }
    
    return _sortHeaderView;
}

#pragma mark - HBQuotationListHeaderViewDelegate

- (void)quotationListHeaderView:(HBQuotationListHeaderView *)view selectedName:(NSString *)selectedName status:(HBQuotationListHeaderViewStatus)status {
    
    BOOL asceding = YES;
    switch (status) {
        case HBQuotationListHeaderViewStatusOriginal:
            self.sortDescriptor = nil;
            [self reloadDataWithModels:self.originalModels];
            return;
            break;
            
        case HBQuotationListHeaderViewStatusAscending:
            asceding = YES;
            break;
            
        case HBQuotationListHeaderViewStatusDescending:
            asceding = NO;
            break;
    }
    if (!selectedName) {
        self.sortDescriptor = nil;
        [self reloadDataWithModels:self.originalModels];
    } else {
        NSSortDescriptor *sortDescriptor = nil;
        if (![selectedName isEqualToString:@"currency_mark"]) {
            sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:selectedName ascending:asceding comparator:^NSComparisonResult(NSString  *_Nonnull obj1, NSString  *_Nonnull obj2) {
                if ([obj1 doubleValue] < [obj2 doubleValue]) {
                    return NSOrderedAscending;
                } else if ([obj1 doubleValue] == [obj2 doubleValue]) {
                    return NSOrderedSame;
                } else {
                    return NSOrderedDescending;
                }
            }];
        } else {
            sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:selectedName ascending:asceding];
        }
        
        self.sortDescriptor = sortDescriptor;
        [self reloadDatatWithModels:self.originalModels sortDescriptor:self.sortDescriptor];
    }
    
}

#pragma mark - Reload Data

- (void)reloadDatatWithModels:(NSArray<YTData_listModel *> *)models sortDescriptor:(NSSortDescriptor *)sortDescriptor {
    NSArray<YTData_listModel *> *result = [YTData_listModel sortArray:models.copy sortDescriptor:self.sortDescriptor];
    [self reloadDataWithModels:result];
}

- (void)reloadDataWithModels:(NSArray<YTData_listModel *> *)models {
    self.currentModels = models;
    
    NSMutableArray *tmp = @[].mutableCopy;
    [self.currentModels enumerateObjectsUsingBlock:^(YTData_listModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tmp addObject:obj.name ?: @"--"];
    }];
    self.titles = tmp.copy;
    
    //when collectionView is dragging or decelerating, set isNeedReloadDatat to YES and directly return.
    if (self.collectionView.isDragging || self.collectionView.isDecelerating) {
        self.isNeedReloadData = YES;
        return;
    }
    [self reloadCategoryTitleViewIfNeeded];
    [self.collectionView reloadData];
}


/**
 when titles changed, reload data of self.categoryTitleView.
 */
- (void)reloadCategoryTitleViewIfNeeded {
    if (self.titles.count == 0 || ![self.titles isEqualToArray:self.categoryTitleView.titles]) {
        self.categoryTitleView.titles = self.titles;
        [self.categoryTitleView reloadData];
    }
}

@end
