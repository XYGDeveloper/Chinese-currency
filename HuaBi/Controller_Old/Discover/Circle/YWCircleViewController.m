//
//  YWCircleViewController.m
//  ywshop
//
//  Created by 周勇 on 2017/10/26.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWCircleViewController.h"
#import "YWCircleListCell.h"
#import "YWCircleChangeController.h"
#import "YWCircleIssueController.h"
#import "CoreCaptureHeader.h"
#import "UIWindow+PazLabs.h"
//#import "YWDiscoverViewController.h"
#import "ChatKeyBoard.h"
#import "ChatToolBarItem.h"
#import "ChatToolBar.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "YWCircleCommentController.h"
#import "YWCircleSearchController.h"
#import "YWCircleSpaceController.h"
//#import "YWCircleReportController.h"
#import "YBPopupMenu.h"




@interface YWCircleViewController     ()<UITableViewDelegate,UITableViewDataSource,YWCircleListCellDeleagte,ChatKeyBoardDelegate,YBPopupMenuDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)NSMutableArray<YWDynamicModel *> *dataArray;
@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isRefresh;

@property(nonatomic,assign)BOOL isShowKeyBoard;
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property(nonatomic,assign)BOOL isReply;

@property(nonatomic,strong)NSDictionary *replyInfo;
@property(nonatomic,strong)YWDynamicModel *selectedModel;

//@property(nonatomic,strong)YWDiscoverViewController *parentVC;

@property(nonatomic,strong)UILabel *circleNameLabel;
@property(nonatomic,strong)UILabel *circleInfoLabel;
@property(nonatomic,strong)UIImageView *circleIconImgView;
@property(nonatomic,strong)YWCircleGroupModel *saveModel;

@property(nonatomic,strong)UIButton *submitButton;
@property(nonatomic,strong)UIView *bgView;


@end

@implementation YWCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _dataArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserSubmitType:) name:kChooseSubmitTypeKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidChangeDynamicModelAttention:) name:@"kUserDidChangeDynamicModelAttention" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidChangeDynamicModelLike:) name:@"kUserDidChangeDynamicModelLick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidChangeDynamicModelComment:) name:@"kUserDidChangeDynamicModelCommentAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChooseCirclGroup:) name:@"kUserDidChooseGroupKey" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidSubmitDistrict) name:kDidSubmitDistrictKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidSubmitDistrict) name:@"refreshCircleDataKey" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidSubmitDistrict) name:kLoginOutKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidSubmitDistrict) name:kLoginSuccessKey object:nil];

    
    
    
    [self setupUI];
    [self configureKeyboard];
    
//    _parentVC = (YWDiscoverViewController *)self.parentViewController;
    
    [self loadCircleInfo];
//    self.navigationController.navigationBar.translucent = NO;

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        self.navigationController.navigationBar.hidden = YES ;

//    [[IQKeyboardManager sharedManager] setEnable:NO];
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
}
-(void)setupUI
{
    
    [self.view addSubview: [self setupHeaderView]];
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,_headView.bottom, kScreenW, kScreenH - _headView.bottom - kTabbarItemHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    [_tableView registerNib:[UINib nibWithNibName:@"YWCircleListCell" bundle:nil] forCellReuseIdentifier:@"YWCircleListCell"];
    _tableView.backgroundColor = kBGColor;

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
//    _tableView.tableHeaderView = [self setupHeaderView];
    __weak typeof(self)weakSelf = self;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [weakSelf loadDataWithPage:_page];
        _isRefresh = YES;
    }];
    // 隐藏更新时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    [header setTitle:kLocat(@"R_PullDown") forState:MJRefreshStateIdle];
    [header setTitle:kLocat(@"R_Release") forState:MJRefreshStatePulling];
    [header setTitle:kLocat(@"R_Loading") forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    
    [_tableView.mj_header beginRefreshing];

    [self addSubmitView];
}
-(UIView *)setupHeaderView
{
    CGFloat h = 78 + 10;

    UIView *topView = [[UIView alloc]initWithFrame:kRectMake(0, kStatusBarHeight, kScreenW, h)];
    topView .backgroundColor = [UIColor colorWithRed:0.13 green:0.14 blue:0.21 alpha:1.00];
    _headView = topView;
    [self.view addSubview:topView];
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:kRectMake(0, 0, kScreenW, h-10)];
    bgView.image = [UIImage imageNamed:@"bg_img"];
    [topView addSubview:bgView];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:kRectMake(kMargin, 14, topView.height - 28 - 10, topView.height - 28 - 10)];
