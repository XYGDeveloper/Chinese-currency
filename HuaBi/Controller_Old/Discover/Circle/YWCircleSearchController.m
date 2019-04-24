



//
//  YWCircleSearchController.m
//  ywshop
//
//  Created by 周勇 on 2017/11/3.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWCircleSearchController.h"
#import "MSSAutoresizeLabelFlow.h"
#import "UIFont+YYAdd.h"
#import "MSSAutoresizeLabelFlowConfig.h"
#import "ChatKeyBoard.h"
#import "ChatToolBarItem.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "YWCircleListCell.h"
#import "YWCircleSpaceController.h"
#import "YWCircleCommentController.h"

NSString *searchDynamicHistoryKey = @"searchDynamicHistoryKey";


@interface YWCircleSearchController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,ChatKeyBoardDelegate,YWCircleListCellDeleagte>

@property(nonatomic,strong)HXSearchBar *searchBar;

@property(nonatomic,strong)MSSAutoresizeLabelFlow *fallView;
@property(nonatomic,strong)UILabel *tipsLabel;
@property(nonatomic,strong)UIButton *deleteButton;




@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isRefresh;

@property(nonatomic,assign)BOOL isShowKeyBoard;
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property(nonatomic,assign)BOOL isReply;

@property(nonatomic,strong)YWDynamicModel *selectedModel;

@property(nonatomic,strong)NSDictionary *replyInfo;




@end

@implementation YWCircleSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    
    [self setupUI];

    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.navigationController.navigationBar.hidden = YES;
    
}
-(void)setupUI
{
    self.view.backgroundColor = kWhiteColor;
    self.titleWithNoNavgationBar = @"";
    self.view.backgroundColor = kWhiteColor;
    
    CGFloat y = IS_IPHONE_X?(25 + 22):25;

    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(37, y, kScreenW -  37- 12, 34)];
    searchBar.searchBarTextField.font = PFRegularFont(14);
    searchBar.backgroundColor = kWhiteColor;
    searchBar.searchBarTextField.textColor = k323232Color;
    searchBar.searchBarTextField.backgroundColor = kBGColor;
    searchBar.hideSearchBarBackgroundImage = YES;
    searchBar.delegate = self;
    //输入框提示
    searchBar.placeholder = @"";
    //光标颜色
    searchBar.cursorColor = kColorFromStr(@"#426bf2");
    //TextField
    searchBar.searchBarTextField.layer.cornerRadius = 17;
    searchBar.searchBarTextField.layer.masksToBounds = YES;
    [self.view addSubview:searchBar];
    [searchBar becomeFirstResponder];
    _searchBar = searchBar;
    
    UIView *line = [[UIView alloc]initWithFrame:kRectMake(0, kNavigationBarHeight - 0.5, kScreenW, 0.5)];
    line.backgroundColor = kColorFromStr(@"cbcbcb");
    [self.view addSubview:line];
    __weak typeof(self)weakSelf = self;

    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    [_tableView registerNib:[UINib nibWithNibName:@"YWCircleListCell" bundle:nil] forCellReuseIdentifier:@"YWCircleListCell"];
    _tableView.backgroundColor = kBGColor;
    _tableView.tableHeaderView = [self setupHeaderView];
    
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
    }
    _tableView.hidden = YES;
    
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:kRectMake(kMargin,  kNavigationBarHeight + 11, 150, 16) text:kLocat(@"C_SearchHistory") font:[PFRegularFont(16) fontWithBold] textColor:kColorFromStr(@"232323") textAlignment:0 adjustsFont:NO];
    
    [self.view addSubview:tipsLabel];
    _tipsLabel = tipsLabel;
    UIButton *deleteButton= [[UIButton alloc]initWithFrame:kRectMake(kScreenW - kMargin - 16, 0, 16, 16)];
    [self.view addSubview:deleteButton];
    deleteButton.centerY = tipsLabel.centerY;
    [deleteButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [deleteButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [kUserDefaults setObject:@[] forKey:searchDynamicHistoryKey];
        [self.fallView reloadAllWithTitles:nil];
        
    }];
    _deleteButton = deleteButton;
    
    NSArray *historys = [kUserDefaults objectForKey:searchDynamicHistoryKey];
    
    MSSAutoresizeLabelFlowConfig *config =  [MSSAutoresizeLabelFlowConfig shareConfig];
    config.textColor = kColorFromStr(@"232323");
    config.itemColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    config.textFont = PFRegularFont(14);
    config.itemCornerRaius = 3;
    config.itemHeight = 32;
    
    MSSAutoresizeLabelFlow *fallView = [[MSSAutoresizeLabelFlow alloc]initWithFrame:CGRectMake(0, tipsLabel.bottom + 13, self.view.frame.size.width, kScreenH - tipsLabel.bottom - 13) titles:historys selectedHandler:^(NSUInteger index, NSString *title) {
        NSLog(@"%@",title);
        
        weakSelf.searchBar.text = title;
        [weakSelf.searchBar becomeFirstResponder];
        NSMutableArray *historys = [NSMutableArray arrayWithArray:[kUserDefaults objectForKey:searchDynamicHistoryKey]];
        [historys removeObjectAtIndex:index];
        [historys insertObject:title atIndex:0];
        [kUserDefaults setObject:historys.mutableCopy forKey:searchDynamicHistoryKey];
        [_fallView reloadAllWithTitles:historys];
        
    }];

    [self.view addSubview:fallView];
    _fallView = fallView;
    
    
    
