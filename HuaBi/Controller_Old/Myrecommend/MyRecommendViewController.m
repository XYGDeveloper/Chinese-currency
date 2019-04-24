//
//  MyRecommendViewController.m
//  YJOTC
//
//  Created by l on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MyRecommendViewController.h"
#import "MyrecommandTableViewCell.h"
#import "GetRecommandlist.h"
#import "EmptyManager.h"
#import "RecommandModel.h"
#import "Sectionheader.h"
#import "MyrecommendABModel.h"
#import "RecommendHeaderViewTableViewCell.h"
#import "SafeCategory.h"
@interface MyRecommendViewController ()<ApiRequestDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *list;
@property (nonatomic,strong)GetRecommandlist *api;
@property (nonatomic,strong)RecommandModel *model;
@property (nonatomic,strong)RecommendHeaderViewTableViewCell *header;
@property (nonatomic,strong)UIView  *headerview;
@property (nonatomic,strong)UILabel  *headerviewlabel;

@end

@implementation MyRecommendViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_MyrecommendViewController_top_label_title");
    self.view.backgroundColor = kRGBA(24, 30, 50, 1);
    self.tableview.backgroundColor = kRGBA(24, 30, 50, 1);
    RecommendHeaderViewTableViewCell *head =  [[[NSBundle mainBundle] loadNibNamed:@"RecommendHeaderViewTableViewCell" owner:nil options:nil] lastObject];
    head.userInteractionEnabled = YES;
    self.header = head;
    self.tableview.tableHeaderView = self.header;
//    self.header.label3.text = kLocat(@"k_MyrecommendViewController_top_label_4");
//    self.header.label4.text = kLocat(@"k_MyrecommendViewController_top_label_01");
//    self.header.label5.text = kLocat(@"k_MyrecommendViewController_top_label_00");
    self.header.myrecommendLabel.text = kLocat(@"k_MyrecommendViewController_top_label_title");
    self.header.label12.text = kLocat(@"k_MyrecommendViewController_top_label_2");
    self.header.label13.text = kLocat(@"k_MyrecommendViewController_top_label_3");
    self.header.label14.text = kLocat(@"k_MyrecommendViewController_top_label_4");
    [self.tableview registerNib:[UINib nibWithNibName:@"MyrecommandTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyrecommandTableViewCell class])];
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
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"language"] = lang;
    param[@"token"] = kUserInfo.token;
    param[@"token_id"] = [NSString stringWithFormat:@"%ld",kUserInfo.uid];
    NSLog(@"%@",param);
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:recommandAB] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [self.view hideToastActivity];
        NSLog(@"%@",responseObj);
        if (success) {
            kLOG(@"%@",[responseObj ksObjectForKey:kData][@"count"]);
              NSArray *list = [MyrecommendABModel mj_objectArrayWithKeyValuesArray:[[responseObj ksObjectForKey:kData] objectForKey:@"list"]];
            [self.header.recommendCountLabel setTitle:[NSString stringWithFormat:@"(%@)%@",[responseObj ksObjectForKey:kData][@"count"],kLocat(@"k_MyrecommendViewController_top_label_5")] forState:UIControlStateNormal];
            MyrecommendABModel *m1Model = [list safeObjectAtIndex:0];
            MyrecommendABModel *m2Model = [list safeObjectAtIndex:1];
            MyrecommendABModel *m3Model = [list safeObjectAtIndex:2];
            MyrecommendABModel *m4Model = [list safeObjectAtIndex:3];
            MyrecommendABModel *m5Model = [list safeObjectAtIndex:4];
            MyrecommendABModel *m6Model = [list safeObjectAtIndex:5];
            [self.header.m1Label setTitle:[self getLevelText:m1Model.level num:m1Model.num] forState:UIControlStateNormal];
            self.header.m1Label.tag = 1000+ [m1Model.level intValue];
            self.header.m2label.tag = 1000+ [m2Model.level intValue];
            self.header.m3label.tag = 1000+ [m3Model.level intValue];
            self.header.m4label.tag = 1000+ [m4Model.level intValue];
            self.header.m5label.tag = 1000+ [m5Model.level intValue];
            self.header.m6label.tag = 1000+ [m6Model.level intValue];

             [self.header.m2label setTitle:[self getLevelText:m2Model.level num:m2Model.num] forState:UIControlStateNormal];
             [self.header.m3label setTitle:[self getLevelText:m3Model.level num:m3Model.num] forState:UIControlStateNormal];
             [self.header.m4label setTitle:[self getLevelText:m4Model.level num:m4Model.num] forState:UIControlStateNormal];
             [self.header.m5label setTitle:[self getLevelText:m5Model.level num:m5Model.num] forState:UIControlStateNormal];
             [self.header.m6label setTitle:[self getLevelText:m6Model.level num:m6Model.num] forState:UIControlStateNormal];
            __weak typeof(self) wself = self;
            self.header.sel = ^(UIButton * _Nonnull sender) {
                wself.api  = [[GetRecommandlist alloc]initWithKey:kUserInfo.token lanage:lang token_id:[NSString stringWithFormat:@"%ld",kUserInfo.uid] uuid:[Utilities randomUUID] level:[NSString stringWithFormat:@"%ld",sender.tag-1000]];
                wself.api.delegate = wself;
                [wself.api refresh];
            };
            self.header.defau = ^(UIButton * _Nonnull sender) {
                wself.api  = [[GetRecommandlist alloc]initWithKey:kUserInfo.token lanage:lang token_id:[NSString stringWithFormat:@"%ld",kUserInfo.uid] uuid:[Utilities randomUUID] level:@""];
                wself.api.delegate = wself;
                [wself.api refresh];
            };
            
        }
    }];
    
    self.api  = [[GetRecommandlist alloc]initWithKey:kUserInfo.token lanage:lang token_id:[NSString stringWithFormat:@"%ld",kUserInfo.uid] uuid:[Utilities randomUUID] level:@""];
    self.api.delegate = self;
    __weak typeof(self) wself = self;
    self.tableview.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
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

- (NSString *)getLevelText:(NSString *)level num:(NSString *)num{
    return [NSString stringWithFormat:@"M%@(%@)",level,num];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        MyrecommandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyrecommandTableViewCell class])];
    
        reListModel *model = [self.list objectAtIndex:indexPath.row];
        [cell refreshWithModel:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self.tableview.mj_footer resetNoMoreData];
    [self.tableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
//    self.model = responsObject;
    NSArray *array = responsObject;
    self.list = [NSMutableArray array];
    [self.list removeAllObjects];
//     self.headerviewlabel.text =[NSString stringWithFormat:@"(%@)%@",self.model.count,kLocat(@"k_MyrecommendViewController_top_label_5")];
    if (array.count <= 0) {
        [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"empty_msg") operationText:kLocat(@"empty_refre") operationBlock:^{
            [self.tableview.mj_header beginRefreshing];
        }];
        self.tableview.tableFooterView = [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"empty_msg") operationText:@"" operationBlock:^{
                        [self.tableview.mj_header beginRefreshing];
                    }];
        [self.tableview reloadData];
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
//    RecommandModel *model = responsObject;
//    NSArray *arr = [reListModel mj_objectArrayWithKeyValuesArray:model.list];
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