//    icon.image = [UIImage imageNamed:@"tu_1"];
    [topView addSubview:icon];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:kRectMake(icon.right + 7, icon.top, 200, 18) text:@"广东深圳圈" font:PFRegularFont(18) textColor:kWhiteColor textAlignment:0 adjustsFont:NO];
    
    [topView addSubview:nameLabel];
    
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:kRectMake(nameLabel.left, 0, 300, 16)];
    [topView addSubview:infoLabel];
    infoLabel.textColor = kWhiteColor;
    infoLabel.font = PFRegularFont(14);
    infoLabel.bottom = icon.bottom;
    infoLabel.text = @"信息12 人气21212";
    
    YLButton *changeButton = [[YLButton alloc]initWithFrame:kRectMake(kScreenW - kMargin - 56, 0, 56, 45)];
    [changeButton setImage:[UIImage imageNamed:@"qiehuan"] forState:UIControlStateNormal];
    [changeButton setTitle:kLocat(@"R_ChangeCoinCircle") forState:UIControlStateNormal];
    [topView addSubview:changeButton];
    changeButton.centerY =icon.centerY;
    changeButton.imageRect = kRectMake(14, 0, 28, 28);
    changeButton.titleRect = kRectMake(0, 32, changeButton.width, 14);
    [changeButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    changeButton.titleLabel.font = PFRegularFont(14);
    changeButton.titleLabel.textAlignment = 1;
    changeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [changeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        YWCircleChangeController *vc = [[YWCircleChangeController alloc]init];
        vc.cityID = _saveModel.group_city;
        kNavPush(vc);
    }];
    
    UILabel * marginView = [[UILabel alloc]initWithFrame:kRectMake(0, h - 10, topView.width, 10)];
    marginView.backgroundColor = kBGColor;
    [topView addSubview:marginView];

    _circleIconImgView = icon;
    _circleInfoLabel = infoLabel;
    _circleNameLabel = nameLabel;
    
    YWCircleGroupModel *model = [YWCircleGroupModel circleGroupModel];
    if (model != nil) {
//        _circleNameLabel.text = [NSString stringWithFormat:@"%@%@",model.city_name,model.group_name];
        _circleNameLabel.text = [NSString stringWithFormat:@"%@",model.group_name];


        _circleInfoLabel.text = [NSString stringWithFormat:@"%@ %@  %@ %@",kLocat(@"R_Message"),model.note_count,kLocat(@"R_Popularity"),model.popularity_count];
        [_circleIconImgView setImageURL:model.group_logo.ks_URL];
    }else{
        _circleNameLabel.text = @"";
        _circleInfoLabel.text = [NSString stringWithFormat:@"%@ 0  %@ 0",kLocat(@"R_Message"),kLocat(@"R_Popularity")];
        [_circleIconImgView setImageURL:nil];
    }
    _saveModel = model;
    
    return topView;
}

-(void)didChooseCirclGroup:(NSNotification *)noti
{
    YWCircleGroupModel *model = noti.object;
    
    if (![model.group_id isEqualToString:_saveModel.group_id]) {
        _page = 1;
        [_dataArray removeAllObjects];
        _saveModel = model;
        kShowHud;
        [self.tableView reloadData];
        [self loadDataWithPage:1];
    }
    _saveModel = model;
    
    
    
    [model saveCirclrGroupModel];
    
//    _circleNameLabel.text = [NSString stringWithFormat:@"%@%@",model.city_name,model.group_name];
    _circleNameLabel.text = [NSString stringWithFormat:@"%@",model.group_name];

    
    _circleInfoLabel.text = [NSString stringWithFormat:@"%@ %@  %@ %@",kLocat(@"R_Message"),model.note_count,kLocat(@"R_Popularity"),model.popularity_count];
    [_circleIconImgView setImageURL:model.group_logo.ks_URL];
//    [kUserDefaults setObject:_circleNameLabel.text forKey:kCurrentCircleNameKey];
}

