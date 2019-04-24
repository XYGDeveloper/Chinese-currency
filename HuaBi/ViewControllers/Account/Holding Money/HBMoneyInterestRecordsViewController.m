//
//  HBMoneyInterestRecordsViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/4.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMoneyInterestRecordsViewController.h"
#import "UIViewController+HBLoadingView.h"
#import "NSObject+SVProgressHUD.h"
#import "YWEmptyDataSetDataSource.h"
#import "HBBaseTableViewDataSource.h"
#import "HBMoneyInterestRecordsCell.h"
#import "HBMoneyInterestRecordsModel+Request.h"
#import "YBPopupMenu.h"

@interface HBMoneyInterestRecordsViewController () <YBPopupMenuDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *sectionContainerView;

@property (nonatomic, strong) HBBaseTableViewDataSource *tableViewDataSource;

@property (nonatomic, assign) BOOL isFetchInProgress;
@property (nonatomic, assign) BOOL noMoreData;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSArray<HBMoneyInterestRecordsModel *> *models;

@property (nonatomic, strong) YWEmptyDataSetDataSource *emptyDataSetDataSource;
@property (weak, nonatomic) IBOutlet UIButton *currencyButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sectionTopConstraint;

//names
@property (weak, nonatomic) IBOutlet UILabel *selectCurrencyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyTypeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberNameLabel;


@property (nonatomic, strong) NSArray<HBMoneyInterestRecordsModel *> *currenys;
@property (nonatomic, strong) NSArray<NSString *> *currenyNames;
@property (nonatomic, strong) HBMoneyInterestRecordsModel *selectedCurrency;
@end

static NSString *const kHBMoneyInterestRecordsCellIdentifier = @"HBMoneyInterestRecordsCell";

@implementation HBMoneyInterestRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    if (self.recordsType == HBMoneyInterestRecordsViewControllerDividend) {
        self.sectionTopConstraint.constant = 0;
        self.title = kLocat(@"Money Interest Dividend title");
    } else {
        self.title = kLocat(@"Money Interest Records title");
    }
    self.tableView.backgroundColor = kThemeBGColor;
    self.sectionContainerView.backgroundColor = kThemeColor;
    self.tableViewDataSource = [[HBBaseTableViewDataSource alloc] initWithItems:self.models cellIdentifier:kHBMoneyInterestRecordsCellIdentifier cellConfigureBlock:^(HBMoneyInterestRecordsCell  *_Nonnull cell, HBMoneyInterestRecordsModel  *_Nonnull model) {
        cell.model = model;
    }];
    self.tableView.dataSource = self.tableViewDataSource;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_refreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadData)];
    self.tableView.mj_footer.hidden = YES;
    
    self.emptyDataSetDataSource = [[YWEmptyDataSetDataSource alloc] initWithScrollView:self.tableView];
    self.tableView.emptyDataSetSource = self.emptyDataSetDataSource;
    self.tableView.emptyDataSetDelegate = self.emptyDataSetDataSource;
    [self _firstRequestData];
    
    self.currencyButton.layer.borderColor = kColorFromStr(@"#37415C").CGColor;
    self.currencyButton.layer.borderWidth = 1.;
    [self.currencyButton setTitle:[NSString stringWithFormat:@"%@ ", kLocat(@"OTC_order_all")] forState:UIControlStateNormal];
    self.currencyButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    [self _requestCurrencys];
    [self _setupNames];
}


#pragma mark - Private

- (void)_setupNames {
    
    self.selectCurrencyNameLabel.text = kLocat(@"Money Interest Records select currency");
    self.currencyTypeNameLabel.text = kLocat(@"Money Interest Records Currency");
    
    if (self.recordsType == HBMoneyInterestRecordsViewControllerDividend) {
        self.timeNameLabel.text = kLocat(@"Money Interest Dividend time");
        self.numberNameLabel.text = kLocat(@"Money Interest Dividend number");
    } else {
        self.timeNameLabel.text = kLocat(@"Money Interest Records time");
        self.numberNameLabel.text = kLocat(@"Money Interest Records number");
    }
}

- (void)_firstRequestData {
    [self showLoadingView];
    [self _refreshData];
}

- (void)_refreshData {
    [self _requestRecordsWithIsRefresh:YES];
}

- (void)_loadData {
    [self _requestRecordsWithIsRefresh:NO];
}

