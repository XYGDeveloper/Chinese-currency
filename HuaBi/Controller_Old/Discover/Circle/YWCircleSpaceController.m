//
//  YWCircleSpaceController.m
//  ywshop
//
//  Created by 周勇 on 2017/11/6.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWCircleSpaceController.h"
#import "YWCircleSpaceTopView.h"
#import "YWCircleIssueController.h"
#import "YWCircleSpaceListCell.h"
#import "ChatKeyBoard.h"
#import "ChatToolBarItem.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "JSYCommonAlertView.h"
#import "YWCircleCommentController.h"


#define kHEIGHT 374/2.0

@interface YWCircleSpaceController ()<UITableViewDelegate,UITableViewDataSource,YWCircleListCellDeleagte,ChatKeyBoardDelegate,JSYCommonAlertViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *naviBar;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isRefresh;

@property(nonatomic,strong)NSMutableArray<YWDynamicModel *> *dataArray;


@property(nonatomic,strong)NSDictionary *infoDic;

@property(nonatomic,strong)YWDynamicModel *toDeleteModel;

@property(nonatomic,assign)BOOL isShowKeyBoard;

@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;

@property(nonatomic,assign)BOOL isReply;

@property(nonatomic,strong)NSDictionary *replyInfo;

@property(nonatomic,strong)YWDynamicModel *selectedModel;

@property(nonatomic,strong)YWCircleSpaceTopView *topView;


@end

@implementation YWCircleSpaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    _dataArray = [NSMutableArray array];
    [self setupUI];
    kShowHud;
    [self loadDataWithPage:1];
    [self configureKeyboard];
    
    [self loadUserInfo];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)setupUI
{
    self.view.backgroundColor = kWhiteColor;
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"YWCircleSpaceListCell" bundle:nil] forCellReuseIdentifier:@"YWCircleSpaceListCell"];
    _tableView.backgroundColor = kWhiteColor;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(kHEIGHT, 0, 0, 0);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kHEIGHT, [UIScreen mainScreen].bounds.size.width, kHEIGHT)];
    imageView.image = [UIImage imageNamed:@"geren_bg"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.tag = 101;
    [self.tableView addSubview:imageView];

    YWCircleSpaceTopView *bgView = [[[NSBundle mainBundle] loadNibNamed:@"YWCircleSpaceTopView" owner:self options:nil]lastObject];
    bgView.frame = kRectMake(0, -kHEIGHT, kScreenW, kHEIGHT);
    [bgView.attentionButton addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    [_tableView addSubview:bgView];
    _topView = bgView;
    
    
    [_tableView setContentOffset:CGPointMake(0, -kHEIGHT) animated:NO];
    _tableView.bouncesZoom = NO;
    
//    __weak typeof(self)weakSelf = self;
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _page = 1;
//        [weakSelf loadDataWithPage:_page];
//        _isRefresh = YES;
//    }];
    
    [self setupTopView];
}

-(void)setupTopView
{
    UIView *topView = [[UIView alloc]initWithFrame:kRectMake(0, 0, kScreenW, kNavigationBarHeight)];
    [self.view addSubview:topView];
    topView.alpha = 0;
    topView.backgroundColor = [UIColor colorWithRed:0.11 green:0.65 blue:0.90 alpha:1.00];
    _naviBar  =topView;

    
    if (_type) {
        self.titleWithNoNavgationBar = LocalizedString(@"Dis_PersonalSpace");
    }else{
        self.titleWithNoNavgationBar = LocalizedString(@"Dis_Mine");
    }
    
    [self.backBtn setImage:kImageFromStr(@"back_white") forState:UIControlStateNormal];
    self.backBtn.centerY  = self.titleLabel.centerY;
    self.titleLabel.textColor = kWhiteColor;
    
    UIButton * submitButton = [[UIButton alloc]initWithFrame:kRectMake(0, 0, 30, 14) title:kLocat(@"Dis_Post") titleColor:kWhiteColor font:PFRegularFont(14) titleAlignment:2];
    [self.view addSubview:submitButton];
    submitButton.centerY = self.titleLabel.centerY;
    submitButton.right = kScreenW - 13;
    [submitButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        YWCircleIssueController *vc = [[YWCircleIssueController alloc] init];
        vc.type = 1;
        kNavPush(vc);
    }];
    submitButton.hidden = _type;

}
-(void)loadUserInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"act"] = @"district";
    param[@"op"] = @"members";
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    if (_type == YWCircleSpaceControllerMine) {
        param[@"member_id"] = @(kUserInfo.uid);
    }else{
        param[@"member_id"] = _memberId;
    }
    
    param[@"uuid"] = [Utilities randomUUID];

    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kGetCircleInfo] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        if (success) {
            
            NSDictionary *dic = [responseObj ksObjectForKey:kData];
            
            _topView.dataDic = dic;
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }

    }];
 
}

