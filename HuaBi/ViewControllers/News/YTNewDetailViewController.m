//
//  YTNewDetailViewController.m
//  YJOTC
//
//  Created by l on 2018/10/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTNewDetailViewController.h"
#import "YTGetNewsListApi.h"
#import "YTNewDetailTableViewCell.h"
#import "EmptyManager.h"
#import "YTDetailModel.h"
#import "TPCurrencyInfoController.h"
@interface YTNewDetailViewController ()<ApiRequestDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)YTGetNewsListApi *api;
@property (nonatomic,strong)NSMutableArray *infoList;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation YTNewDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (NSMutableArray *)infoList{
    if (!_infoList) {
        _infoList = [NSMutableArray array];
    }
    return _infoList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = self.titles;
    self.view.backgroundColor = kRGBA(24, 30, 50, 1);
    self.tableview.backgroundColor = kRGBA(24, 30, 50, 1);
    [self.tableview registerNib:[UINib nibWithNibName:@"YTNewDetailTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([YTNewDetailTableViewCell class])];
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.separatorColor = kRGBA(24, 30, 50, 1);
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
    self.api  = [[YTGetNewsListApi alloc]initWithType:self.cid lanage:lang];
    self.api.delegate = self;
    __weak typeof(self) wself = self;
    self.tableview.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        kShowHud;
        __strong typeof(wself) sself = wself;
        [sself.api refresh];
    }];

    self.tableview.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.api loadNextPage];
    }];
    [self.tableview.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YTNewDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YTNewDetailTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    YTDetailModel *model = [self.infoList objectAtIndex:indexPath.row];
    [cell refreshWithModel:model];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 97;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    }else{
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
            return nil;
    }else{
        return nil;
    }
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    //    [self showTips:command.response.msg];
    kHideHud;
    [self.tableview.mj_footer resetNoMoreData];
    [self.tableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    NSArray *array = (NSArray *)responsObject;
    NSLog(@"--------------%@",array);
    if (array.count <= 0) {
        [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"empty_msg") operationText:@"" operationBlock:^{
            [self.tableview.mj_header beginRefreshing];
        }];
    } else {
        [self.infoList removeAllObjects];
        [self.infoList addObjectsFromArray:array];
        [self.tableview reloadData];
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    
    [self.tableview.mj_header endRefreshing];
    kHideHud;
    
    //    [self showTips:command.response.msg];
    [self.tableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    if (self.infoList.count <= 0) {
        [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"empty_msg") operationText:kLocat(@"") operationBlock:^{
            [self.tableview.mj_header beginRefreshing];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YTDetailModel *model = [self.infoList objectAtIndex:indexPath.row];
    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@/id/%@?ts=%@",kBasePath,@"/Mobile/Art/details",model.article_id,[Utilities dataChangeUTC]]];
    kNavPush(vc);
}

- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self showTips:command.response.msg];
    kHideHud;
    [self.tableview.mj_footer endRefreshing];
    [self.infoList addObjectsFromArray:responsObject];
    [self.tableview reloadData];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.tableview.mj_footer endRefreshing];
    kHideHud;
    [self showTips:command.response.msg];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    kHideHud;
    [self.tableview.mj_footer endRefreshingWithNoMoreData];
}


@end
