//
//  TPOTCProfileViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCProfileViewController.h"
#import "TPOTCProfileTopCell.h"
#import "TPOTCBuyListCell.h"
#import "TPOTCBuyListCellDelegate.h"


@interface TPOTCProfileViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,strong)NSMutableArray<TPOTCOrderModel *> *dataArray;
@property(nonatomic,strong)NSMutableArray<TPOTCOrderModel *> *sellArray;
@property(nonatomic,strong)NSMutableArray<TPOTCOrderModel *> *buyArray;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isRefresh;

@property (nonatomic, strong) TPOTCOrderModel *selectedOrderModel;

@property (nonatomic, strong) TPOTCBuyListCellDelegate *buyListCellDelegate;

@end

@implementation TPOTCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _dataArray = [NSMutableArray array];
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"kUserDidPostAdKey" object:nil];

    [self loadData];
    
    self.buyListCellDelegate = [[TPOTCBuyListCellDelegate alloc] initWithViewController:self];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.buyListCellDelegate requestMyPaywas];
}

-(void)setupUI
{
//    self.view.backgroundColor = kColorFromStr(@"#0B132A");
    self.view.backgroundColor = kColorFromStr(@"#171F34");
    self.title = kLocat(@"OTC_pro_main");
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,0, kScreenW, kScreenH-kNavigationBarHeight) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCProfileTopCell" bundle:nil] forCellReuseIdentifier:@"TPOTCProfileTopCell"];
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCBuyListCell" bundle:nil] forCellReuseIdentifier:@"TPOTCBuyListCell"];
    
    
}

-(void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);

    if (_memberID) {
        param[@"member_id"] = _memberID;
    }else{
        param[@"member_id"] = @(kUserInfo.uid);
    }
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/OrdersOtc/user"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        
        if (success) {
            
            
            NSDictionary *dic = [responseObj ksObjectForKey:kData];
            
            _dataDic = dic;
            [self loadDataWith:1];
            [self.tableView reloadData];
        } else {
            kHideHud;
        }
    }];

}
-(void)loadDataWith:(NSInteger)page
{
    __weak typeof(self)weakSelf = self;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"member_id"] = _memberID;
    if (_memberID) {
        param[@"member_id"] = _memberID;
    }else{
        param[@"member_id"] = @(kUserInfo.uid);
    }
    param[@"page_size"] = @"200";
    param[@"page"] = @(page);
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"OrdersOtc/member_order"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        kHideHud;
        if (success) {
            self.sellArray = [[responseObj ksObjectForKey:kData] ksObjectForKey:@"sell"];
            self.buyArray = [[responseObj ksObjectForKey:kData] ksObjectForKey:@"buy"];
            NSArray *datas = nil;
            if (self.sellArray) {
                datas = self.sellArray;
            }
            if (self.buyArray) {
                NSMutableArray *tmpArray = [datas mutableCopy];
                [tmpArray addObjectsFromArray:self.buyArray];
                datas = tmpArray.copy;
            }
            
            
            if (datas.count == 0 && _dataArray.count == 0) {
                [self showTips:kLocat(@"OTC_buylist_noorder")];
                return ;
            }
            if (page == 1) {
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dic in datas) {
                TPOTCOrderModel *model = [TPOTCOrderModel modelWithJSON:dic];
                [self.dataArray addObject:model];
            }
            
            [weakSelf.tableView reloadData];
            
//            _isRefresh = NO;
//            if (datas.count >= 10) {
//                MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//                    if (!_isRefresh) {
//                        _page ++;
//                        [weakSelf loadDataWith:_page];
//                    }
//                    _isRefresh = YES;
//                }];
//                [footer setTitle:kLocat(@"R_Loading") forState:MJRefreshStateRefreshing];
//                _tableView.mj_footer = footer;
//            }else{
//                [_tableView.mj_footer endRefreshingWithNoMoreData];
//                //                _tableView.mj_footer = nil;
//            }
//            
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
        
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_dataDic) {
            return 1;
        }else{
            return 0;
        }
        
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *rid = @"TPOTCProfileTopCell";
        TPOTCProfileTopCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        
        cell.dataDic = _dataDic;
        
        return cell;
        
    }else{
        static NSString *rid = @"TPOTCBuyListCell";
        TPOTCBuyListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        
        cell.isProfile = YES;
        cell.model = self.dataArray[indexPath.section-1];

        cell.delegate = self.buyListCellDelegate;
        return cell;
    }
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 210;
    }else{
        return 169;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.sellArray.count == 0) {
            return 0;
        }
        return 9. + 35;
    }
    if (section == self.sellArray.count) {
        if (self.buyArray.count == 0) {
            return 0;
        }
        return 9. + 35;
    }
    return 2.;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 1) {
//        return 35;
//    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        return nil;
//    }
    
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == self.sellArray.count ) {
        
        
        UIView *footView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 44.)];
        footView.backgroundColor = kColorFromStr(@"#0B132A");
        
        UIView *topView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 8.)];
        topView.backgroundColor = kColorFromStr(@"#171F34");
        [footView addSubview:topView];
        NSString *tips = (section == self.sellArray.count) ? kLocat(@"OTC_pro_buyonline") :kLocat(@"OTC_pro_sellonline");
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(12, 8, 200, 35) text:tips font:PFRegularFont(14) textColor:kColorFromStr(@"#DEE5FF") textAlignment:0 adjustsFont:YES];
        
        [footView addSubview:tipsLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43., kScreenW, 1.)];
        lineView.backgroundColor = kColorFromStr(@"#171F34");
        [footView addSubview:lineView];

        return footView;
    }
    

    return nil;
}


/**  发布了新广告之后刷新页面  */
-(void)refreshData:(NSNotification *)noti
{
    [self loadDataWith:_page];
}

@end
