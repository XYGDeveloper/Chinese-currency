//
//  MyAssetsViewController.m
//  YJOTC
//
//  Created by l on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MyAssetsViewController.h"
#import "MyAsetTableViewCell.h"
#import "MyAssetHeaderTableViewCell.h"
#import "MyAssetDetailViewController.h"
#import "GetAssetListApi.h"
#import "MyAssetModel.h"
#import "EmptyManager.h"
#import "HBMyAssetDetailController.h"
#import "YWAlert.h"
#import "NSString+Operation.h"

@interface MyAssetsViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate, MyAsetTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *Tableview;
@property (nonatomic,strong)GetAssetListApi *api;
@property (nonatomic,strong)MyAssetModel *model;
@property (nonatomic,strong)MyAssetHeaderTableViewCell *head;
@property (nonatomic,strong)NSMutableArray *list;
@property (nonatomic,strong)NSMutableArray *Hiddenlist;
@property (nonatomic,assign)BOOL ishidden;

@end

@implementation MyAssetsViewController

- (NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (NSMutableArray *)Hiddenlist{
    if (!_Hiddenlist) {
        _Hiddenlist = [NSMutableArray array];
    }
    return _Hiddenlist;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self lodata];
    //k_meViewcontroler_s1_2
    self.title = kLocat(@"k_meViewcontroler_s1_2");
    [self layOutsubviews];
    
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
    self.api  = [[GetAssetListApi alloc]initWithKey:kUserInfo.token lanage:lang token_id:[NSString stringWithFormat:@"%ld",kUserInfo.uid]];
    self.api.delegate = self;
    __weak typeof(self) wself = self;
    self.Tableview.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.api refresh];
    }];
    
//    self.Tableview.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
//        __strong typeof(wself) sself = wself;
//        [sself.api loadNextPage];
//    }];
    [self.Tableview.mj_header beginRefreshing];
    
}

#pragma mark- layOutsubviews