static NSInteger const kPageSize = 10;
- (void)_requestRecordsWithIsRefresh:(BOOL)isRefresh {
    
    if (self.isFetchInProgress) {
        return;
    }
    
    self.isFetchInProgress = YES;
    
    if (isRefresh) {
        self.currentPage = 1;
    }
    
    [HBMoneyInterestRecordsModel requestMoneyInterestRecordsByCurrencyID:self.selectedCurrency.currency_id isDividend:self.recordsType == HBMoneyInterestRecordsViewControllerDividend page:self.currentPage success:^(NSArray<HBMoneyInterestRecordsModel *> *array, YWNetworkResultModel *obj) {
        self.currentPage++;
        self.noMoreData = array.count < kPageSize;
        self.isFetchInProgress = NO;
        if (isRefresh) {
            self.models = array;
        } else {
            if (array.count > 0) {
                NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray:self.models];
                [tmp addObjectsFromArray:array];
                self.models = tmp.copy;
            }
        }
        [self hideLoadingView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.emptyDataSetDataSource.title = kLocat(@"empty_msg");
    } failure:^(NSError *error) {
        self.emptyDataSetDataSource.title = kLocat(error.localizedDescription);
        [self hideLoadingView];
        self.isFetchInProgress = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showInfoWithMessage:error.localizedDescription];
    }];
    
}

- (void)_requestCurrencys {
    [HBMoneyInterestRecordsModel requestMoneyInterestCurrencysWithSuccess:^(NSArray<HBMoneyInterestRecordsModel *> *array, YWNetworkResultModel *obj) {
        self.currenys = array;
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Actions

- (IBAction)showMenuAction:(UIButton *)sender {
    self.currencyButton.selected = YES;
    [self menuPop:sender];
}
-(void)menuPop:(UIButton *)button{
    
    CGPoint point = [button convertPoint:CGPointMake(button.centerX - 10, button.height - 5) toView:nil];
    
    [YBPopupMenu showAtPoint:point titles:self.currenyNames icons:nil menuWidth:84 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.fontSize = 14;
        popupMenu.textColor = kWhiteColor;
        popupMenu.delegate = self;
        popupMenu.backColor = kColorFromStr(@"#37415C");
        popupMenu.arrowWidth = 0.;
        popupMenu.maxVisibleCount = 4;
        popupMenu.itemHeight = 35;
        popupMenu.borderWidth = 0;
        popupMenu.arrowPosition = YBPopupMenuPriorityDirectionNone;
        
    }];
    
}



- (HBMoneyInterestRecordsModel *)currencyAtIndex:(NSInteger)index {
    if (index < self.currenys.count) {
        return self.currenys[index];
    }
    
    return nil;
}

-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {

    self.selectedCurrency = [self currencyAtIndex:index];
}

- (void)ybPopupMenuDidDismiss {
    self.currencyButton.selected = NO;
}

#pragma mark - Setters

- (void)setModels:(NSArray *)models {
    _models = models;
    self.tableViewDataSource.items = models;
     self.tableView.mj_footer.hidden = models.count < 5;
    [self.tableView reloadData];
}

- (void)setNoMoreData:(BOOL)noMoreData {
    _noMoreData = noMoreData;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_noMoreData) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer resetNoMoreData];
        }
        [self.tableView.mj_footer setNeedsDisplay];
    });
    
}

- (void)setCurrenys:(NSArray<HBMoneyInterestRecordsModel *> *)currenys {
    HBMoneyInterestRecordsModel *model = [HBMoneyInterestRecordsModel new];
    model.currency_name = kLocat(@"OTC_order_all");
    NSMutableArray *tmp = [currenys mutableCopy];
    [tmp insertObject:model atIndex:0];
    
    _currenys = tmp.copy;
    NSMutableArray<NSString *> *tmpStrings = @[].mutableCopy;
    [_currenys enumerateObjectsUsingBlock:^(HBMoneyInterestRecordsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tmpStrings addObject:obj.currency_name ?: @""];
    }];
    self.currenyNames = tmpStrings.copy;
}

- (void)setSelectedCurrency:(HBMoneyInterestRecordsModel *)selectedCurrency {
    _selectedCurrency = selectedCurrency;
    [self.currencyButton setTitle:[NSString stringWithFormat:@"%@ ", selectedCurrency.currency_name] forState:UIControlStateNormal];
    [self.tableView.mj_header beginRefreshing];
}

@end