-(void)loadDataWithPage:(NSInteger)page
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString *url;
    
    if (_listType == 0) {
        url = [Utilities handleAPIWith:kGetDistrictList];
        param[@"request_type"] = @"list";
        if (_saveModel == nil) {
            param[@"group_id"] = @"1";
        }else{
            param[@"group_id"] = _saveModel.group_id;
        }
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"act"] = @"district";
        param[@"op"] = @"read";
    }else{
        url = [Utilities handleAPIWith:kAttentionList];
        param[@"act"] = @"District";
        param[@"op"] = @"followlist";
        param[@"token_id"] = @(kUserInfo.uid);
    }
    param[@"page"] = @(page);

    param[@"key"] = kUserInfo.token;
    param[@"uuid"] = [Utilities randomUUID];
    
    __weak typeof(self)weakSelf = self;
    

    [kNetwork_Tool POST_HTTPS:url andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        kHideHud;
        if (success) {
            
            NSArray *datas = [responseObj ksObjectForKey:kData][@"list"];
            
            if (datas.count == 0 && _dataArray.count == 0) {
                [self showTips:kLocat(@"C_NoDynamic")];
                return ;
            }
            
            if (page == 1) {
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dic in datas) {
                [weakSelf.dataArray addObject:[YWDynamicModel modelWithDictionary:dic]];
            }
            [weakSelf.tableView reloadData];
            
            _isRefresh = NO;
            if (datas.count >= 10) {
                MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    if (!_isRefresh) {
                        _page ++;
                        [weakSelf loadDataWithPage:_page];
                    }
                    _isRefresh = YES;
                }];
                [footer setTitle:kLocat(@"R_Loading") forState:MJRefreshStateRefreshing];
                _tableView.mj_footer = footer;
            }else{
                [_tableView.mj_footer endRefreshingWithNoMoreData];
                //                _tableView.mj_footer = nil;
            }
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

#pragma mark - 获取商圈信息
-(void)loadCircleInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"act"] = @"district";
    param[@"op"] = @"group";
    param[@"request_type"] = @"one";
    
    NSString *groupId = _saveModel.group_id;
    if (groupId) {
        param[@"group_id"] = groupId;
    }else{
        param[@"group_id"] = @"1";
    }
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"uuid"] = [Utilities randomUUID];
    __weak typeof(self)weakSelf = self;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kGetGroupInfo] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
       
        if (success) {
            weakSelf.saveModel = [YWCircleGroupModel modelWithJSON:[responseObj ksObjectForKey:kData]];
            
//            weakSelf.circleNameLabel.text = [NSString stringWithFormat:@"%@%@",weakSelf.saveModel.city_name,weakSelf.saveModel.group_name];
            weakSelf.circleNameLabel.text = [NSString stringWithFormat:@"%@",weakSelf.saveModel.group_name];

//            [kUserDefaults setObject:weakSelf.circleNameLabel.text forKey:kCurrentCircleNameKey];
            weakSelf.circleInfoLabel.text = [NSString stringWithFormat:@"%@ %@  %@ %@",kLocat(@"R_Message"),weakSelf.saveModel.note_count,kLocat(@"R_Popularity"),weakSelf.saveModel.popularity_count];
            [weakSelf.circleIconImgView setImageURL:weakSelf.saveModel.group_logo.ks_URL];
            [weakSelf.saveModel saveCirclrGroupModel];
        }
    }];
}

-(void)userDidSubmitDistrict
{
    _page = 1;
    [self loadDataWithPage:_page];
}

