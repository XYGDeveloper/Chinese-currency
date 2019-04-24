//
//  HBHomeViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBHomeViewController.h"
#import "SDCycleScrollView.h"
#import "HBHomeCurrencyCell.h"
#import "HBHomeSectionHeaderView.h"
#import "HBHomeNewsCell.h"
#import "HBHomeQuotationCell.h"
#import "HBHomeIndexModel+Request.h"
#import "TPCurrencyInfoController.h"
#import "YBPopupMenu.h"
#import "EmptyManager.h"
#import "NewViewController.h"
#import "UIViewController+HBLoadingView.h"
#import "HBHomeShortcutMenuCell.h"
#import "C2CViewController.h"
#import "NSObject+SVProgressHUD.h"
#import "HBSubscribeListViewController.h"
#import "HBHoldingMoneyContainerViewController.h"
#import "MyInviteViewController.h"
#import "HBMyAssetDetailController.h"
#import "HBKOKAndKOKcyCurrencyInfoRequest.h"
#import "NSTimer+HB.h"
#import "ListModel+HomeRequest.h"
#import "HBCardTableViewCell.h"
#import "HBCustomerServiceViewController.h"
#import "HBHomeQuotationSegmentedSectionHeaderView.h"
#import "SafeCategory.h"
#import "NSUserDefaults+HB.h"
#import "MarqueeLabel.h"
#import "HBAccountTableViewController.h"

typedef NS_ENUM(NSInteger, HBHomeSectionType) {
    HBHomeSectionTypeShortcutMenu = 0,
    HBHomeSectionTypeCurrency = 1,
    HBHomeSectionTypeCard = 2,
    HBHomeSectionTypeNews = 3,
    HBHomeSectionTypeQuotation = 4,
};

@interface HBHomeViewController () <UITableViewDataSource, UITableViewDelegate, YBPopupMenuDelegate, SDCycleScrollViewDelegate, HBHomeShortcutMenuCellDelegate>

@property (strong, nonatomic) IBOutlet UIButton *languageSelectButton;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (strong, nonatomic) IBOutlet MarqueeLabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIView *noticeContainerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) HBHomeIndexModel *indexModel;
@property (nonatomic, strong) NSArray<Flash *> *banners;
@property (nonatomic, strong) NSArray<ListModel *> *quotations;
@property (nonatomic, strong) NSArray<YTData_listModel *> *allRankingArray;
@property (nonatomic, strong) dispatch_group_t requestGroup;
@property (nonatomic, assign) BOOL isFetchQuotationsInProgress;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) ListModel *kok;
@property (nonatomic, strong) ListModel *kokcy;

@property (nonatomic, assign) NSInteger selectedQuotationSegmentIndex;

@property (nonatomic, strong) HBHomeQuotationSegmentedSectionHeaderView *segmentedSectionHeaderView;
@property (nonatomic, strong) HBHomeSectionHeaderView *sectionHeaderView;

@property (nonatomic, assign) BOOL isNeedReloadDataWhenDidEndDecelerating;

@end

@implementation HBHomeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.noticeContainerView.backgroundColor = kThemeColor;
    self.requestGroup = dispatch_group_create();
    self.selectedQuotationSegmentIndex = 0;
    [self _setupNavigationItem];
    [self _setupCycleScrollView];
    [self _setupTableView];
    [self _fristRequestAllData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
//    [[UpdateVersionManager sharedUpdate] versionControl];
    [self _createTimer];
    [self.tableView reloadData];
    self.languageSelectButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.languageSelectButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Private

- (void)_timerAction {
    [self _requestQuotationsWithNoNeedsRequestGroup];
    [self _createTimer];
}

- (void)_createTimer {
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer _createRandomTimerWithTarget:self selector:@selector(_timerAction)];
}