//    _deleteButton.hidden = YES;
//    _tipsLabel.hidden = YES;
//    _fallView.hidden = YES;
    
    
}
-(UIView *)setupHeaderView
{
    UIView *headeView = [[UIView alloc]initWithFrame:kRectMake(0, 0, kScreenW, 26)];
    headeView.backgroundColor = kWhiteColor;
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:kRectMake(kMargin, 0, 100, 16) text:kLocat(@"C_Dynamic") font:PFRegularFont(16) textColor:kColorFromStr(@"8c8c8c") textAlignment:0 adjustsFont:YES];
    [headeView addSubview:tipLabel];
    [tipLabel alignVertical];
    UIView *line = [[UIView alloc]initWithFrame:kRectMake(0, 25.5, kScreenW, 0.5)];
    line.backgroundColor = kGrayLineColor;
    [headeView addSubview:line];
    return headeView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(void)loadDataWithPage:(NSInteger)page searchBar:(UISearchBar *)searchBar
{
    __weak typeof(self)weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"keyword"] = searchBar.text;
    param[@"page"] = @(page);
    
    param[@"act"] = @"district";
    param[@"op"] = @"search";
    param[@"uuid"] = [Utilities randomUUID];
    if (page == 1) {
        kShowHud;
    }
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kSearchDistrict] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [_tableView.mj_footer endRefreshing];
        if (page == 1) {
            kHideHud;
        }
        if (success) {
            NSArray *dataArr = [responseObj ksObjectForKey:kData][@"list"];
            if (_page == 1) {
                [_dataArray removeAllObjects];
            }
//            _resultCount = [[responseObj ksObjectForKey: kResult][@"count"] integerValue];
 
            if (dataArr.count == 0 && _dataArray.count == 0) {
                [self showTips:kLocat(@"C_NoSuchCOntent")];
                //                weakSelf.tableView.hidden = YES;
//                weakSelf.tipsLabel.text = @"共搜索到0条相关内容";
//                weakSelf.searchView.hidden = YES;
//                weakSelf.tableView.hidden = NO;
            }else{
                for (NSDictionary *dic in dataArr) {
                    YWDynamicModel *model = [YWDynamicModel modelWithDictionary:dic];
                    [weakSelf.dataArray addObject:model];
                }
//                weakSelf.searchView.hidden = YES;
//                weakSelf.tableView.hidden = NO;
//                weakSelf.tipsLabel.text = [NSString stringWithFormat:@"共搜索到%zd条相关内容",_resultCount];
                
            }
            [weakSelf.tableView reloadData];
            _isRefresh = NO;
            if (dataArr.count >= 10) {
                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    if (!_isRefresh) {
                        _page ++;
                        [weakSelf loadDataWithPage:_page searchBar:searchBar];
                    }
                    _isRefresh = YES;
                }];
            }else{
                [_tableView.mj_footer endRefreshingWithNoMoreData];
                //                _tableView.mj_footer = nil;
            }
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *rid = @"YWCircleListCell";
    YWCircleListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    cell.type = 1;
    cell.delegate = self;
    cell.model = self.dataArray[indexPath.section];
    cell.avatar.tag = indexPath.section;
    cell.tag = indexPath.section;
    cell.likeButton.tag = indexPath.section;
    cell.commentButton.tag = indexPath.section;
    cell.attentionButton.tag = indexPath.section;
    cell.shareButton.tag = indexPath.section;
    
    [cell.likeButton addTarget:self action:@selector(favourAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.attentionButton addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareButton addTarget:self action:@selector(showShareView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.avatar addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarTapAction:)]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YWCircleCommentController *vc = [[YWCircleCommentController alloc]init];
    vc.model = self.dataArray[indexPath.section];
    kNavPush(vc);
}