#pragma mark - 添加发布按钮
-(void)addSubmitView
{
    UIButton *addButton = [[UIButton alloc]initWithFrame:kRectMake(kScreenW - 5 - 64, kScreenH - kTabbarItemHeight - 10 - 64, 64, 64)];
    [self.view addSubview:addButton];
    [addButton setImage:[UIImage imageNamed:@"release"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"release_close"] forState:UIControlStateSelected];
    
    kViewBorderRadius(addButton, 32, 0, kRedColor);
    
    _submitButton = addButton;
    //    addButton.hidden = YES;
    [addButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)submitButtonAction:(UIButton *)button
{
    _submitButton.hidden = YES;
    
    [kKeyWindow addSubview:self.bgView];
    for (UIButton *btn in self.bgView.subviews) {
        if (btn.tag == 0) {
            [UIView animateWithDuration:0.25 animations:^{
                //                btn.frame = kRectMake(btn.x - 5, btn.y  - 64 - 78, 64, 64);
            }];
            
            [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                btn.frame = kRectMake(btn.x - 5, btn.y  - 64 - 78, 64, 64);
                
            } completion:^(BOOL finished) {
            }];
            
        }else if (btn.tag == 1){
            //            [UIView animateWithDuration:0.25 animations:^{
            //                btn.frame = kRectMake(btn.x - 85, btn.y - 92, 64, 64);
            //            }];
            [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                btn.frame = kRectMake(btn.x - 85, btn.y - 92, 64, 64);
            } completion:^(BOOL finished) {
            }];
        }else if (btn.tag == 2){
            //            [UIView animateWithDuration:0.25 animations:^{
            //                btn.frame = kRectMake(btn.x - 64 - 64, btn.y - 5, 64, 64);
            //            }];
            [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                btn.frame = kRectMake(btn.x - 64 - 64, btn.y - 5, 64, 64);
            } completion:^(BOOL finished) {
            }];
        }
    }
}
-(UIView *)bgView
{
    if (_bgView == nil) {
        
        _bgView = [[UIView alloc]initWithFrame:kScreenBounds];
        
        _bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.2];
        
        _bgView.userInteractionEnabled = YES;
        
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelSubmitAction:)]];
        
        UIButton *cancelButton = [[UIButton alloc]initWithFrame:kRectMake(kScreenW - 5 - 64, kScreenH - kTabbarItemHeight - 10 - 64, 64, 64)];
        [_bgView addSubview:cancelButton];
        [cancelButton setImage:[UIImage imageNamed:@"release_close"] forState:UIControlStateNormal];
        cancelButton.tag = 3;
        [cancelButton addTarget:self action:@selector(cancelSubmitAction:) forControlEvents:UIControlEventTouchUpInside];
        
        for (NSInteger i = 0; i < 3; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:kRectMake(kScreenW - 5 - 64, kScreenH - kTabbarItemHeight - 10 - 64, 64, 64)];
            [_bgView addSubview:btn];
            
            if (i == 0) {
                NSString *imgName = nil;
                if ([[LocalizableLanguageManager userLanguage] isEqualToString:CHINESEradition]) {
                    imgName = @"release_Vid_fan";
                }else if([[LocalizableLanguageManager userLanguage] isEqualToString:ENGLISH]){
                    imgName = @"release_Vid_eng";
                }else{
                    imgName = @"release_Vid";
                }
                [btn setImage:kImageFromStr(imgName) forState:UIControlStateNormal];
            }else if(i == 1){
                NSString *imgName = nil;
                if ([[LocalizableLanguageManager userLanguage] isEqualToString:CHINESEradition]) {
                    imgName = @"release_img_fan";
                }else if([[LocalizableLanguageManager userLanguage] isEqualToString:ENGLISH]){
                    imgName = @"release_img_eng";
                }else{
                    imgName = @"release_img";
                }
                [btn setImage:kImageFromStr(imgName) forState:UIControlStateNormal];
            }else{
                NSString *imgName = nil;
                if ([[LocalizableLanguageManager userLanguage] isEqualToString:CHINESEradition]) {
                    imgName = @"release_search_fan";
                }else if([[LocalizableLanguageManager userLanguage] isEqualToString:ENGLISH]){
                    imgName = @"release_search_eng";
                }else{
                    imgName = @"release_search";
                }
                [btn setImage:kImageFromStr(imgName) forState:UIControlStateNormal];
            }
            btn.tag = i;
            [btn addTarget:self action:@selector(subButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    return _bgView;
}
-(void)subButtonsAction:(UIButton *)button
{
    [self cancelSubmitAction:button];
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kChooseSubmitTypeKey object:@(button.tag)];
    switch (button.tag) {
        case 0://视频
        {
            YWCircleIssueController *vc = [[YWCircleIssueController alloc] init];
            vc.type = 0;
            vc.groupModel = _saveModel;
            kNavPush(vc);
        }
            break;
        case 1://图文
        {
            YWCircleIssueController *vc = [[YWCircleIssueController alloc] init];
            vc.type = 1;
            vc.groupModel = _saveModel;
            kNavPush(vc);
        }
            break;
        case 2://搜索
        {
            YWCircleSearchController *vc = [[YWCircleSearchController alloc] init];
            kNavPush(vc);
        }
            break;
        default:
            break;
    }
}
-(void)cancelSubmitAction:(UIButton *)button
{
    for (UIButton *btn in _bgView.subviews) {
        if (btn.tag != 3) {
            [UIView animateWithDuration:0.25 animations:^{
                
                btn.frame = kRectMake(kScreenW - 5 - 64, kScreenH - kTabbarItemHeight - 10 - 64, 64, 64);
            }completion:^(BOOL finished) {
                [self.bgView removeFromSuperview];
                _submitButton.hidden = NO;
            }];
        }
    }
}