-(void)loadDataWithPage:(NSInteger)page
{
    __weak typeof(self)weakSelf = self;

    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    paramDic[@"page"] = @(page);
    if (_type == YWCircleSpaceControllerMine) {
        paramDic[@"request_type"] = @"my_index";
//        paramDic[@"member_id"] = @(kUserInfo.uid);

    }else{
        paramDic[@"request_type"] = @"index";
        paramDic[@"member_id"] = _memberId;
    }
    paramDic[@"token_id"] = @(kUserInfo.uid);

    paramDic[@"key"] = kUserInfo.token;
    paramDic[@"act"] = @"district";
    paramDic[@"op"] = @"read";

    paramDic[@"sign"] = [Utilities handleParamsWithDic:paramDic];
    paramDic[@"uuid"] = [Utilities randomUUID];
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kGetDistrictList] andParam:paramDic completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
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
                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    if (!_isRefresh) {
                        _page ++;
                        [weakSelf loadDataWithPage:_page];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"YWCircleSpaceListCell";
    YWCircleSpaceListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    cell.delegate = self;
    cell.model = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }else{
        cell.topLine.hidden = NO;
    }
    if (indexPath.row == self.dataArray.count - 1) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    cell.tag = indexPath.row;
    cell.deleteButton.tag = indexPath.row;
    cell.showMoreButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.likeButton addTarget:self action:@selector(favourAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.likeButton.tag = indexPath.row;
    cell.commentButton.tag = indexPath.row;
    [cell.commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.showMoreButton addTarget:self action:@selector(showMoreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.deleteButton.hidden = _type;

    
    
    return cell;
}


#pragma mark - 点击事件
//手动删除
-(void)deleteAction:(UIButton *)button
{
    JSYCommonAlertView *alerView = kCommonAlertView;
    alerView.delegate = self;
    [alerView showAlertViewWithCancelButtonTitle:kLocat(@"C_Tip") messsage:kLocat(@"C_TipDetail")];
    self.toDeleteModel = self.dataArray[button.tag];
}
//确认删除.
-(void)didClickConfirmButton
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"act"] = @"district";
    param[@"op"] = @"district_remove";
    param[@"district_id"] = self.toDeleteModel.district_id;
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"uuid"] = [Utilities randomUUID];
    kShowHud;
    __weak typeof(self)weakSelf = self;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kDeleteDistrict] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kShowHud;
        if (success) {
            
            [self showTips:kLocat(@"C_DeleteSuccess")];
            //            NSUInteger index = [weakSelf.dataArray indexOfObject:weakSelf.toDeleteModel];
            [weakSelf.dataArray removeObject:weakSelf.toDeleteModel];
            //            [weakSelf.tableView deleteRow:index inSection:0 withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.tableView reloadData];
            weakSelf.toDeleteModel = nil;
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}
//点赞
-(void)favourAction:(UIButton *)button
{
    if ([Utilities isExpired]) {
        [self showTips:kLocat(@"Tips_Login")];
        [self gotoLoginVC];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"district_id"] = self.dataArray[button.tag].district_id;
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
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}
-(void)commentAction:(UIButton *)button
{
    if (_isShowKeyBoard) {
        [self.view endEditing:YES];
        _isShowKeyBoard =NO;
        return;
    }
    _isReply = NO;
    self.chatKeyBoard.placeHolder = kLocat(@"Dis_SaySomeThing");
    [self.chatKeyBoard keyboardUpforComment];
    _isShowKeyBoard = YES;
    
    YWDynamicModel *model = self.dataArray[button.tag];
    _selectedModel = model;
    
}
-(void)chatKeyBoardSendText:(NSString *)text
{
    [self.chatKeyBoard keyboardDownForComment];
    
    if ([Utilities isExpired]) {
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
            [commentsArr insertObject:[responseObj ksObjectForKey:kData] atIndex:0];
            weakSelf.dataArray[index].comment = commentsArr.mutableCopy;
            weakSelf.dataArray[index].comment_count = [NSString stringWithFormat:@"%zd",commentsArr.count];
            
            //            [weakSelf.commentArray insertObject:[responseObj ksObjectForKey:kData] atIndex:0];
            //            weakSelf.model.comment = weakSelf.commentArray.mutableCopy;
            //            weakSelf.model.comment_count = [NSString stringWithFormat:@"%zd",weakSelf.model.comment.count];
            [weakSelf.tableView reloadRow:index inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}
-(void)showMoreButtonAction:(UIButton *)button
{
    YWCircleCommentController *vc = [[YWCircleCommentController alloc]init];
    vc.model = self.dataArray[button.tag];
    vc.toScroll = YES;
    kNavPush(vc);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YWCircleCommentController *vc = [[YWCircleCommentController alloc]init];
    vc.model = self.dataArray[indexPath.row];
    kNavPush(vc);
}
#pragma mark - 点击评论的代理事件
-(void)comment:(UIView *)commentLabel userDidClickYWCircleSpaceListCellCommentWithInfo:(NSDictionary *)dic
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
        
        [self.chatKeyBoard keyboardUpforComment];
        self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"%@%@: ",kLocat(@"C_reply"),dic[@"username"]];
        _isShowKeyBoard = YES;
        _replyInfo = dic;
    }
}
//关注事件
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
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"member_id"] = _memberId;
    param[@"key"] = kUserInfo.token;
    param[@"act"] = @"district";
    param[@"op"] = @"follows";
    param[@"uuid"] = [Utilities randomUUID];
