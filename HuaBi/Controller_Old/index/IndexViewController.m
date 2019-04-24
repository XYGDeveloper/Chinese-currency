//
//  IndexViewController.m
//  YJOTC
//
//  Created by l on 2018/9/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "IndexViewController.h"
#import <SDCycleScrollView.h>
#import "IndexNoticeTableViewCell.h"
#import "ZFBTableViewCell.h"
#import "introTableViewCell.h"
#import "rankTableViewCell.h"
#import "XYJGGView.h"
#import "XYConstant.h"
#import "IndexModel.h"
#import "TopTableViewCell.h"
#import "EmptyManager.h"
#import "TPCurrencyInfoController.h"
@interface IndexViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;

@property (strong,nonatomic)NSMutableArray *netImages;  //网络图片
@property (strong,nonatomic)NSMutableArray *titlearr;  //网络图片

@property (strong,nonatomic)UITableViewCell *cell;  //item

@property (strong,nonatomic)IndexModel *model;

@property (nonatomic,strong)TopTableViewCell *topView;

@end

@implementation IndexViewController

//
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self setLeftButton];
//    self.navigationController.navigationBar.hidden = NO;
//
//}
//
//- (void)refreshData{
////    [BQActivityView showActiviTy];
//    
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
//  
//    NSString *lang = nil;
//    if ([currentLanguage containsString:@"en"]) {//英文
//        lang = @"en-us";
//    }else if ([currentLanguage containsString:@"Hant"]){//繁体
//        lang = @"zh-tw";
//    }else{//简体
//        lang = @"cn";
//    }
//    param[@"language"] = lang;
//    //    param[@"uuid"] = [Utilities randomUUID];
//    //    param[@"token_id"] = [NSString stringWithFormat:@"%ld",kUserInfo.uid];
//    NSLog(@"%@",param);
//    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:index_list] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
//        if (error) {
//            [self showTips:error.localizedFailureReason];
//            if (error.code) {
//                [[EmptyManager sharedManager] showNetErrorOnView:self.view response:error.localizedDescription operationBlock:^{
//                    [self.tableview.mj_header beginRefreshing];
//                }];
//            }
//        }
//       
//        NSLog(@"%@",responseObj);
//        if (success) {
//            [[EmptyManager sharedManager] removeEmptyFromView:self.view];
//            [self.tableview.mj_header endRefreshing];
//
//            kLOG(@"%@",[responseObj ksObjectForKey:kData]);
////            [self showTips:[responseObj ksObjectForKey:kMessage]];
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
////            self.cycleScrollView.titlesGroup = self.titlearr;
//            
//            [self.tableview reloadData];
//        }else{
//            [self.tableview.mj_header endRefreshing];
//        }
//    }];
//    
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
//    self.tableview.showsVerticalScrollIndicator = NO;
//    [self.tableview registerNib:[UINib nibWithNibName:@"IndexNoticeTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([IndexNoticeTableViewCell class])];
//    [self.tableview registerNib:[UINib nibWithNibName:@"ZFBTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ZFBTableViewCell class])];
//    [self.tableview registerNib:[UINib nibWithNibName:@"introTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([introTableViewCell class])];
//      [self.tableview registerNib:[UINib nibWithNibName:@"rankTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([rankTableViewCell class])];
//    self.tableview.separatorColor = kColorFromStr(@"#F4F4F4");
//    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW, 188) imageNamesGroup:self.netImages];
//    self.cycleScrollView.backgroundColor = [UIColor blackColor];
//    //设置图片视图显示类型
//    self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
//    //设置轮播视图的分页控件的显示
//    self.cycleScrollView.showPageControl = YES;
//    //设置轮播视图分也控件的位置
//    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//    self.cycleScrollView.pageControlDotSize = CGSizeMake(12, 5);
//    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
//    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
//    self.cycleScrollView.delegate = self;
//    self.topView.l1.text = kLocat(@"k_IndexViewController_top_label");
//    self.topView.l3.text = kLocat(@"k_IndexViewController_top_label_1");
//    self.topView.center = self.cycleScrollView.center;
//    self.tableview.tableHeaderView = self.cycleScrollView;
////    self.tableview.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
////        [self refreshData];
////    }];
////
////    [self.tableview.mj_header beginRefreshing];
//    
////    [self.tableview.mj_header beginRefreshing];
//    
//
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPage:) name:kLoginSuccessKey object:nil];
//
//    // Do any additional setup after loading the view from its nib.
//}
//
////- (void)refreshPage:(NSNotification *)noti{
////    if ([noti.name isEqualToString:kLoginSuccessKey]) {
////        self.navigationItem.rightBarButtonItem = nil;
////    }
////
////    if ([noti.name isEqualToString:@"loginOutScuess"]) {
////        <#statements#>
////    }
////
////}
//
//
//- (void)setLeftButton{
// 
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftBtn addTarget:self action:@selector(tof:) forControlEvents:UIControlEventTouchUpInside];
//    [leftBtn setTitle:kLocat(@"k_IndexViewController_f") forState:UIControlStateNormal];
//    [leftBtn setTitleColor:kColorFromStr(@"#896FED") forState:UIControlStateSelected];
//    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//    [leftBtn sizeToFit];
//    leftBtn.tag = 10001;
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn addTarget:self action:@selector(toE:) forControlEvents:UIControlEventTouchUpInside];
//    [rightBtn setTitle:kLocat(@"k_IndexViewController_e") forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightBtn setTitleColor:kColorFromStr(@"#896FED") forState:UIControlStateSelected];
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//    [rightBtn sizeToFit];
//    rightBtn.tag = 10002;
//
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.leftBarButtonItems  = @[left,right];
//    if ([Utilities isExpired]) {
//        NSLog(@"%d",[Utilities isExpired]);
//        UIButton *LoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [LoginBtn addTarget:self action:@selector(toL:) forControlEvents:UIControlEventTouchUpInside];
//        [LoginBtn setTitle:kLocat(@"k_IndexViewController_lorr") forState:UIControlStateNormal];
//        [LoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        LoginBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//        [LoginBtn sizeToFit];
//        UIBarButtonItem *login = [[UIBarButtonItem alloc] initWithCustomView:LoginBtn];
//        self.navigationItem.rightBarButtonItem = login;
//    }else{
//        self.navigationItem.rightBarButtonItem = nil;
//    }
//    
//    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
//    if ([currentLanguage containsString:@"en"]) {//英文
//        rightBtn.selected = YES;
//    }else if ([currentLanguage containsString:@"Hant"]){//繁体
//        leftBtn.selected = YES;
//    }
//}
//
//- (void)tof:(UIButton *)btn{
//    [kUserDefaults setObject:CHINESEradition forKey:@"kUser_Language_Key"];
//    [LocalizableLanguageManager setUserlanguage:CHINESEradition];
//}
//- (void)toE:(UIButton *)btn{
//    [kUserDefaults setObject:ENGLISH forKey:@"kUser_Language_Key"];
//    [LocalizableLanguageManager setUserlanguage:ENGLISH];
//}
//- (void)toT:(UIButton *)thai{
//    [kUserDefaults setObject:ThAI forKey:@"kUser_Language_Key"];
//    [LocalizableLanguageManager setUserlanguage:ThAI];
//}
//
//- (void)toL:(UIButton *)btn{
//    ICNLoginViewController*vc = [[ICNLoginViewController alloc]init];
//    [self presentViewController:[[YJBaseNavController alloc]initWithRootViewController:vc] animated:YES completion:nil];
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 4;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return 1;
//    }else if (section == 1){
//        return 10;
//    }else{
//        return 1;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        return 29;
//    }else if (indexPath.section == 1){
//        return 55;
//    }else if (indexPath.section == 2){
//        for(XYJGGView * xyJGGView in self.cell.contentView.subviews){
//            if([xyJGGView isMemberOfClass:[XYJGGView class]]){
//                return xyJGGView.xy_itemViewH + 10;
//            }
//        }
//        return 120;
//    }else{
//        return 138;
//    }
//    
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        IndexNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IndexNoticeTableViewCell class])];
//        [cell refreshWithModel:self.model.article];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }else if (indexPath.section == 1){
//        ZFBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZFBTableViewCell class])];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        itemModel *model = [self.model.currency objectAtIndex:indexPath.row];
//        [cell refreshWith:model indexPath:indexPath];
//        return cell;
//    }else if (indexPath.section == 2){
//        self.cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
//        self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        NSMutableArray *temp = [NSMutableArray array];
//        for (itemModel *model in self.model.currency) {
//            if (![model.currency_name isEqualToString:@"AT"]) {
//                [temp addObject:model];
//            }
//        }
//        if (temp.count > 6) {
//            NSRange range = {0,6};
//            temp = [temp subarrayWithRange:range].mutableCopy;
//        }
//        XYJGGView * xyJGGView = [[XYJGGView alloc]initWithFrame:CGRectMake(10, 10,kScreenW - 20, 142) withXYPhotosDataMArr:temp.mutableCopy withXYPlaceholderImg:[UIImage imageNamed:@"banner_01"] withBgView:self.cell.contentView withXYItemViewTapBlock:^(NSUInteger xyItemView, NSMutableArray *xyPhotosDataMArr) {
//            NSLog(@"点击了第:%ld张图片,图片所在数据数组:%@",xyItemView+1,xyPhotosDataMArr);
//            itemModel *model = [temp objectAtIndex:xyItemView];
//            TPCurrencyInfoController *info = [TPCurrencyInfoController new];
//            info.currencyName = model.currency_mark;
//            info.minValue = model.min_price;
//            info.maxValue = model.max_price;
//            info.Value_24 = model.H_change24;
//            info.Value_new = model.price;
//            info.Value_status = model.price_status;
//            kNavPush(info);
//        }];
//        xyJGGView.backgroundColor = [UIColor whiteColor];
//        self.cell.contentView.backgroundColor = [UIColor whiteColor];
//        return self.cell;
//    }else{
//        introTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([introTableViewCell class])];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
//    
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (@available(iOS 11.0, *)) {
//        if (section == 0) {
//            return 5;
//        }else if (section == 1){
//            return 30;
//        }else if (section == 2){
//            return 10;
//        }else{
//            return 30;
//        }
//    }else{
//        if (section == 0) {
//            return 5;
//        }else if (section == 1){
//            return 30;
//        }else if (section == 2){
//            return 10;
//        }else{
//            return 30;
//        }
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (@available(iOS 11.0, *)) {
//        if (section == 0) {
//            return 5;
//        }else if (section == 2){
//            return 10;
//        }
//        else{
//            return 0.01;
//        }
//    }else{
//        if (section == 0) {
//            return 5;
//        }else if (section == 2){
//            return 10;
//        }
//        else{
//            return 0.01;
//        }
//    }
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (@available(iOS 11.0, *)) {
//        if (section == 1) {
//            UIButton *content = [UIButton buttonWithType:UIButtonTypeCustom];
//            content.frame = CGRectMake(0, 5, kScreenW, 24);
//            content.backgroundColor = [UIColor whiteColor];
//            [content addTarget:self action:@selector(toHQ) forControlEvents:UIControlEventTouchUpInside];
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, kScreenW/3, 24)];
//            label.font = [UIFont systemFontOfSize:12.0f];
//            label.text = kLocat(@"k_IndexViewController_s2");
//            [content addSubview:label];
//            UIImageView *img = [[UIImageView alloc]init];
//            img.image = [UIImage imageNamed:@"index_intro"];
//            [content addSubview:img];
//            img.userInteractionEnabled = YES;
//            [img mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.mas_equalTo(-15);
//                make.centerY.mas_equalTo(content.mas_centerY);
//                make.width.mas_equalTo(24);
//                make.height.mas_equalTo(5);
//            }];
//            UIView *lineView =[[UIView alloc]init];
//            lineView.backgroundColor = kColorFromStr(@"#F4F4F4");
//            [content addSubview:lineView];
//            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.mas_equalTo(0);
//                make.height.mas_equalTo(1);
//            }];
//            return content;
//        }else if(section == 3){
//            UIButton *content = [UIButton buttonWithType:UIButtonTypeCustom];
//            content.frame = CGRectMake(0, 5, kScreenW, 24);
//            content.backgroundColor = [UIColor whiteColor];
//            [content addTarget:self action:@selector(introduce) forControlEvents:UIControlEventTouchUpInside];
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, kScreenW/3, 24)];
//            label.font = [UIFont systemFontOfSize:12.0f];
//            label.text = kLocat(@"k_IndexViewController_s3");
//            label.userInteractionEnabled = YES;
//            [content addSubview:label];
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            [button addTarget:self action:@selector(introduce) forControlEvents:UIControlEventTouchUpInside];
//            [button setBackgroundImage:[UIImage imageNamed:@"index_intro"] forState:UIControlStateNormal];
//            [content addSubview:button];
//            [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.mas_equalTo(-15);
//                make.centerY.mas_equalTo(content.mas_centerY);
//                make.width.mas_equalTo(24);
//                make.height.mas_equalTo(5);
//            }];
//            UIView *lineView =[[UIView alloc]init];
//            lineView.backgroundColor = kColorFromStr(@"#F4F4F4");
//            [content addSubview:lineView];
//            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.mas_equalTo(0);
//                make.height.mas_equalTo(1);
//            }];
//            return content;
//        }else{
//            return nil;
//        }
//
//    }else{
//        if (section == 1) {
//            UIButton *content = [UIButton buttonWithType:UIButtonTypeCustom];
//            content.frame = CGRectMake(0, 5, kScreenW, 24);
//            content.backgroundColor = [UIColor whiteColor];
//            [content addTarget:self action:@selector(toHQ) forControlEvents:UIControlEventTouchUpInside];
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, kScreenW/3, 24)];
//            label.font = [UIFont systemFontOfSize:12.0f];
//            label.text = kLocat(@"k_IndexViewController_s3");
//            label.userInteractionEnabled = YES;
//            [content addSubview:label];
//            UIImageView *img = [[UIImageView alloc]init];
//            img.image = [UIImage imageNamed:@"index_intro"];
//            [content addSubview:img];
//            img.userInteractionEnabled = YES;
//            [img mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.mas_equalTo(-15);
//                make.centerY.mas_equalTo(content.mas_centerY);
//                make.width.mas_equalTo(24);
//                make.height.mas_equalTo(5);
//            }];
//            UIView *lineView =[[UIView alloc]init];
//            lineView.backgroundColor = kColorFromStr(@"#F4F4F4");
//            [content addSubview:lineView];
//            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.mas_equalTo(0);
//                make.height.mas_equalTo(1);
//            }];
//            return content;
//        }else if(section == 3){
//            UIButton *content = [UIButton buttonWithType:UIButtonTypeCustom];
//            content.frame = CGRectMake(0, 5, kScreenW, 24);
//            [content addTarget:self action:@selector(introduce) forControlEvents:UIControlEventTouchUpInside];
//            content.backgroundColor = [UIColor whiteColor];
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, kScreenW/3, 24)];
//            label.font = [UIFont systemFontOfSize:12.0f];
//            label.userInteractionEnabled = YES;
//            label.text = kLocat(@"k_IndexViewController_s3");
//            [content addSubview:label];
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            [button addTarget:self action:@selector(introduce) forControlEvents:UIControlEventTouchUpInside];
//            [button setBackgroundImage:[UIImage imageNamed:@"index_intro"] forState:UIControlStateNormal];
//            [content addSubview:button];
//            [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.mas_equalTo(-15);
//                make.centerY.mas_equalTo(content.mas_centerY);
//                make.width.mas_equalTo(24);
//                make.height.mas_equalTo(5);
//            }];
//            UIView *lineView =[[UIView alloc]init];
//            lineView.backgroundColor = kColorFromStr(@"#F4F4F4");
//            [content addSubview:lineView];
//            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.mas_equalTo(0);
//                make.height.mas_equalTo(1);
//            }];
//            return content;
//        }else{
//            return nil;
//        }
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@/%@/%@",kBasePath,art_details,self.model.article.article_id,[Utilities dataChangeUTC]]];
//        //                vc.showNaviBar = YES;
//        kNavPush(vc);
//    }else if (indexPath.section == 1){
//        itemModel *model = [self.model.currency objectAtIndex:indexPath.row];
//        TPCurrencyInfoController *info = [TPCurrencyInfoController new];
//        info.currencyName = model.currency_mark;
//        info.minValue = model.min_price;
//        info.maxValue = model.max_price;
//        info.Value_24 = model.H_change24;
//        info.Value_new = model.price;
//        info.Value_status = model.price_status;
//        kNavPush(info);
//    }else if (indexPath.section == 2){
//        itemModel *model = [self.model.currency objectAtIndex:indexPath.row];
//        TPCurrencyInfoController *info = [TPCurrencyInfoController new];
//        info.currencyName = model.currency_mark;
//        info.minValue = model.min_price;
//        info.maxValue = model.max_price;
//        info.Value_24 = model.H_change24;
//        info.Value_new = model.price;
//        info.Value_status = model.price_status;
//        kNavPush(info);
//    }else{
//        [self introduce];
//    }
//}
//
//- (void)toHQ{
//    self.tabBarController.selectedIndex = 1;
//}
//
//- (void)introduce{
//    //新手指导
//    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@?v=%@",kBasePath,helpCenter,[Utilities dataChangeUTC]]];
//    //                vc.showNaviBar = YES;
//    kNavPush(vc);
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (@available(iOS 11.0, *)) {
//        return nil;
//    }else{
//        return nil;
//    }
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//    
//}
//
//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//    flashModel *model = [self.model.flash objectAtIndex:index];
//    if (model.link.length <= 0) {
//        NSLog(@"------------------%@",model.link);
//        [self showTips:@"敬请期待"];
//        return;
//    }
//    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:model.link];
//        //                vc.showNaviBar = YES;
//    kNavPush(vc);
//}


@end