- (void)_setupNavigationItem {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    self.navigationItem.titleView = imageView;

    UIButton *avatarButton = [UIButton new];
    UIImage *avatarImage = [UIImage imageNamed:@"default_avater"];
    avatarImage = [avatarImage imageByResizeToSize:CGSizeMake(30, 30)];
    [avatarButton setImage:avatarImage forState:UIControlStateNormal];
    [avatarButton addTarget:self action:@selector(_showMineVCAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:avatarButton];

    
    self.navigationItem.leftBarButtonItem = item;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.languageSelectButton];
    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    NSString *title = nil;
    if ([currentLanguage containsString:@"en"]) {//英文
        title = kLocat(@"K_Langag_en");
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
        title = kLocat(@"K_Langage_fan");
    }else if ([currentLanguage containsString:@"th-TH"]){//繁体
        title = kLocat(@"K_Langag_th");
    }else if ([currentLanguage containsString:Korean]){
        title = kLocat(@"K_Langag_ko");
    }else{
        title = kLocat(@"K_Langag_japen");
    }
    [self.languageSelectButton setTitle:[NSString stringWithFormat:@"%@ ", title] forState:UIControlStateNormal];
    self.languageSelectButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    
}

- (void)_setupTableView {
    self.tableView.backgroundColor = kThemeBGColor;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_checkHasServerTimeAndRequestAllData)];
}

- (void)_fristRequestAllData {
    
    [self showLoadingView];
    [self _checkHasServerTimeAndRequestAllData];
}

- (void)_requestAllData {
    [self _requestIndexData];
    [self _requestQuotationsWithNeedsRequestGroup:YES];
    dispatch_group_notify(self.requestGroup, dispatch_get_main_queue(), ^{
        [self hideLoadingView];
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)_checkHasServerTimeAndRequestAllData {
    if ([NSUserDefaults getServerTime]) {
        [self _requestAllData];
    } else {
        [[UpdateVersionManager sharedUpdate] versionControlWithSuccess:^{
            [self _requestAllData];
        } failure:^(NSError *error) {
            [self hideLoadingView];
            __weak typeof(self) weakSelf = self;
            [[EmptyManager sharedManager] showNetErrorOnView:self.view operationBlock:^{
                [weakSelf _checkHasServerTimeAndRequestAllData];
            }];
        }];
    }
}

- (void)_requestIndexData {
    dispatch_group_enter(self.requestGroup);
    [HBHomeIndexModel requestHomeIndexDataWithSuccess:^(HBHomeIndexModel * _Nonnull model) {
        dispatch_group_leave(self.requestGroup);
        self.indexModel = model;
    } failure:^(NSError * _Nonnull error) {
        dispatch_group_leave(self.requestGroup);
        [self showTips:error.localizedDescription];
        __weak typeof(self) weakSelf = self;
        [[EmptyManager sharedManager] showNetErrorOnView:self.view operationBlock:^{
            [weakSelf _requestAllData];
        }];
    }];
}

- (void)_requestQuotationsWithNoNeedsRequestGroup {
    [self _requestQuotationsWithNeedsRequestGroup:NO];
}

- (void)_requestQuotationsWithNeedsRequestGroup:(BOOL)needsRequestGroup {
    
//    if (self.isFetchQuotationsInProgress) {
//        return;
//    }
//    self.isFetchQuotationsInProgress = YES;
    
    if (needsRequestGroup) {
        dispatch_group_enter(self.requestGroup);
    }
    
    [ListModel requestHomeQuotationsWithSuccess:^(NSArray<ListModel *> * _Nonnull quotations, NSArray<YTData_listModel *> * _Nonnull allRankingArray, YWNetworkResultModel * _Nonnull model) {
        self.isFetchQuotationsInProgress = NO;
        if (needsRequestGroup) {
            dispatch_group_leave(self.requestGroup);
        }
        
        [[EmptyManager sharedManager] removeEmptyFromView:self.view];
        self.quotations = quotations;
        self.allRankingArray = allRankingArray;
        [self _reloadTableView];
        
    } failure:^(NSError * _Nonnull error) {
        self.isFetchQuotationsInProgress = NO;
        if (needsRequestGroup) {
            dispatch_group_leave(self.requestGroup);
        }
    }];
}

- (void)_reloadTableView {
    if (self.tableView.isDragging || self.tableView.decelerating) {
        self.isNeedReloadDataWhenDidEndDecelerating = YES;
        return;
    }
    [self.tableView reloadData];
}

- (void)_setupCycleScrollView {
    self.cycleScrollView.placeholderImage = [UIImage imageNamed:@"home_banner_2"];
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    self.cycleScrollView.pageControlDotSize = CGSizeMake(12, 5);
    self.cycleScrollView.autoScrollTimeInterval = 6;
    self.cycleScrollView.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDetail)];
    [self.noticeLabel addGestureRecognizer:tap];
}