//    __weak typeof(self)weakSelf = self;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kFollowAction] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        
        if (success) {
            button.selected = !button.selected;
            
            
        }else{
            
        }

    }];

}

#pragma mark - 删除评论
-(void)showDeleteAlertViewWithId:(NSString *)commentId index:(NSInteger)index commentIndex:(NSInteger)commetIndex
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除该评论" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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



#pragma mark - 行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YWDynamicModel *model = self.dataArray[indexPath.row];
    CGFloat DistrictViewWith = kScreenW - 91 - 22;
    
    CGFloat rowHeight = 0;
    //文字
    if (model.content == nil || [model.content isEqualToString:@""]) {
        rowHeight = 0;
    }else{
        
       CGSize contentSize = [Utilities getSpaceLabelHeight:model.content withFont:PFRegularFont(14) withWidth:DistrictViewWith lineSpace:UILABEL_LINE_SPACE];
        
        rowHeight = 12 + contentSize.height;
    }
    
    if ([model.attachments_type isEqualToString:@"video"]) {
        
        rowHeight += 19 + OnePicWidth;
        
    }else{
        //图片
        CGFloat margin = 5;
        CGFloat picW = (DistrictViewWith - margin * 2.0) / 3;
        
        if (model.attachments.count == 0 ) {
            rowHeight += 0;
        }else if (model.attachments.count == 1){
            rowHeight += (19 + OnePicWidth);
        }else if (model.attachments.count < 4){
            rowHeight += (19 + picW);
        }else if (model.attachments.count < 7){
            rowHeight += (19 + picW * 2 + 2 * margin);
        }else{
            rowHeight += (19 + DistrictViewWith);
        }
    }
    
    //商品
    if (model.goods_url.length > 4) {
        rowHeight += 10 + 60;
    }
    
    //圈子
    rowHeight += 10;
    
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

    //底部按钮
    rowHeight += (15 + 10 + 20 + 20);
    
    return rowHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (point.y < -kHEIGHT) {
        CGRect rect = [self.tableView viewWithTag:101].frame;
        rect.origin.y = point.y;
        rect.size.height = -point.y;
        [self.tableView viewWithTag:101].frame = rect;
    }
    if (scrollView.contentOffset.y > -53) {
        _naviBar.alpha = 1;
    }else{
        _naviBar.alpha = 0;
    }
    
    [self.chatKeyBoard keyboardDownForComment];
    _isShowKeyBoard = NO;
    
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




@end