#pragma mark - tableView数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"YWCircleListCell";
    YWCircleListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    cell.delegate = self;
    cell.model = self.dataArray[indexPath.section];
    cell.avatar.tag = indexPath.section;
    cell.tag = indexPath.section;
    cell.likeButton.tag = indexPath.section;
    cell.commentButton.tag = indexPath.section;
    cell.attentionButton.tag = indexPath.section;
    cell.shareButton.tag = indexPath.section;
//    cell.reportButton.tag = indexPath.section;
    [cell.likeButton addTarget:self action:@selector(favourAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.attentionButton addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.showMoreButton addTarget:self action:@selector(showMoreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareButton addTarget:self action:@selector(showShareView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.avatar addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarTapAction:)]];
//    [cell.reportButton addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YWCircleCommentController *vc = [[YWCircleCommentController alloc]init];
    vc.model = self.dataArray[indexPath.section];
    kNavPush(vc);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}



#pragma mark - 行高计算
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat DistrictViewWith = kScreenW - 12 - 8 - 30;
    
    YWDynamicModel *model = self.dataArray[indexPath.section];
    CGFloat rowHeight = 52;
    //文字内容
    if (model.content == nil || [model.content isEqualToString:@""]) {
        rowHeight += 0;
    }else{
        
        CGSize contentSize = [Utilities getSpaceLabelHeight:model.content withFont:PFRegularFont(14) withWidth:DistrictViewWith lineSpace:UILABEL_LINE_SPACE];
        
        rowHeight += contentSize.height + 10;
    }
    
    //图片
    if ([model.attachments_type isEqualToString:@"video"]) {
        rowHeight += 15 + OnePicWidth;
    }else{
        //图片
        CGFloat margin = 5;
        CGFloat picW = (DistrictViewWith - margin * 2) / 3;
        if (model.attachments.count == 0 ) {
            rowHeight += 0;
        }else if (model.attachments.count == 1){
            rowHeight += (16 + OnePicWidth);
        }else if (model.attachments.count < 4){
            rowHeight += (16 + picW + margin);
        }else if (model.attachments.count < 7){
            rowHeight += (16 + picW * 2 + 2 * margin);
        }else{
            rowHeight += (16 + DistrictViewWith);
        }
    }
    
    //商品
    if (model.goods_url.length > 3) {
        rowHeight += 10 + 60;
    }
    
    //圈子
    rowHeight += 11;
    
    //评论
    if (model.comment.count != 0) {
        CGFloat y = 15;
        NSInteger commentCount = model.comment.count > 3 ? 3:model.comment.count;
        for (NSInteger i = 0; i < commentCount; i++) {
            NSString *commentStr ;
            if ([model.comment[i][@"parent_id"] integerValue] == 0) {//不是回复的评论
                commentStr = [NSString stringWithFormat:@"%@:%@",model.comment[i][@"username"],model.comment[i][@"content"]];
            }else{//评论回复.
                commentStr = [NSString stringWithFormat:@"%@回复%@:%@",model.comment[i][@"username"],model.comment[i][@"reply_username"],model.comment[i][@"content"]];
            }
            CGSize size = [Utilities calculateWidthAndHeightWithWidth:DistrictViewWith height:CGFLOAT_MAX text:commentStr font:PFRegularFont(14)].size;
            y += size.height;
        }
        if (model.comment.count > 3) {
            y += 14 + 2;
        }
        rowHeight += y;
        
    }else{//没有评论
    }
    //底部按钮 + 间距
    rowHeight += 20 + 40 + 15;
    
    return rowHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - cell上面的点击事件
