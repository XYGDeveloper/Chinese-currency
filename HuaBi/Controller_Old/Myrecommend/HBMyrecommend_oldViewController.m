//
//  HBMyrecommend_oldViewController.m
//  HuaBi
//
//  Created by l on 2018/11/13.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMyrecommend_oldViewController.h"
#import "MyrecommandTableViewCell_old.h"
#import "GetRecommandlist.h"
#import "EmptyManager.h"
#import "RecommandModel.h"
#import "Sectionheader.h"
#import "MyrecommendABModel.h"
#import "RecommendHeaderViewTableViewCell_old.h"
@interface HBMyrecommend_oldViewController ()<ApiRequestDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *list;
@property (nonatomic,strong)GetRecommandlist *api;
@property (nonatomic,strong)RecommandModel *model;
@property (nonatomic,strong)RecommendHeaderViewTableViewCell_old *header;
@property (nonatomic,strong)UIView  *headerview;
@property (nonatomic,strong)UILabel  *headerviewlabel;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation HBMyrecommend_oldViewController

- (NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_MyrecommendViewController_top_label_title");
    
    self.headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
    self.headerviewlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenW- 40, 30)];
    [self.headerview addSubview:self.headerviewlabel];
    self.headerviewlabel.textAlignment = NSTextAlignmentRight;
    self.headerviewlabel.textColor = kColorFromStr(@"#DEE5FF");
    [self.view addSubview:self.headerview];
    self.view.backgroundColor = kRGBA(24, 30, 50, 1);
    self.tableview.backgroundColor = kRGBA(24, 30, 50, 1);
    RecommendHeaderViewTableViewCell_old *head =  [[[NSBundle mainBundle] loadNibNamed:@"RecommendHeaderViewTableViewCell_old" owner:nil options:nil] lastObject];
    head.userInteractionEnabled = YES;
    self.header = head;
    self.tableview.tableHeaderView = self.header;
//    self.header.label3.text = kLocat(@"k_MyrecommendViewController_top_label_4");
//    self.header.label4.text = kLocat(@"k_MyrecommendViewController_top_label_01");
//    self.header.label5.text = kLocat(@"k_MyrecommendViewController_top_label_00");
//    self.header.label1.text = kLocat(@"k_MyrecommendViewController_top_label_title");
    self.header.label12.text = kLocat(@"k_MyrecommendViewController_top_label_2");
    self.header.label13.text = kLocat(@"k_MyrecommendViewController_top_label_3");
    self.header.label14.text = kLocat(@"k_MyrecommendViewController_top_label_4");
    [self.tableview registerNib:[UINib nibWithNibName:@"MyrecommandTableViewCell_old" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyrecommandTableViewCell_old class])];
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
            
            //            [self showTips:[responseObj ksObjectForKey:kMessage]];
            kLOG(@"%@",[responseObj ksObjectForKey:kData][@"abin"]);
            MyrecommendABModel *model = [MyrecommendABModel mj_objectWithKeyValues:[[responseObj ksObjectForKey:kData] objectForKey:@"abin"]];
            self.header.label7.text = model.am;
            self.header.label10.text = model.bm;
            self.header.label8.text = model.ac;
            self.header.label11.text = model.bc;
            //            self.model = [IndexModel mj_objectWithKeyValues:[responseObj ksObjectForKey:kData]];
            //            self.topView.l2.text = [NSString stringWithFormat:@"฿%@",self.model.config.amount_income_allocated_today];
            //            self.topView.l4.text = [NSString stringWithFormat:@"฿%@",self.model.config.cumulative_income_million_today];
            //            NSLog(@"=====================================%ld",self.model.currency.count);
            //            self.netImages = [NSMutableArray array];
            //            self.titlearr = [NSMutableArray array];
            //            for (flashModel *model in self.model.flash) {
            //                [self.netImages addObject:model.pic];
            //                [self.titlearr addObject:model.title];
            //            }
            //            self.cycleScrollView.imageURLStringsGroup = self.netImages;
            //            //            self.cycleScrollView.titlesGroup = self.titlearr;
            
        }
    }];
    
    
//
//    self.api  = [[GetRecommandlist alloc]initWithKey:kUserInfo.token lanage:lang token_id:[NSString stringWithFormat:@"%ld",kUserInfo.uid] uuid:[Utilities randomUUID]];
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
//
    // Do any additional setup after loading the view from its nib.
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
    MyrecommandTableViewCell_old *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyrecommandTableViewCell_old class])];
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
    self.model = responsObject;
    NSArray *array = self.model.list;
    if (self.model.count) {
          self.headerviewlabel.text =[NSString stringWithFormat:@"(%@)%@",self.model.count,kLocat(@"k_MyrecommendViewController_top_label_5")];
    }else{
        self.headerviewlabel.text =[NSString stringWithFormat:@"(%@)%@",@"0",kLocat(@"k_MyrecommendViewController_top_label_5")];
    }
  
    if (array.count <= 0) {
        //        [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"empty_msg") operationText:kLocat(@"empty_refre") operationBlock:^{
        //            [self.tableview.mj_header beginRefreshing];
        //        }];
        self.tableview.tableFooterView = [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"empty_msg") operationText:@"" operationBlock:^{
            [self.tableview.mj_header beginRefreshing];
        }];
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
    RecommandModel *model = responsObject;
    NSArray *arr = [reListModel mj_objectArrayWithKeyValuesArray:model.list];
    [self.list addObjectsFromArray:arr];
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