#pragma mark - 搜索按钮的点击事件
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length == 0 || [searchBar.text isEqualToString:@""]) {
        return;
    }
    
    [self.view endEditing:YES];
    
    NSMutableArray *historys = [NSMutableArray arrayWithArray:[kUserDefaults objectForKey:searchDynamicHistoryKey]];
    if ([historys containsObject:searchBar.text]) {
        NSUInteger index = [historys indexOfObject:searchBar.text];
        [historys removeObjectAtIndex:index];
        [historys insertObject:searchBar.text atIndex:0];
        [kUserDefaults setObject:historys.mutableCopy forKey:searchDynamicHistoryKey];
    }else{
        [historys insertObject:searchBar.text atIndex:0];

        [kUserDefaults setObject:historys.mutableCopy forKey:searchDynamicHistoryKey];
    }
    
    [self.fallView reloadAllWithTitles:historys];
    

    
    _fallView.hidden = YES;
    _deleteButton.hidden = YES;
    _tipsLabel.hidden = YES;
    //调搜索接口
    _tableView.hidden = NO;

    _page = 1;
    [self loadDataWithPage:_page searchBar:searchBar];
}

#pragma mark - 点击事件
//点赞
-(void)favourAction:(UIButton *)button
{
    if ([Utilities isExpired]) {
        [self showTips:kLocat(@"Tips_Login")];
        [self gotoLoginVC];
        return;
    }
    
    YWDynamicModel *model = self.dataArray[button.tag];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"district_id"] = model.district_id;
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"act"] = @"district";
    param[@"op"] = @"to_like";
    param[@"uuid"] = [Utilities randomUUID];
    kShowHud;
    __weak typeof(self)weakSelf = self;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kLikeAction] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
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
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"act"] = @"district";
    param[@"op"] = @"follows";
    param[@"member_id"] = self.dataArray[button.tag].member_id;
    param[@"uuid"] = [Utilities randomUUID];
    __weak typeof(self)weakSelf = self;
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kFollowAction] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
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
    
    [self.chatKeyBoard keyboardUpforComment];
    
    //    [_parentVC.chatKeyBoard keyboardUpforComment];
    
    
    
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"userDidTapCOmmentButton" object:nil];
    _isShowKeyBoard = YES;
    
    
    YWDynamicModel *model = self.dataArray[button.tag];
    _selectedModel = model;
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
        [self showTips:@"C_NoMoreThan140"];
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









#pragma mark - 行高计算
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat DistrictViewWith = kScreenW - 64 - 20;
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
    if (model.goods_url.length > 4) {
        rowHeight += 10 + 60;
    }
    
    //圈子
    rowHeight += 11;
    
    //评论
    if (model.comment_count.intValue != 0) {
        CGFloat y = 15;
        NSInteger commentCount = model.comment.count > 3 ? 3:model.comment.count;
        for (NSInteger i = 0; i < commentCount; i++) {
            NSString *commentStr ;
            if ([model.comment[i][@"parent_id"] integerValue] == 0) {//不是回复的评论
                commentStr = [NSString stringWithFormat:@"%@:%@",model.comment[i][@"username"],model.comment[i][@"content"]];
            }else{//评论回复.
                commentStr = [NSString stringWithFormat:@"%@%@%@:%@",model.comment[i][@"username"],kLocat(@"C_reply"),model.comment[i][@"reply_username"],model.comment[i][@"content"]];
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
    rowHeight += 20 + 40 + 15 - 20;
    
    return rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section) {
        return 10;
    }else{
        return 0.01;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


-(void)configureKeyboard
{
    self.chatKeyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:NO];
    self.chatKeyBoard.delegate = self;
    
    self.chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
    
    [self.view addSubview:self.chatKeyBoard];
    self.chatKeyBoard.allowSwitchBar = NO;
    [self.chatKeyBoard keyboardDownForComment];
    self.chatKeyBoard.allowVoice = NO;
    self.chatKeyBoard.allowFace = NO;
    self.chatKeyBoard.allowMore = NO;
    self.chatKeyBoard.backgroundColor = kBGColor;
}

-(ChatKeyBoard *)chatKeyBoard
{
    if (_chatKeyBoard == nil) {
        _chatKeyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:NO];
        _chatKeyBoard.delegate = self;
        
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        [self.view addSubview:_chatKeyBoard];
        _chatKeyBoard.allowSwitchBar = NO;
        [_chatKeyBoard keyboardDownForComment];
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowFace = NO;
        _chatKeyBoard.allowMore = NO;
        _chatKeyBoard.backgroundColor = kBGColor;
        
    }
    return _chatKeyBoard;
}




-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
