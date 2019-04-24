//
//  MymineViewController.m
//  YJOTC
//
//  Created by l on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "MymineViewController.h"
#import "MyrecommandTableViewCell.h"
#import "getMineListApi.h"
#import "EmptyManager.h"
#import "MineModel.h"
#import "MybounsHeaderTableViewCell.h"
#import "CGXPickerView.h"
#import "HBMineDesAlertView.h"

@interface MymineViewController ()<ApiRequestDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *list;
@property (nonatomic,strong)getMineListApi *api;
@property (nonatomic,strong)MineModel *model;
@property (nonatomic,strong)MybounsHeaderTableViewCell *header;
@property (nonatomic,strong)NSString *startimeStr;
@property (nonatomic,strong)NSString *endTimeStr;

@end

@implementation MymineViewController

- (NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kRGBA(24, 30, 50, 1);
    self.tableview.backgroundColor = kRGBA(24, 30, 50, 1);
    MybounsHeaderTableViewCell *head =  [[[NSBundle mainBundle] loadNibNamed:@"MybounsHeaderTableViewCell" owner:nil options:nil] lastObject];
    head.userInteractionEnabled = YES;
    self.header = head;
    self.tableview.tableHeaderView = self.header;
    self.header.countDes.text = kLocat(@"HBRewardViewController_s3_0");
    [self.header.startTime setTitle:kLocat(@"k_MymineViewController_top_label_s") forState:UIControlStateNormal];
    [self.header.endTime setTitle:kLocat(@"k_MymineViewController_top_label_e") forState:UIControlStateNormal];
    [self.header.qButton setTitle:kLocat(@"k_MymineViewController_top_label_q") forState:UIControlStateNormal];
    self.header.leftLabel.text = kLocat(@"k_MymineViewController_top_label_2");
    self.header.middleLabel.text = kLocat(@"k_MymineViewController_top_label_3");
    self.header.rightLabel.text = kLocat(@"k_MymineViewController_top_label_4");
    __weak typeof(self) wself = self;
    self.header.startAction = ^{
        NSDate *now = [NSDate date];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *nowStr = [fmt stringFromDate:now];
        [CGXPickerView showDatePickerWithTitle:kLocat(@"k_MymineViewController_top_label_s") DateType:UIDatePickerModeDate DefaultSelValue:nil MinDateStr:@"2000-01-01 00:00:00" MaxDateStr:nowStr IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
            __strong typeof(wself) sself = wself;
            NSLog(@"%@",selectValue);
            sself.startimeStr = selectValue;
            [sself.header.startTime setTitle:selectValue forState:UIControlStateNormal];
        }];
    };
    self.header.endAction = ^{
        NSDate *now = [NSDate date];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *nowStr = [fmt stringFromDate:now];
        __strong typeof(wself) sself = wself;
        [CGXPickerView showDatePickerWithTitle:kLocat(@"k_MymineViewController_top_label_e") DateType:UIDatePickerModeDate DefaultSelValue:nil MinDateStr:[NSString stringWithFormat:@"%@",sself.startimeStr] MaxDateStr:nowStr IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
            __strong typeof(wself) sself = wself;
            NSLog(@"%@",selectValue);
            sself.endTimeStr = selectValue;
            [sself.header.endTime setTitle:selectValue forState:UIControlStateNormal];
        }];
    };
  
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
    self.api  = [[getMineListApi alloc] initWithKey:kUserInfo.token lanage:lang token_id:[NSString stringWithFormat:@"%ld",kUserInfo.uid] uuid:[Utilities randomUUID]startTime:@"" endTime:@"" type:self.type];
    self.api.delegate = self;
    self.tableview.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.api refresh];
    }];
    
    self.tableview.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.api loadNextPage];
    }];
    [self.tableview.mj_header beginRefreshing];
    
    self.header.queryAction = ^{
        __strong typeof(wself) sself = wself;
        if (self.startimeStr.length <= 0) {
            [sself showTips:kLocat(@"k_MymineViewController_top_label_ss")];
            return;
        }
        if (self.endTimeStr.length <= 0) {
            [sself showTips:kLocat(@"k_MymineViewController_top_label_ee")];
            return;
        }
        [sself.view makeToastActivity:CSToastPositionCenter];
        sself.api  = [[getMineListApi alloc]initWithKey:kUserInfo.token lanage:lang token_id:[NSString stringWithFormat:@"%ld",kUserInfo.uid] uuid:[Utilities randomUUID] startTime:sself.startimeStr endTime:sself.endTimeStr type:sself.type];
        sself.api.delegate = sself;
        [sself.api refresh];
    };
    
    [self addRightBarButtonWithFirstImage:[UIImage imageNamed:@"sm_icon_question"] action:@selector(scanDetail)];
    
    // Do any additional setup after loading the view from its nib.
    
}

- (void)scanDetail{
    [HBMineDesAlertView AlertWith:kLocat(@"k_MymineViewController_tradeMine") detail:kLocat(@"k_MymineViewController_tradeMine_detail") buttonTextLabel:kLocat(@"net_alert_load_message_sure") controller:self sureAction:^{
        
    }];
}


- (void)end:(UIButton *)sender{
    
}
- (void)query:(UIButton *)sender{
    
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
    mlistModel *model = [self.list objectAtIndex:indexPath.row];
    [cell refreshWithModel2:model typeString:self.title];
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
    [self.view hideToastActivity];
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    self.model = responsObject;
    self.header.countLabel.text = self.model.total;
    NSArray *array = self.model.list;
//    if (array.count <= 0) {
////        [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"empty_msg") operationText:kLocat(@"empty_refre") operationBlock:^{
////            [self.tableview.mj_header beginRefreshing];
////        }];
//    } else {
        [self.list removeAllObjects];
        [self.list addObjectsFromArray:array];
        //        self.header.label2.text =[NSString stringWithFormat:@"(%@)%@",self.model.count,kLocat(@"k_MyrecommendViewController_top_label_5")];
        [self.tableview reloadData];
//    }
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    
    [self.tableview.mj_header endRefreshing];
    [self.view hideToastActivity];
    [self.tableview.mj_header endRefreshing];
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

- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self showTips:command.response.msg];
    [self.view hideToastActivity];
    [self.tableview.mj_footer endRefreshing];
    MineModel *model = responsObject;
    NSArray *arr = [mlistModel mj_objectArrayWithKeyValuesArray:model.list];
    [self.list addObjectsFromArray:arr];
    [self.tableview reloadData];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.tableview.mj_footer endRefreshing];
    [self.view hideToastActivity];
    [self showTips:command.response.msg];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    [self.view hideToastActivity];
    //    [self.tableview.mj_footer endRefreshingWithNoMoreData];
}


@end
