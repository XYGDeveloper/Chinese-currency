//
//  HBTakeTokenRecordViewController.m
//  HuaBi
//
//  Created by l on 2019/2/23.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBTakeTokenRecordViewController.h"
#import "HBTokenTopUpRecordCell.h"
#import "HBTakeTokenRecordListApi.h"
#import "HBChongCurrencyRecorModel.h"
#import "HBcTableViewCell.h"
#import "HBNonomalTableViewCell.h"
#import "HBRecorderDetailViewController.h"
@interface HBTakeTokenRecordViewController ()<ApiRequestDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong)HBTakeTokenRecordListApi *api;
@property (nonatomic,strong)NSMutableArray *recorderList;

@end

@implementation HBTakeTokenRecordViewController

- (NSMutableArray *)recorderList{
    if (!_recorderList) {
        _recorderList = [NSMutableArray array];
    }
    return _recorderList;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableview.mj_header beginRefreshing];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *type;
  
    if ([self.type isEqualToString:@"1"]) {
        self.title = kLocat(@"HBTokenWithdrawViewController_address_ti_jilu");
        type = @"take";
    }else{
        self.title = kLocat(@"HBTokenWithdrawViewController_address_chong_jilu");
        type = @"recharge";
    }
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"HBcTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([HBcTableViewCell class])];
    [self.tableview registerNib:[UINib nibWithNibName:@"HBNonomalTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([HBNonomalTableViewCell class])];
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
//    initWithLanage:lang token:kUserInfo.token token_id:kUserInfo.user_id
    
    self.api  = [[HBTakeTokenRecordListApi alloc]initWithLanage:lang token:kUserInfo.token token_id:kUserInfo.user_id currency_id:self.currency_id status:type];
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
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recorderList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HBChongCurrencyRecorModel *model = [self.recorderList objectAtIndex:indexPath.row];
    if ([model.status isEqualToString:@"-1"]) {
        HBNonomalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HBNonomalTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWithModel:model];
        cell.cancel = ^{
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"key"] = kUserInfo.token;
            param[@"token_id"] = @(kUserInfo.uid);
            param[@"id"] = model.id;
            kShowHud;
            [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/cancelCoin"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
                kHideHud;
                if (success) {
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
                    self.api  = [[HBTakeTokenRecordListApi alloc]initWithLanage:lang token:kUserInfo.token token_id:kUserInfo.user_id currency_id:self.currency_id status:@""];
                    self.api.delegate = self;
                    [self.api refresh];
                }else{
                    [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
                }
            }];
        };
       
        return cell;
    }else{
        HBcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HBcTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWithModel:model];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HBChongCurrencyRecorModel *model = [self.recorderList objectAtIndex:indexPath.row];
    if ([model.status isEqualToString:@"-1"]) {
        return 90;
    }else{
        return 70;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
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
        [self.recorderList removeAllObjects];
        [self.recorderList addObjectsFromArray:array];
        [self.tableview reloadData];
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    
    [self.tableview.mj_header endRefreshing];
    kHideHud;
    
    //    [self showTips:command.response.msg];
    [self.tableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    if (self.recorderList.count <= 0) {
        [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"empty_msg") operationText:kLocat(@"") operationBlock:^{
            [self.tableview.mj_header beginRefreshing];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
    HBChongCurrencyRecorModel *model = [self.recorderList objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HBRecorderDetailViewController *detail = [HBRecorderDetailViewController new];
    detail.model = model;
    detail.type = self.type;
    kNavPush(detail);
}

- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self showTips:command.response.msg];
    kHideHud;
    [self.tableview.mj_footer endRefreshing];
    [self.recorderList addObjectsFromArray:responsObject];
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