- (void)_mykokWithCompletion:(void(^)(ListModel *kok, ListModel *kokcy))completion{
    
    if (self.kok) {
        if (completion) {
            completion(self.kok, self.kokcy);
        }
        return;
    }
    kShowHud;
    [[HBKOKAndKOKcyCurrencyInfoRequest sharedInstance] requestMyKokWithCompletion:^(ListModel * _Nonnull kok, ListModel * _Nonnull kokcy, NSError * _Nonnull error) {
        kHideHud;
        if (!error) {
            self.kok = kok;
            self.kokcy = kokcy;
            if (completion) {
                completion(kok, kokcy);
            }
        }
    }];
}

- (void)toDetail{
    BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@%@?ts=%@",kBasePath,@"/Mobile/Art/details/id/",self.indexModel.notice.article_id,[Utilities dataChangeUTC]]];
    kNavPush(vc);
}

-(void)menuPop:(UIButton *)button{
    CGPoint point = CGPointMake(button.superview.superview.superview.right-button.width/2, kNavigationBarHeight-5);
//    CGPoint cPoint = [button convertPoint:CGPointMake(button.right, button.height) toView:nil];
    [YBPopupMenu showAtPoint:point titles:[NSMutableArray arrayWithObjects:kLocat(@"K_Langage_fan"),kLocat(@"K_Langag_en"),kLocat(@"K_Langag_th"),kLocat(@"K_Langag_ko"),kLocat(@"K_Langag_japen"), nil] icons:nil menuWidth:160 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.fontSize = 14;
        popupMenu.textColor = kWhiteColor;
        popupMenu.delegate = self;
        popupMenu.backColor = [kBlackColor colorWithAlphaComponent:0.8];
        //        popupMenu.tag = button.tag;
        popupMenu.itemHeight = 42;
        popupMenu.borderWidth = 0;
    }];
}

-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    if (index == 0) {
        [self.languageSelectButton setTitle:kLocat(@"K_Langage_fan") forState:UIControlStateNormal];
            [kUserDefaults setObject:CHINESEradition forKey:@"kUser_Language_Key"];
            [LocalizableLanguageManager setUserlanguage:CHINESEradition];
    }else if(index == 1){
        [self.languageSelectButton setTitle:kLocat(@"K_Langag_en") forState:UIControlStateNormal];
            [kUserDefaults setObject:ENGLISH forKey:@"kUser_Language_Key"];
            [LocalizableLanguageManager setUserlanguage:ENGLISH];
    }else if(index == 2) {
        [self.languageSelectButton setTitle:kLocat(@"K_Langag_th") forState:UIControlStateNormal];
        [kUserDefaults setObject:ThAI forKey:@"kUser_Language_Key"];
        [LocalizableLanguageManager setUserlanguage:ThAI];
    }else if(index == 3) {
        [self.languageSelectButton setTitle:kLocat(@"K_Langag_ko") forState:UIControlStateNormal];
        [kUserDefaults setObject:Korean forKey:@"kUser_Language_Key"];
        [LocalizableLanguageManager setUserlanguage:Korean];
    }else{
        [self.languageSelectButton setTitle:kLocat(@"K_Langag_japen") forState:UIControlStateNormal];
        [kUserDefaults setObject:Japanese forKey:@"kUser_Language_Key"];
        [LocalizableLanguageManager setUserlanguage:Japanese];
    }
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    switch (section) {
        case HBHomeSectionTypeShortcutMenu:
            return 1;
            break;
        case HBHomeSectionTypeCard:
            return 1;
            break;
        case HBHomeSectionTypeCurrency:
            return 1;
            break;
            
        case HBHomeSectionTypeNews:
            return self.indexModel.zixun.count;
            break;
    
        case HBHomeSectionTypeQuotation:
            return [self _currentRankingArray].count;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case HBHomeSectionTypeShortcutMenu:
            return 105.;
            break;
        case HBHomeSectionTypeCard:
            return 94.;
            break;
        case HBHomeSectionTypeCurrency:
            return 126.;
            break;
            
        case HBHomeSectionTypeNews:
            return 97.;
            break;
            
        case HBHomeSectionTypeQuotation:
            return 61.;
            break;
            
        default:
            break;
    }
    return 44.;
}

- (Zixun *)newsAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.indexModel.zixun.count) {
        return self.indexModel.zixun[indexPath.row];
    }
    
    return nil;
}

