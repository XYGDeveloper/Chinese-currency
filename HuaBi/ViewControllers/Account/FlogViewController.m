//
//  FlogViewController.m
//  YJOTC
//
//  Created by l on 2018/10/10.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "FlogViewController.h"
#import "LogTableViewCell.h"
#import "FinLogApi.h"
#import "EmptyManager.h"
@interface FlogViewController ()<ApiRequestDelegate>
@property (nonatomic,strong)FinLogApi *api;
@property (nonatomic,strong)NSMutableArray *list;
//@property (nonatomic,strong)MyAssetModel *model;
@end

@implementation FlogViewController

- (NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_FinsetViewController_title");
//
//    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
//    NSString *lang = nil;
//    if ([currentLanguage containsString:@"en"]) {//英文
//        lang = @"en-us";
//    }else if ([currentLanguage containsString:@"Hant"]){//繁体
//        lang = @"zh-tw";
//    }else{//简体
//        lang = ThAI;
//    }
//    self.api  = [[FinLogApi alloc]initWithKey:kUserInfo.token lanage:lang token_id:[NSString stringWithFormat:@"%ld",kUserInfo.uid]];
//    self.api.delegate = self;
//    __weak typeof(self) wself = self;
//    self.tableview.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//        __strong typeof(wself) sself = wself;
//        [sself.api refresh];
//    }];
//
//    self.tableview.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
//        __strong typeof(wself) sself = wself;
//        [sself.api loadNextPage];
//    }];
//    [self.tableview.mj_header beginRefreshing];
//    [self.tableview registerNib:[UINib nibWithNibName:@"LogTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([LogTableViewCell class])];
//
//    self.view.backgroundColor = kRGBA(24, 30, 50, 1);
//    self.tableview.backgroundColor = kRGBA(24, 30, 50, 1);
    // Do any additional setup after loading the view from its nib.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LogTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kRGBA(24, 30, 50, 1);
    FinModel *model = [self.list objectAtIndex:indexPath.section];
    [cell refreshWIthModel:model];
    return cell;
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
        return 10;
    }else{
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    //    [self showTips:command.response.msg];
    [self.tableview.mj_footer resetNoMoreData];
    [self.tableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    NSArray *array = responsObject;
    if (array.count <= 0) {
      
    } else {
        self.tableview.tableFooterView = nil;
        [self.list removeAllObjects];
        [self.list addObjectsFromArray:array];
        [self.tableview reloadData];
    }
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    
    [self.tableview.mj_header endRefreshing];
    //    [self showTips:command.response.msg];
    [self.tableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    if (self.list.count <= 0) {
        [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"empty_msg") operationText:kLocat(@"empty_refre") operationBlock:^{
            [self.tableview.mj_header beginRefreshing];
        }];
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ListModel *model = [self.infoList objectAtIndex:indexPath.row];
//    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@/%@",kBasePath,icon_info_currency,model.currency_id]];
//    //                vc.showNaviBar = YES;
//    kNavPush(vc);
//}

- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self showTips:command.response.msg];
    [self.tableview.mj_footer endRefreshing];
    [self.list addObjectsFromArray:responsObject];
    [self.tableview reloadData];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.tableview.mj_footer endRefreshing];
    [self showTips:command.response.msg];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    //    [self.tableview.mj_footer endRefreshingWithNoMoreData];
}


@end
