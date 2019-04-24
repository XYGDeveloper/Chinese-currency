//
//  HBSelectTokenTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/2/18.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBSelectTokenTableViewController.h"
#import "HBGetTokenListApi.h"
#import "HBTokenListModel.h"
#import "NSString+pinyin.h"
#import "ICConvert.h"

@interface HBSelectTokenTableViewController ()<ApiRequestDelegate>

@property (nonatomic, copy) NSArray<NSString *> *tokenNames;
@property (nonatomic,strong)HBGetTokenListApi *api;
@property (nonatomic,strong)NSMutableArray *currencyNames;
@property (nonatomic ,strong)NSArray *datas;
@property (nonatomic,strong)UISearchBar *searchbar;

@end

@implementation HBSelectTokenTableViewController

- (NSMutableArray *)currencyNames{
    if (!_currencyNames) {
        _currencyNames = [NSMutableArray array];
    }
    return _currencyNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenW - 120, 28)];
//    self.searchbar.backgroundColor = kColorFromStr(@"#0B132A");
//    self.searchbar.placeholder = kLocat(@"HBTokenWithdrawViewController_cancel_search");
//    self.navigationItem.titleView = self.searchbar;
    
//    self.tokenNames = @[@"BTC", @"ETH", @"KOK", @"CCU"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HBTokenCell"];
    [self addRightBarButtonItemWithTitle2:kLocat(@"net_alert_load_message_cancel") action:@selector(pop)];
    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    NSString *lang = nil;
    if ([currentLanguage containsString:@"en"]) {//英文
        lang = @"en-us";
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
        lang = @"zh-tw";
    }else if ([currentLanguage containsString:@"ko"]){//繁体
        lang = KoreanLanage;
    }else if ([currentLanguage containsString:Japanese]){//繁体
        lang = Japanese;
    }else{//泰文
        lang = ThAI;
    }
    self.api  = [[HBGetTokenListApi alloc]initWithLanage:lang token:kUserInfo.token token_id:kUserInfo.user_id];
    self.api.delegate = self;
    __weak typeof(self) wself = self;
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        kShowHud;
        __strong typeof(wself) sself = wself;
        [sself.api refresh];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.api loadNextPage];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)pop{
    kNavPop;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ICPinyinFlag *f = self.datas[section];
    return f.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBTokenCell" forIndexPath:indexPath];
    cell.backgroundColor = kColorFromStr(@"#0B132A");
    cell.textLabel.textColor = kColorFromStr(@"#DEE5FF");
    ICPinyinFlag * fl = self.datas[indexPath.section];
    cell.textLabel.text = fl.contents[indexPath.row];
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *arr = [NSMutableArray array];
    [self.datas enumerateObjectsUsingBlock:^(ICPinyinFlag *obj, NSUInteger idx, BOOL *stop) {
        [arr addObject:obj.flag];
    }];
    return arr;
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    //    [self showTips:command.response.msg];
    kHideHud;
    [self.tableView.mj_footer resetNoMoreData];
    [self.tableView.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    NSArray *array = (NSArray *)responsObject;
    NSLog(@"--------------%@",array);
    if (array.count <= 0) {
        [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"empty_msg") operationText:@"" operationBlock:^{
            [self.tableView.mj_header beginRefreshing];
        }];
    } else {
        [self.currencyNames removeAllObjects];
        [self.currencyNames addObjectsFromArray:array];
        [ICConvert convertToICPinyinFlagWithArray:self.currencyNames key:@"currency_name" UsingBlock:^(NSArray *array) {
            //            NSLog(@"%@ 线程 ：%@",array,[NSThread currentThread]);
            _datas = array;
            [self.tableView reloadData];
        }];
        [self.tableView reloadData];
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    
    [self.tableView.mj_header endRefreshing];
    kHideHud;
    
    //    [self showTips:command.response.msg];
    [self.tableView.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    if (self.currencyNames.count <= 0) {
        [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"empty_msg") operationText:kLocat(@"") operationBlock:^{
            [self.tableView.mj_header beginRefreshing];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ICPinyinFlag * fl = self.datas[indexPath.section];
    NSString *currencyName = fl.contents[indexPath.row];
    for (HBTokenListModel *model in self.currencyNames) {
        if ([currencyName isEqualToString:model.currency_name]) {
            if (self.select) {
                self.select(model);
            }
        }
    }
    kNavPop;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ICPinyinFlag *f = self.datas[section];
    return f.flag;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
    contentView.backgroundColor = kColorFromStr(@"#171F34");
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenW - 20, 30)];
    label.textColor = kColorFromStr(@"#4173C8");
    ICPinyinFlag *f = self.datas[section];
    NSLog(@"---------%@",f.contents);
    label.text = f.flag;
    [contentView addSubview:label];
    return contentView;
}

//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datas.count;
}


//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self showTips:command.response.msg];
    kHideHud;
    [self.tableView.mj_footer endRefreshing];
//    [ICConvert convertToICPinyinFlagWithArray:responsObject key:@"currency_name" UsingBlock:^(NSArray *array) {
//        _datas = array;
//        [self.tableView reloadData];
//    }];
//    [self.datas addObjectsFromArray:_datas];
    [self.tableView reloadData];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.tableView.mj_footer endRefreshing];
    kHideHud;
    [self showTips:command.response.msg];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    kHideHud;
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}


@end