- (ListModel *)rankingListModelAtIndexPath:(NSIndexPath *)indexPath {
    return [[self _currentRankingArray] safeObjectAtIndex:indexPath.row];
}

- (NSArray<ListModel *> *)_currentRankingArray {
    return [self rankingArrayAtIndex:self.selectedQuotationSegmentIndex];
}

- (NSArray<ListModel *> *)rankingArrayAtIndex:(NSInteger)index {
    YTData_listModel *model = [self.allRankingArray safeObjectAtIndex:index];
    return model.data_list;
}

static NSString *const kHBHomeShortcutMenuCellIdentifier = @"HBHomeShortcutMenuCell";
static NSString *const kHBHomeCurrencyCellIdentifier = @"HBHomeCurrencyCell";
static NSString *const kHBHomeNewsCellIdentifier = @"HBHomeNewsCell";
static NSString *const kHBHomeQuotationCellCellIdentifier = @"HBHomeQuotationCell";
static NSString *const kHBHomeCardCellCellIdentifier = @"HBCardTableViewCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
            
        case HBHomeSectionTypeShortcutMenu: {
            HBHomeShortcutMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kHBHomeShortcutMenuCellIdentifier];
            cell.delegate = self;
            return cell;
            break;
        }
            
        case HBHomeSectionTypeCard: {
            HBCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHBHomeCardCellCellIdentifier];
            __weak typeof(self) weakSelf = self;
            cell.leftMen = ^{
                weakSelf.tabBarController.selectedIndex = 3;
            };
            cell.topMenu = ^{
                BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@",kBasePath,@"/Mobile/Activity/activity"]];
                kNavPush(vc);
            };
            cell.bottomMenu = ^{
                UIViewController *vc = [HBCustomerServiceViewController new];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return cell;
            break;
        }
            
        case HBHomeSectionTypeCurrency: {
            HBHomeCurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:kHBHomeCurrencyCellIdentifier forIndexPath:indexPath];
            cell.quotations = self.quotations;

            cell.quotationDidSelectBlock = ^(ListModel * _Nonnull model) {
                TPCurrencyInfoController *vc = [TPCurrencyInfoController new];
                vc.model = model;
                kNavPush(vc);
            };
            return cell;
            break;
        }
            
        case HBHomeSectionTypeNews: {
            HBHomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kHBHomeNewsCellIdentifier forIndexPath:indexPath];
            cell.news = [self newsAtIndexPath:indexPath];
            return cell;
            break;
        }
            
        case HBHomeSectionTypeQuotation: {
            HBHomeQuotationCell *cell = [tableView dequeueReusableCellWithIdentifier:kHBHomeQuotationCellCellIdentifier forIndexPath:indexPath];
            ListModel *model = [self rankingListModelAtIndexPath:indexPath];
            HBHomeQuotationCellStyle cellStyle = (self.selectedQuotationSegmentIndex == 0) ? HBHomeQuotationCellStyleDefault : HBHomeQuotationCellStyleOther;
            [cell configWithModel:model indexPath:indexPath cellStyle:cellStyle];
            return cell;
             break;
        }
           
        default:
            break;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case HBHomeSectionTypeNews: {
            return self.sectionHeaderView;
        }
            break;
        case HBHomeSectionTypeQuotation: {
            self.segmentedSectionHeaderView.allRankingArray = self.allRankingArray;
            return self.segmentedSectionHeaderView;
        }
            
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case HBHomeSectionTypeNews:
            return 50.;
        case HBHomeSectionTypeQuotation:
            return 81.;
            
        default:
            return 0.;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case HBHomeSectionTypeNews: {
            Zixun *model = [self newsAtIndexPath:indexPath];
            
            BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:[NSString stringWithFormat:@"%@%@/id/%@?ts=%@",kBasePath,@"/Mobile/Art/details",model.article_id,[Utilities dataChangeUTC]]];
            kNavPush(vc);
            break;
        }
            
            
        case HBHomeSectionTypeQuotation: {
            ListModel *model = [self rankingListModelAtIndexPath:indexPath];

            TPCurrencyInfoController *vc = [TPCurrencyInfoController new];
            vc.model = model;
            kNavPush(vc);
             break;
        }
           
        default:
            break;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isNeedReloadDataWhenDidEndDecelerating) {
        self.isNeedReloadDataWhenDidEndDecelerating = NO;
        [self.tableView reloadData];
    }
}

