//
//  TPOTCBuyListController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyOrSellListController.h"
#import "TPOTCBuyListCell.h"
#import "TPOTCBuyOrderDetailController.h"
#import "TPOTCProfileViewController.h"
#import "HBOTCTradeInfoDetailTableViewController.h"
#import "ZJPayPopupView.h"
#import "HBOTCTradeBankModel+Request.h"
#import "YWAlert.h"
#import "TPOTCPayWayListController.h"
#import "TPOTCBuyListCellDelegate.h"

@interface TPOTCBuyOrSellListController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray<TPOTCOrderModel *> *dataArray;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isRefresh;

@property(nonatomic,strong)NTESVerifyCodeManager *manager;

@property(nonatomic,copy)NSString *verifyStr;

@property (nonatomic, strong) ZJPayPopupView *payPopupView;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSArray<NSString *> *myPayWays;

@property (nonatomic, strong) TPOTCBuyListCellDelegate *buyListCellDelegate;

@end

@implementation TPOTCBuyOrSellListController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [NSMutableArray array];

    [self setupUI];
    //刷新页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"kUserDidPostAdKey" object:nil];
    self.buyListCellDelegate = [[TPOTCBuyListCellDelegate alloc] initWithViewController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.buyListCellDelegate requestMyPaywas];
}

/**  发布了新广告之后刷新页面  */
-(void)refreshData:(NSNotification *)noti
{
    if ([noti.object isEqualToString:_model.currencyID]) {
        _page = 1;
        [self loadDataWith:_page];
    }
}



-(void)setupUI
{
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,0, kScreenW, kScreenH-kNavigationBarHeight - 44 - 44) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    
    _tableView.backgroundColor = kColorFromStr(@"#171F34");
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCBuyListCell" bundle:nil] forCellReuseIdentifier:@"TPOTCBuyListCell"];
    

    
    __weak typeof(self)weakSelf = self;

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        _isRefresh = YES;
        [weakSelf loadDataWith:_page];
    }];
    
    [_tableView.mj_header beginRefreshing];
    
}

#pragma mark - Private

-(void)loadDataWith:(NSInteger)page
{
    __weak typeof(self)weakSelf = self;

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"currency_id"] = _model.currencyID;
    param[@"page"] = @(page);
    NSString *apiURI = self.isTypeOfBuy ? @"OrdersOtc/sell_order" : @"OrdersOtc/buy_order";
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:apiURI] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [[EmptyManager sharedManager] removeEmptyFromView:self.view];
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData];

            if (datas.count == 0 && _dataArray.count == 0) {
//                [self showTips:kLocat(@"OTC_buylist_noorder")];
                
                [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"OTC_buylist_noorder") operationText:kLocat(@"OTC_empty_tips") operationBlock:^{
                    [weakSelf.tableView.mj_header beginRefreshing];
                    [[EmptyManager sharedManager] removeEmptyFromView:weakSelf.view];
                }];
                return ;
            }
            if (page == 1) {
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dic in datas) {
                TPOTCOrderModel *model = [TPOTCOrderModel modelWithJSON:dic];
                model.currencyName = _model.currencyName;
                [self.dataArray addObject:model];
            }
            
            [weakSelf.tableView reloadData];

            _isRefresh = NO;
            if (datas.count >= 10) {
                MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    if (!_isRefresh) {
                        _page ++;
                        [weakSelf loadDataWith:_page];
                    }
                    _isRefresh = YES;
                }];
                [footer setTitle:kLocat(@"R_Loading") forState:MJRefreshStateRefreshing];
                _tableView.mj_footer = footer;
            }else{
                [_tableView.mj_footer endRefreshingWithNoMoreData];
                //                _tableView.mj_footer = nil;
            }

            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
        
    }];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"TPOTCBuyListCell";
    TPOTCBuyListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    cell.model = self.dataArray[indexPath.section];
    cell.topView.tag = indexPath.section;
    [cell.topView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUserInfo:)]];
    cell.delegate = self.buyListCellDelegate;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 169;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.5;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


#pragma mark - 显示用户信息
-(void)showUserInfo:(UITapGestureRecognizer *)tap
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kHideBaseOTCTopViewKey" object:nil];

    if ([Utilities isExpired]) {
        [self gotoLoginVC];
    }else{
        TPOTCProfileViewController *vc = [TPOTCProfileViewController new];
        vc.memberID = self.dataArray[tap.view.tag].member_id;
        vc.model = self.dataArray[tap.view.tag];
        kNavPush(vc);
    }
}



@end
