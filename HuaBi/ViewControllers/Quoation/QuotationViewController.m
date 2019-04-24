//
//  QuotationViewController.m
//  YJOTC
//
//  Created by l on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "QuotationViewController.h"
#import "SegmentContainer.h"

#import "YTData_listModel+Request.h"
#import "SafeCategory.h"
#import "EmptyManager.h"
#import "HBQuotationListHeaderView.h"
#import "NSTimer+HB.h"

@interface QuotationViewController ()<SegmentContainerDelegate, HBQuotationListHeaderViewDelegate>
@property (nonatomic,strong)SegmentContainer *container;
@property (nonatomic,strong)NSArray<NSString *> *titles;
@property (nonatomic,strong)NSArray *tagArray;
@property (nonatomic,strong)NSArray<YTData_listModel *> *originalModels;
@property (nonatomic,strong)NSArray<YTData_listModel *> *currentModels;
@property (nonatomic, assign) CGFloat myWidth;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL isFetchInProgress;

@property (nonatomic, strong) HBQuotationListHeaderView *sortHeaderView;
@property (nonatomic, strong) NSSortDescriptor *sortDescriptor;

@end

@implementation QuotationViewController

#pragma mark - Properties

- (instancetype)init {
    return [self initWithWidth:kScreenWidth];
}

- (instancetype)initWithWidth:(CGFloat)width {
    self = [super init];
    if (self) {
        self.myWidth = width;
    }
    return self;
}

- (SegmentContainer *)container {
    if (!_container) {
        _container = [[SegmentContainer alloc] initWithFrame:CGRectMake(0,0, self.myWidth,kScreenHeight)];
        _container.parentVC = self;
        _container.delegate = self;
        _container.averageSegmentation = NO;
        _container.titleFont = [PFRegularFont(16) fontWithBold];
        _container.titleNormalColor = kColorFromStr(@"#7582A4");
        _container.titleSelectedColor = kColorFromStr(@"#FFD401");
        //        _container.minIndicatorWidth = kScreenW/self.titleArray.count;
        _container.indicatorColor = kColorFromStr(@"#FFD401");
        _container.indicatorOffset = 20;

        _container.containerBackgroundColor = [UIColor whiteColor];
//        _container.topBar.backgroundColor = kColorFromStr(@"#0B132A");

        _container.containerBackgroundColor = kThemeBGColor;
        _container.topBar.backgroundColor = kThemeColor;
        
        _container.containerView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];

    }
    return _container;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.container];
    if (!self.isTypeOfMenu) {
        [self.view addSubview:self.sortHeaderView];
    }
    
    kShowHud;
    [self loadData];

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (!self.isTypeOfMenu) {
        self.sortHeaderView.frame = CGRectMake(0, self.container.topBarHeight, kScreenW, 30.);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _createTimer];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}


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

- (NSUInteger)numberOfItemsInSegmentContainer:(SegmentContainer *)segmentContainer {
    return self.currentModels.count;
}

- (id)segmentContainer:(SegmentContainer *)segmentContainer contentForIndex:(NSUInteger)index {
    QuotationListViewController *exchange = [QuotationListViewController new];
    YTData_listModel *model = [self.currentModels safeObjectAtIndex:index];
    exchange.list = model.data_list;
    exchange.tag = model.name;
    exchange.didSelectCellBlock = self.didSelectCellBlock;
    exchange.isTypeOfMenu = self.isTypeOfMenu;
    return exchange;
}

- (NSString *)segmentContainer:(SegmentContainer *)segmentContainer titleForItemAtIndex:(NSUInteger)index {
    return [self.titles safeObjectAtIndex:index];
}

#pragma mark - HBQuotationListHeaderViewDelegate

- (void)quotationListHeaderView:(HBQuotationListHeaderView *)view selectedName:(NSString *)selectedName status:(HBQuotationListHeaderViewStatus)status {
    
    BOOL asceding = YES;
    switch (status) {
        case HBQuotationListHeaderViewStatusOriginal:
            self.sortDescriptor = nil;
            [self reloadContainerWithModels:self.originalModels];
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
        [self reloadContainerWithModels:self.originalModels];
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
        [self reloadContainerWithModels:self.originalModels sortDescriptor:self.sortDescriptor];
    }
    
}

#pragma mark - Getters & Setters

- (HBQuotationListHeaderView *)sortHeaderView {
    if (!_sortHeaderView) {
        _sortHeaderView = [HBQuotationListHeaderView viewLoadNib];
        _sortHeaderView.delegate = self;
    }
    
    return _sortHeaderView;
}

- (void)setOriginalModels:(NSArray<YTData_listModel *> *)originalModels {
    _originalModels = originalModels;
    if (self.sortDescriptor) {
        [self reloadContainerWithModels:_originalModels sortDescriptor:self.sortDescriptor];
    } else {
        [self reloadContainerWithModels:_originalModels];
    }
}

#pragma mark - Reload Data

- (void)reloadContainerWithModels:(NSArray<YTData_listModel *> *)models sortDescriptor:(NSSortDescriptor *)sortDescriptor {
    NSArray<YTData_listModel *> *result = [YTData_listModel sortArray:models.copy sortDescriptor:self.sortDescriptor];
    [self reloadContainerWithModels:result];
}

- (void)reloadContainerWithModels:(NSArray<YTData_listModel *> *)models {
    self.currentModels = models;
    
    NSMutableArray *tmp = @[].mutableCopy;
    [self.currentModels enumerateObjectsUsingBlock:^(YTData_listModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tmp addObject:obj.name ?: @"--"];
    }];
    self.titles = tmp.copy;
    
    [self.container reloadData];
}

@end