#pragma mark - HBHomeShortcutMenuCellDelegate

- (void)homeShortcutMenuCell:(HBHomeShortcutMenuCell *)cell selectedMenuType:(HBHomeShortcutMenuCellType)menuType {
    
    if ([Utilities isExpired]) {
        [self gotoLoginVC];
        return;
    }
    switch (menuType) {
        case HBHomeShortcutMenuCellTypeSubscription: {
            HBSubscribeListViewController *vc = [HBSubscribeListViewController fromStoryboard];
            kNavPush(vc);
             break;
        }
            
        case HBHomeShortcutMenuCellTypeKOK: {
            [self _mykokWithCompletion:^(ListModel *kok, ListModel *kokcy) {
                HBMyAssetDetailController *vc = [HBMyAssetDetailController new];
                vc.title = kLocat(@"k_HBAssetDetailiewController_kok");
                vc.current_id = kok.currency_id;
                vc.currencyName = kok.currency_name;
                kNavPush(vc);
            }];
            break;
        }
            
        case HBHomeShortcutMenuCellTypeInvite: {
            kNavPush([MyInviteViewController new]);
            break;
        }
            
        case HBHomeShortcutMenuCellTypeMoneyInterest: {
            UIViewController *vc = [HBHoldingMoneyContainerViewController fromStoryboard];
            kNavPush(vc);
            break;
        }
            
        case HBHomeShortcutMenuCellTypeC2C: {
            if (kUserInfo.verify_state.intValue == 1) {
                kNavPush([C2CViewController new]);
            }else{
                [self showInfoWithMessage:kLocat(@"k_in_c2c_tips")];
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Actions

- (IBAction)selectLanguageAction:(id)sender {
    [self menuPop:self.languageSelectButton];
}

- (void)_showMineVCAction {
    kNavPush([HBAccountTableViewController fromStoryboard]);
}

#pragma mark - Setters & Getters

- (HBHomeSectionHeaderView *)sectionHeaderView {
    if (!_sectionHeaderView) {
        _sectionHeaderView = [HBHomeSectionHeaderView loadNibView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            UIViewController *newsVC = [NewViewController new];
            kNavPush(newsVC);
        }];
        [_sectionHeaderView addGestureRecognizer:tap];
        _sectionHeaderView.titleLabel.text = kLocat(@"k_HomeViewController_tableview_header_title");
    }
    return _sectionHeaderView;
}

- (HBHomeQuotationSegmentedSectionHeaderView *)segmentedSectionHeaderView {
    if (!_segmentedSectionHeaderView) {
        _segmentedSectionHeaderView = [HBHomeQuotationSegmentedSectionHeaderView viewLoadNib];
        [_segmentedSectionHeaderView setSelectedSegmentIndex:self.selectedQuotationSegmentIndex];
        __weak typeof(self) weakSelf = self;
        _segmentedSectionHeaderView.indexChangeBlock = ^(NSInteger index) {
            weakSelf.selectedQuotationSegmentIndex = index;
            [weakSelf.tableView reloadData];
        };
    }
    
    return _segmentedSectionHeaderView;
}

- (void)setIndexModel:(HBHomeIndexModel *)indexModel {
    _indexModel = indexModel;
    self.banners = indexModel.flash;
    
    self.noticeLabel.text = indexModel.notice.title;
    [self.tableView reloadData];
}

- (void)setBanners:(NSArray<Flash *> *)banners {
    _banners = banners;
    NSMutableArray<NSString *> *images = [[NSMutableArray alloc] initWithCapacity:_banners.count];
    [_banners enumerateObjectsUsingBlock:^(Flash * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [images addObject:obj.pic];
    }];
    
    self.cycleScrollView.imageURLStringsGroup = images.copy;
}


#pragma mark - SDCycleScrollViewDelegate

- (Flash *)bannerAtIndex:(NSInteger)index {
    if (index < self.banners.count) {
        return self.banners[index];
    }
    return nil;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    Flash *banner = [self bannerAtIndex:index];
    if (banner.link.length > 0) {
        BaseWebViewController *vc = [[BaseWebViewController alloc]initWithWebViewType:BaseWebVCWebViewTypeFullScreen title:@"" urlString:banner.link];
        kNavPush(vc);
    }
}

@end