- (void)layOutsubviews{
    [self.Tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.Tableview.separatorColor = kRGBA(24, 30, 50, 1);
    self.Tableview.backgroundColor = kRGBA(24, 30, 50, 1);
    self.view.backgroundColor = kRGBA(24, 30, 50, 1);
    [self.Tableview registerNib:[UINib nibWithNibName:@"MyAsetTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyAsetTableViewCell class])];
    MyAssetHeaderTableViewCell *head =  [[[NSBundle mainBundle] loadNibNamed:@"MyAssetHeaderTableViewCell" owner:nil options:nil] lastObject];
    head.backgroundColor = kRGBA(24, 30, 50, 1);
//    head.tradeType.text = kLocat(@"k_MyassetViewController_tableview_header_title");
    head.tradeDetail.text = kLocat(@"k_MyassetViewController_tableview_header_subtitle");
    [head.selButton setTitle:kLocat(@"k_MyassetViewController_tableview_header_hideButton") forState:UIControlStateNormal];
    head.userInteractionEnabled = YES;
    self.head = head;
    self.Tableview.tableHeaderView = self.head;
    self.Tableview.showsVerticalScrollIndicator = NO;
    __weak typeof(self) wself = self;
    self.head.hid = ^(BOOL ishidden) {
        __strong typeof(wself) sself = wself;
        if (ishidden == YES) {
            sself.ishidden = YES;
        }else{
            sself.ishidden = NO;
        }
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
        sself.api  = [[GetAssetListApi alloc]initWithKey:kUserInfo.token lanage:lang token_id:[NSString stringWithFormat:@"%ld",kUserInfo.uid]];
        sself.api.delegate = sself;
        [sself.api refresh];
    };
    
}


#pragma mark- TableviewDelegateAndDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.ishidden == YES) {
        return self.Hiddenlist.count;
    }else{
        return self.list.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAsetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyAsetTableViewCell class])];
    cell.backgroundColor = kColorFromStr(@"#0B132A");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    current_userModel *model;
    if (self.ishidden == YES) {
        model = [self.Hiddenlist objectAtIndex:indexPath.row];
    }else{
        model = [self.list objectAtIndex:indexPath.row];
    }
    [cell refreshWithModel:model];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    self.head.tradeCount.text = self.model.allmoneys;
    current_userModel *model;
    if (self.ishidden == YES) {
        model = [self.Hiddenlist objectAtIndex:indexPath.row];
    }else{
        model = [self.list objectAtIndex:indexPath.row];
    }
    
    
    HBMyAssetDetailController *vc = [HBMyAssetDetailController new];
    vc.title = kLocat(@"k_meViewcontroler_s1_2");
    vc.current_id = model.currency_id;
    vc.currencyName = model.currency_name;
    kNavPush(vc);
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    //    [self showTips:command.response.msg];
    [self.Tableview.mj_footer resetNoMoreData];
    [self.Tableview.mj_header endRefreshing];
    [self.view hideToastActivity];
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    self.model = responsObject;
    self.head.tradeCount.text = self.model.allmoneys;
    self.head.tradeConutDetail.text = [[self.model.sum.currentCurrencyPrice _addSuffixCurrentCurrency] _addPrefix:@"≈"];
    NSArray *array = self.model.currency_user;
    //    if (array.count <= 0) {
    ////        [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"empty_msg") operationText:kLocat(@"empty_refre") operationBlock:^{
    ////            [self.tableview.mj_header beginRefreshing];
    ////        }];
    //    } else {
    if (self.ishidden == YES) {
        NSMutableArray *arr = [NSMutableArray array];
        for (current_userModel *model in self.model.currency_user) {
            if ([model.num floatValue]> 0) {
                [arr addObject:model];
            }
        }
        [self.Hiddenlist removeAllObjects];
        [self.Hiddenlist addObjectsFromArray:arr];
        NSLog(@"=====%@",self.Hiddenlist);
        [self.Tableview reloadData];
    }else{
        [self.list removeAllObjects];
        [self.list addObjectsFromArray:array];
        [self.Tableview reloadData];

    }
   
    //        self.header.label2.text =[NSString stringWithFormat:@"(%@)%@",self.model.count,kLocat(@"k_MyrecommendViewController_top_label_5")];
    //    }
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    
    [self.Tableview.mj_header endRefreshing];
    [self.view hideToastActivity];
    [self.Tableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    if (self.list.count <= 0) {
        //        [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"empty_msg") operationText:kLocat(@"empty_refre") operationBlock:^{
        //            [self.tableview.mj_header beginRefreshing];
        //        }];
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ListModel *model = [self.infoList objectAtIndex:indexPath.row];
//    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@/%@",kBasePath,icon_info_currency,model.currency_id]];
//    //                vc.showNaviBar = YES;
//    kNavPush(vc);
//}

//- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
//    [self showTips:command.response.msg];
//    [self.view hideToastActivity];
//    [self.Tableview.mj_footer endRefreshing];
////    MyAssetModel *model = responsObject;
////    NSArray *arr = [current_userModel mj_objectArrayWithKeyValuesArray:model.currency_user];
////    [self.list addObjectsFromArray:arr];
//    [self.Tableview reloadData];
//}
//
//- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
//    [self.Tableview.mj_footer endRefreshing];
//    [self.view hideToastActivity];
//    [self showTips:command.response.msg];
//}

//- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
//    [self.view hideToastActivity];
//    //    [self.tableview.mj_footer endRefreshingWithNoMoreData];
//}

#pragma mark - MyAsetTableViewCellDelegate

- (void)myAsetTableViewCell:(MyAsetTableViewCell *)cell showTipsWithModel:(current_userModel *)model {
    if (model.tipsMessage) {
        [YWAlert alertSorryWithMessage:model.tipsMessage inViewController:self];
    }
}

@end
