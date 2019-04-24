//
//  TPOTCCurrentADListController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCCurrentADListController.h"
#import "TPOTCADListMidCell.h"
#import "TPOTCADDoneTopCell.h"
#import "TPOTCADCurrentTopCell.h"
#import "TPOTCADDetailController.h"
#import "TPOTCMyADModel.h"


@interface TPOTCCurrentADListController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray<TPOTCMyADModel *> *dataArray;
@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isRefresh;

@property(nonatomic,strong)TPOTCMyADModel *toDeleteModel;



@end

@implementation TPOTCCurrentADListController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [NSMutableArray array];
    
    [self setupUI];
    //收到撤单通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"kuserDidCancelAdActionKey" object:nil];

}
-(void)setupUI
{
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,0, kScreenW, kScreenH-kNavigationBarHeight - 44) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCADCurrentTopCell" bundle:nil] forCellReuseIdentifier:@"TPOTCADCurrentTopCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCADListMidCell" bundle:nil] forCellReuseIdentifier:@"TPOTCADListMidCell"];

    __weak typeof(self)weakSelf = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        _isRefresh = YES;
        [weakSelf loadDataWith:_page];
    }];
    
    [_tableView.mj_header beginRefreshing];
}

-(void)loadDataWith:(NSInteger)page
{
    __weak typeof(self)weakSelf = self;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = _model.currencyID;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/OrdersOtc/my_order"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData];
            
            if (datas.count == 0 && _dataArray.count == 0) {
                [self showTips:kLocat(@"OTC_order_norecord")];
                return ;
            }
            if (page == 1) {
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dic in datas) {
                TPOTCMyADModel *model = [TPOTCMyADModel modelWithJSON:dic];
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
            NSInteger code = [[responseObj ksObjectForKey:kCode] integerValue];
            if (code == 10100) {//token失效
//                [kUserInfo clearUserInfo];
//                UIViewController *vc = [HBLoginTableViewController fromStoryboard];
//                [self presentViewController:vc animated:YES completion:nil];
            }
        }
        
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        static NSString *rid = @"TPOTCADCurrentTopCell";
        TPOTCADCurrentTopCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.model = self.dataArray[indexPath.section];
//        cell.msgButton.tag = indexPath.section;
//        [cell.msgButton addTarget:self action:@selector(showMsgVC:) forControlEvents:UIControlEventTouchUpInside];
        cell.msgButton.hidden = YES;
        
        
        return cell;
        
    }else{
        static NSString *rid = @"TPOTCADListMidCell";
        TPOTCADListMidCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.model = self.dataArray[indexPath.section];
        [cell.cancelButton addTarget:self action:@selector(showTipsView:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPOTCADDetailController *vc = [TPOTCADDetailController new];
    vc.model = self.dataArray[indexPath.section];
    vc.currencyID = _model.currencyID;
    kNavPush(vc);
}

-(void)cancelAdAction:(UIButton *)button
{
    [button.superview.superview removeFromSuperview];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"orders_id"] = self.dataArray[button.tag].orders_id;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/OrdersOtc/cancel"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            _page = 1;
//            [self loadDataWith:_page];
//            [self showTips:[responseObj ksObjectForKey:kMessage]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kuserDidCancelAdActionKey" object:_model];
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44;
    }else{
        return 160+5;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(void)showTipsView:(UIButton *)button
{
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.7];
    [kKeyWindow addSubview:bgView];

    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(28, 190 *kScreenHeightRatio, kScreenW - 56, 195)];
    [bgView addSubview:midView];
    midView.backgroundColor = kWhiteColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, midView.width, 63) text:kLocat(@"OTC_ad_cancel_warning") font:PFRegularFont(18) textColor:k323232Color textAlignment:1 adjustsFont:YES];
    [midView addSubview:titleLabel];
    
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(0, 150, midView.width/2, 45) title:kLocat(@"k_meViewcontroler_loginout_cancel") titleColor:kColorFromStr(@"#31AAD7") font:PFRegularFont(16) titleAlignment:YES];
    
    [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton*   sender) {
        [sender.superview.superview removeFromSuperview];
    }];
    
    [midView addSubview:cancelButton];
    cancelButton.backgroundColor = kColorFromStr(@"#DEEAFC");
    
    UIButton *confirmlButton = [[UIButton alloc] initWithFrame:kRectMake(cancelButton.right, 150, midView.width/2, 45) title:kLocat(@"k_meViewcontroler_loginout_sure") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:YES];
    
    [midView addSubview:confirmlButton];
    confirmlButton.backgroundColor = kColorFromStr(@"#11B1ED");
    confirmlButton.tag = button.tag;
    [confirmlButton addTarget:self action:@selector(cancelAdAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(28, titleLabel.bottom-15, midView.width - 56, midView.height - 45 - titleLabel.height) text:kLocat(@"OTC_ad_canceltips1") font:PFRegularFont(14) textColor:kColorFromStr(@"#666666") textAlignment:0 adjustsFont:YES];
    [midView addSubview:tipsLabel];
    tipsLabel.numberOfLines = 0;
}

-(void)refreshData:(NSNotification *)noti
{
    TPCurrencyModel *model = noti.object;
    if ([model.currencyID isEqualToString:_model.currencyID]) {
        _page = 1;
        [self loadDataWith:_page];
    }
}

@end