//点赞
-(void)favourAction:(UIButton *)button
{
    if ([Utilities isExpired]) {
        [self showTips:kLocat(@"C_DeleteSuccess")];
        [self gotoLoginVC];
        return;
    }
    
    YWDynamicModel *model = self.dataArray[button.tag];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"district_id"] = model.district_id;
    param[@"key"] = kUserInfo.token;
    param[@"act"] = @"district";
    param[@"op"] = @"to_like";
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"uuid"] = [Utilities randomUUID];
//    kShowHud;
    __weak typeof(self)weakSelf = self;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kLikeAction] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
//        kHideHud;
        if (success) {

            NSDictionary *dic = [responseObj ksObjectForKey:kData];
            if ([dic[@"is_like"] integerValue] == 0 ) {
                button.selected = NO;
            }else{
                button.selected = YES;
            }
            if ([dic[@"likes"]integerValue]== 0) {
                [button setTitle:@"" forState:UIControlStateNormal];
            }else{
                [button setTitle:dic[@"likes"] forState:UIControlStateNormal];
            }
            weakSelf.dataArray[button.tag].is_like = [NSString stringWithFormat:@"%@",dic[@"is_like"]];
            weakSelf.dataArray[button.tag].likes = dic[@"likes"];
            //            weakSelf.model.is_like = [NSString stringWithFormat:@"%@",dic[@"is_like"]];
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}
//关注
-(void)attentionAction:(UIButton *)button
{
    if ([Utilities isExpired]) {
        [self showTips:kLocat(@"Tips_Login")];
        [self gotoLoginVC];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    BOOL isFans;
    if (button.isSelected == YES) {
        param[@"request_type"] = @"canel_follow";
        isFans = YES;
    }else{
        param[@"request_type"] = @"to_follow";
        isFans = NO;
    }
    
    param[@"member_id"] = self.dataArray[button.tag].member_id;
    param[@"key"] = kUserInfo.token;
    param[@"act"] = @"district";
    param[@"op"] = @"follows";
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"uuid"] = [Utilities randomUUID];
    __weak typeof(self)weakSelf = self;
    
//    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kFollowAction] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
//        kHideHud;
        if (success) {
            button.selected = !isFans;
            
            if (isFans) {
                weakSelf.dataArray[button.tag].is_follow = @"0";
                
                [self.dataArray enumerateObjectsUsingBlock:^(YWDynamicModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.member_id isEqualToString:weakSelf.dataArray[button.tag].member_id]) {
                        obj.is_follow = @"0";
                        [weakSelf.tableView reloadSection:idx withRowAnimation:UITableViewRowAnimationNone];
                    }
                }];
                
            }else{
                weakSelf.dataArray[button.tag].is_follow = @"1";
                [self.dataArray enumerateObjectsUsingBlock:^(YWDynamicModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.member_id isEqualToString:weakSelf.dataArray[button.tag].member_id]) {
                        obj.is_follow = @"1";
                        [weakSelf.tableView reloadSection:idx withRowAnimation:UITableViewRowAnimationNone];
                    }
                }];
                
            }
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];;
        }
    }];
}
//点击评论按钮
-(void)commentAction:(UIButton *)button
{
    if (_isShowKeyBoard) {
        [self.view endEditing:YES];
        _isShowKeyBoard = NO;
        return;
    }
    _isReply = NO;
    self.chatKeyBoard.placeHolder = kLocat(@"Dis_SaySomeThing");
//    [self.chatKeyBoard keyboardUp];
    [self.chatKeyBoard keyboardUpforComment];
    
//    [self.chatKeyBoard.chatToolBar.textView becomeFirstResponder];
//    [_parentVC.chatKeyBoard keyboardUpforComment];


    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"userDidTapCOmmentButton" object:nil];
    _isShowKeyBoard = YES;
    
    
    YWDynamicModel *model = self.dataArray[button.tag];
    _selectedModel = model;
}

//点击查看更多
-(void)showMoreButtonAction:(UIButton *)button
{
    YWCircleCommentController *vc = [[YWCircleCommentController alloc]init];
    vc.model = self.dataArray[button.tag];
    vc.toScroll = YES;
    kNavPush(vc);
}
//分享
-(void)showShareView:(UIButton *)button
{
    JSYShareView *shareView = [[JSYShareView alloc]initWithFrame:kScreenBounds model:self.dataArray[button.tag] type:JSYShareViewTypeCircle];
    //    shareView.urlStr = [NSString strin WithFormat:@"%@/api/district/shares?resourceid=%@",kBasePath,_model.district_id];
    [kKeyWindow addSubview:shareView];
}
//点击头像
-(void)avatarTapAction:(UITapGestureRecognizer *)tap
{
    NSInteger uid = self.dataArray[tap.view.tag].member_id.integerValue;
    YWCircleSpaceController *vc = [YWCircleSpaceController new];
        if (uid == kUserInfo.uid) {
            vc.type = YWCircleSpaceControllerMine;
        }else{
            vc.type = YWCircleSpaceControllerOther;
            vc.memberId = self.dataArray[tap.view.tag].member_id;
        }
    kNavPush(vc);
}


#pragma mark - 处理用户选择了什么类型的内容发布
-(void)handleUserSubmitType:(NSNotification *)noti
{    
    switch ([noti.object integerValue]) {
        case 0:
        {
            
            if ([Utilities isExpired]) {
                [self gotoLoginVC];
            }else{
                YWCircleIssueController *vc = [[YWCircleIssueController alloc] init];
                vc.type = 0;
                vc.groupModel = _saveModel;
                kNavPush(vc);
            }
        }
            break;
        case 1:
        {//图文
            if ([Utilities isExpired]) {
                [self gotoLoginVC];
            }else{
                YWCircleIssueController *vc = [YWCircleIssueController new];
                vc.type = 1;
                vc.groupModel = _saveModel;
                kNavPush(vc);
            }
        }
            break;
        case 2:
        { 
            //搜索
            YWCircleSearchController *vc = [YWCircleSearchController new];
            kNavPush(vc);
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 评论修改了model信息的通知
//关注
-(void)userDidChangeDynamicModelAttention:(NSNotification *)noti
{
    YWDynamicModel *model = noti.object;
    BOOL isFans = model.is_follow.boolValue;
    if (isFans) {
        [self.dataArray enumerateObjectsUsingBlock:^(YWDynamicModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.member_id isEqualToString:model.member_id]) {
                obj.is_follow = @"1";
                [self.tableView reloadSection:idx withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }else{
        [self.dataArray enumerateObjectsUsingBlock:^(YWDynamicModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.member_id isEqualToString:model.member_id]) {
                obj.is_follow = @"0";
                [self.tableView reloadSection:idx withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
}
//点赞
-(void)userDidChangeDynamicModelLike:(NSNotification *)noti
{
    YWDynamicModel *model = noti.object;
    if ([self.dataArray containsObject:model] == NO) {
        return;
    }
    NSInteger idx = [self.dataArray indexOfObject:model];
    [self.dataArray replaceObjectAtIndex:idx withObject:model];
    [self.tableView reloadSection:idx withRowAnimation:UITableViewRowAnimationNone];
}
-(void)userDidChangeDynamicModelComment:(NSNotification *)noti
{
    YWDynamicModel *model = noti.object;
    if (![self.dataArray containsObject:model]) {
        return;
    }
    
    NSInteger idx = [self.dataArray indexOfObject:model];
    [self.dataArray replaceObjectAtIndex:idx withObject:model];
    [self.tableView reloadSection:idx withRowAnimation:UITableViewRowAnimationNone];    
}



#pragma mark - 键盘回调
-(void)chatKeyBoardSendText:(NSString *)text
{
    [self.chatKeyBoard keyboardDownForComment];
    
    if ([Utilities isExpired]) {
        [self showTips:kLocat(@"Tips_Login")];
        [self gotoLoginVC];
        return;
    }
    
    if (text.length > 140) {
        [self showTips:kLocat(@"C_NoMoreThan140")];
        return;
    }
    NSUInteger index = [self.dataArray indexOfObject:_selectedModel];
    if (_isReply) {
        
        [self submitCommentWithDistrictID:_selectedModel.district_id content:text parentID:_replyInfo[@"comment_id"] modelIndex:index];
        
    }else{
        [self submitCommentWithDistrictID:self.selectedModel.district_id content:text parentID:@"0" modelIndex:[self.dataArray indexOfObject:_selectedModel]];
    }
}
//发布评论的接口
-(void)submitCommentWithDistrictID:(NSString *)disID content:(NSString *)content parentID:(NSString *)parentId modelIndex:(NSInteger)index
{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"district_id"] = disID;
    param[@"content"] = content;
    param[@"parent_id"] = parentId;
    param[@"token_id"] = @(kUserInfo.uid);

    param[@"act"] = @"district";
    param[@"op"] = @"comment_push";
    param[@"key"] = kUserInfo.token;
    param[@"uuid"] = [Utilities randomUUID];
    kShowHud;
    __weak typeof(self)weakSelf = self;
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kCommentAction] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        
        kHideHud;
        if (success) {
            NSMutableArray *commentsArr = [NSMutableArray arrayWithCapacity:weakSelf.dataArray[index].comment.count];
            for (NSDictionary *dic in weakSelf.dataArray[index].comment) {
                [commentsArr addObject:dic];
            }
            if (commentsArr.count == 0) {
                [commentsArr insertObject:[responseObj ksObjectForKey:kData] atIndex:0];
            }else{
                [commentsArr insertObject:[responseObj ksObjectForKey:kData] atIndex:1];
            }
            weakSelf.dataArray[index].comment = commentsArr.mutableCopy;
            weakSelf.dataArray[index].comment_count = [NSString stringWithFormat:@"%zd",commentsArr.count];

            [weakSelf.tableView reloadSection:index withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}


#pragma mark - 点击评论的代理事件
- (void)commnetLabel:(UIView *)commentLabel userDidClickJSYCircleListCellCommentWithInfo:(NSDictionary *)dic
{ 
    if (_isShowKeyBoard) {
        [self.view endEditing:YES];
        _isShowKeyBoard = NO;
        return;
    }
    YWDynamicModel *model = self.dataArray[commentLabel.superview.superview.superview.tag];
    _selectedModel = model;
    if ([dic[@"member_id"]integerValue] == kUserInfo.uid) {
        //自己的评论
        [self showDeleteAlertViewWithId:dic[@"comment_id"] index:commentLabel.superview.superview.superview.tag commentIndex:commentLabel.tag];
    }else{
        _isReply = YES;
        
//        [_parentVC.chatKeyBoard keyboardUpforComment];

        [self.chatKeyBoard keyboardUpforComment];
        self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"%@%@: ",kLocat(@"C_reply"),dic[@"username"]];
        _isShowKeyBoard = YES;
        _replyInfo = dic;
    }
    
}

#pragma mark - 删除评论
-(void)showDeleteAlertViewWithId:(NSString *)commentId index:(NSInteger)index commentIndex:(NSInteger)commetIndex
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:kLocat(@"Dis_DeleteThisComment") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteCommentWithId:commentId index:index commentIndex:commetIndex];
    }];
    [deleteAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)deleteCommentWithId:(NSString *)commentId index:(NSInteger)index commentIndex:(NSInteger)commetIndex
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"comment_id"] = commentId;
    param[@"act"] = @"district";
    param[@"op"] = @"district_comment_remove";
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"uuid"] = [Utilities randomUUID];
    __weak typeof(self)weakSelf = self;
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kDeleteComment] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        if (success) {
            NSMutableArray *temArr = [NSMutableArray arrayWithArray:weakSelf.dataArray[index].comment];
            
            [temArr removeObjectAtIndex:commetIndex];
            
            weakSelf.dataArray[index].comment = temArr.mutableCopy;
            
            [weakSelf.tableView reloadSection:index withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}


-(BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
//    [self.parentVC.chatKeyBoard keyboardDownForComment];

    _isShowKeyBoard = NO;
}
-(void)configureKeyboard
{
    self.chatKeyBoard = [ChatKeyBoard keyBoard];
//    self.chatKeyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:NO];

    self.chatKeyBoard.delegate = self;
    self.chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
    kLOG(@"%@",self.view);
    [self.view addSubview:self.chatKeyBoard];
    self.chatKeyBoard.allowSwitchBar = NO;
    [self.chatKeyBoard keyboardDownForComment];
    self.chatKeyBoard.allowVoice = NO;
    self.chatKeyBoard.allowFace = NO;
    self.chatKeyBoard.allowMore = NO;
    self.chatKeyBoard.backgroundColor = kBGColor;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
