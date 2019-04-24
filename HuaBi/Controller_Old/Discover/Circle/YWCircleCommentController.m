//
//  YWCircleCommentController.m
//  ywshop
//
//  Created by 周勇 on 2017/11/1.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWCircleCommentController.h"
#import "YWCircleDetailCommentCell.h"
#import "YWCircleDetailTopCell.h"
//#import "YWCircleReportController.h"
#import "ChatKeyBoard.h"
#import "ChatToolBarItem.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "YWCircleSpaceController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface YWCircleCommentController ()<ChatKeyBoardDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;

@property(nonatomic,strong)NSMutableArray *commentArray;

@property(nonatomic,assign)BOOL isShowKeyBoard;
@property(nonatomic,assign)BOOL isReply;
@property(nonatomic,strong)NSDictionary *replyInfo;

@end

@implementation YWCircleCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self changeStatusBarColorWithWhite:NO];
}
-(void)setupUI
{
    _commentArray = [NSMutableArray array];
//    _commentArray = [NSMutableArray arrayWithCapacity:_model.comment.count];
//    for (NSDictionary *dic in _model.comment) {
//        [_commentArray addObject:dic];
//    }
   
    self.title = kLocat(@"Dis_Comments");
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = NO;
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kTabbarItemHeight - kNavigationBarHeight) style:UITableViewStyleGrouped];

    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];

//    _tableView.contentInset = UIEdgeInsetsZero;
    
    [_tableView registerNib:[UINib nibWithNibName:@"YWCircleDetailCommentCell" bundle:nil] forCellReuseIdentifier:@"YWCircleDetailCommentCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"YWCircleDetailTopCell" bundle:nil] forCellReuseIdentifier:@"YWCircleDetailTopCell"];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
    }
    
    self.chatKeyBoard = [ChatKeyBoard keyBoard];
    self.chatKeyBoard.delegate = self;
    self.chatKeyBoard.keyBoardStyle = KeyBoardStyleChat;
    [self.view addSubview:self.chatKeyBoard];
    self.chatKeyBoard.allowSwitchBar = NO;
    self.chatKeyBoard.allowVoice = NO;
    self.chatKeyBoard.allowFace = NO;
    self.chatKeyBoard.allowMore = NO;
    self.chatKeyBoard.placeHolder = kLocat(@"Dis_SaySomeThing");
    self.chatKeyBoard.backgroundColor = kBGColor;
    
}


-(void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"act"] = @"";
//    param[@"op"] = @"";
    param[@"request_type"] = @"list";
    param[@"district_id"] = _model.district_id;
    param[@"page_size"] = @(100);
    
    param[@"uuid"] = [Utilities randomUUID];

    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kCommentList] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        if (success) {
            for (NSDictionary *dic in [responseObj ksObjectForKey:kData]) {
                [self.commentArray addObject:dic];
            }
            [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.commentArray.count;
//        return _commentArray.count == 0?1:_commentArray.count;
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.section == 0) {
        static NSString *rid = @"YWCircleDetailTopCell";
        YWCircleDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.model = _model;
        [cell.avatar addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUserInfoByTopView)]];
        [cell.commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.likeButton addTarget:self action:@selector(favourAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.attentionButton addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
//        [cell.reportButton addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];

        if ([_model.attachments_type isEqualToString:@"video"]) {
            
            UIImageView *videoImgView = cell.picView.subviews.firstObject;
            videoImgView.userInteractionEnabled = YES;
            [videoImgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVideoAction)]];
        }

        
        
        return cell;
    }else{
//        if (_commentArray.count == 0) {
//            UITableViewCell *cell = [UITableViewCell new];
//            cell.selectionStyle = 0;
//            cell.backgroundColor = kBGColor;
//            return cell;
//        }
        
        static NSString *rid = @"YWCircleDetailCommentCell";
        YWCircleDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.avatar.tag = indexPath.row;
        [cell.avatar addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUserInfo:)]];
//        cell.dataDic = self.model.comment[indexPath.row];
        cell.dataDic = self.commentArray[indexPath.row];

        return cell;
    }
    return nil;
}





#pragma mark - 点击事件
//点击评论的头像
-(void)showUserInfo:(UITapGestureRecognizer *)tap
{
    NSInteger uid = [self.model.comment[tap.view.tag][@"member_id"] integerValue];
    YWCircleSpaceController *vc = [YWCircleSpaceController new];

    if (uid == kUserInfo.uid) {
        vc.type = YWCircleSpaceControllerMine;

    }else{
        vc.type = YWCircleSpaceControllerOther;
        vc.memberId = _model.member_id;
    }
    kNavPush(vc);
}
//点击动态的头像
-(void)showUserInfoByTopView
{
    NSInteger uid = _model.member_id.integerValue;
    YWCircleSpaceController *vc = [YWCircleSpaceController new];
    if (uid == kUserInfo.uid) {
        vc.type = YWCircleSpaceControllerMine;
    }else{
        vc.type = YWCircleSpaceControllerOther;
        vc.memberId = _model.member_id;
    }
    kNavPush(vc);
}
//点击评论按钮
-(void)commentAction:(UIButton *)button
{
    if (_isShowKeyBoard) {
        [self.view endEditing:YES];
        _isShowKeyBoard =NO;
        return;
    }
    _isReply = NO;
    self.chatKeyBoard.placeHolder = kLocat(@"Dis_SaySomeThing");
    [self.chatKeyBoard keyboardUp];
    _isShowKeyBoard = YES;
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
    param[@"district_id"] = _model.district_id;
    param[@"token_id"] = @(kUserInfo.uid);

    param[@"key"] = kUserInfo.token;
    param[@"act"] = @"district";
    param[@"op"] = @"to_like";
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
            weakSelf.model.is_like = [NSString stringWithFormat:@"%@",dic[@"is_like"]];
            
            weakSelf.model.likes = dic[@"likes"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidChangeDynamicModelLick" object:weakSelf.model];
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
    param[@"token_id"] = @(kUserInfo.uid);

    param[@"member_id"] = _model.member_id;
    param[@"key"] = kUserInfo.token;
    param[@"act"] = @"district";
    param[@"op"] = @"follows";
    param[@"uuid"] = [Utilities randomUUID];
    //    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kFollowAction] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        //        kHideHud;
        if (success) {
            button.selected = !isFans;
            
            if (isFans) {
                _model.is_follow = @"0";

            }else{
                _model.is_follow = @"1";
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidChangeDynamicModelAttention" object:_model];
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];;
        }
    }];
}

//播放视频
-(void)playVideoAction
{
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
    // 创建AVPlayer实例, 绑定URL
    
    NSString *urlStr = _model.attachments.firstObject[@"video"];
    
    AVPlayer *player = [[AVPlayer alloc] initWithURL:urlStr.ks_URL];
    // 将AVPlayer实例(能播放视频)赋值给PlayerVC(容器)
    playerVC.player = player;
    
    [player play];
    
    [self presentViewController:playerVC animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    if (_commentArray.count == 0) {
        return;
    }
    if (_isShowKeyBoard == YES) {
        [self.view endEditing:YES];
        _isShowKeyBoard = NO;
    }else{
        NSDictionary *dataDic = self.commentArray[indexPath.row];
        if ([dataDic[@"member_id"] integerValue] == kUserInfo.uid) {
            //自己发表的评论,删除
            [self showDeleteAlertViewWithId:dataDic[@"comment_id"] index:indexPath.row];
        }else{
            //回复别人
            _isReply = YES;
            self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"%@%@: ",kLocat(@"C_reply"),dataDic[@"username"]];
            [self.chatKeyBoard keyboardUp];
            
            _isShowKeyBoard = YES;
            
            _replyInfo = dataDic;
        }
    }
}
#pragma mark - 删除评论
-(void)showDeleteAlertViewWithId:(NSString *)commentId index:(NSInteger)index
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:kLocat(@"Dis_DeleteThisComment") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteCommentWithId:commentId index:index];
    }];
    [deleteAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)deleteCommentWithId:(NSString *)commentId index:(NSInteger)index
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"comment_id"] = commentId;
    param[@"act"] = @"district";
    param[@"token_id"] = @(kUserInfo.uid);

    param[@"op"] = @"district_comment_remove";
    param[@"key"] = kUserInfo.token;
    param[@"uuid"] = [Utilities randomUUID];
    __weak typeof(self)weakSelf = self;
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kDeleteComment] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        if (success) {
            [weakSelf.commentArray removeObjectAtIndex:index];
            
            weakSelf.model.comment = weakSelf.commentArray.mutableCopy;
            weakSelf.model.comment_count = [NSString stringWithFormat:@"%zd",weakSelf.model.comment.count];
            [weakSelf.tableView reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidChangeDynamicModelCommentAction" object:weakSelf.model];
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}
//点击评论发送按钮
-(void)chatKeyBoardSendText:(NSString *)text
{
    [self.chatKeyBoard keyboardDown];
    self.chatKeyBoard.placeHolder = kLocat(@"Dis_SaySomeThing");
    _isShowKeyBoard = NO;
    if ([Utilities isExpired]) {
        [self gotoLoginVC];
        return;
    }
    
    if (text.length > 140) {
        [self showTips:kLocat(@"C_NoMoreThan140")];
        return;
    }
    if (_isReply) {
        [self submitCommentWithDistrictID:_model.district_id content:text parentID:_replyInfo[@"comment_id"]];
    }else{
        [self submitCommentWithDistrictID:_model.district_id content:text parentID:@"0"];
    }
}

-(void)submitCommentWithDistrictID:(NSString *)disID content:(NSString *)content parentID:(NSString *)parentId
{
    if ([Utilities isExpired]) {
        [self showTips:kLocat(@"Tips_Login")];
        [self gotoLoginVC];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"district_id"] = disID;
    param[@"content"] = content;
    param[@"parent_id"] = parentId;
    param[@"act"] = @"district";
    param[@"op"] = @"comment_push";
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"uuid"] = [Utilities randomUUID];
    kShowHud;
    __weak typeof(self)weakSelf = self;
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kCommentAction] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        
        kHideHud;
        if (success) {
            
//            if (weakSelf.commentArray.count == 0) {
//                [weakSelf.commentArray insertObject:[responseObj ksObjectForKey:kData] atIndex:0];
//            }else{
//                [weakSelf.commentArray insertObject:[responseObj ksObjectForKey:kData] atIndex:1];
//            }
//            weakSelf.model.comment = weakSelf.commentArray.mutableCopy;
//            weakSelf.model.comment_count = [NSString stringWithFormat:@"%zd",weakSelf.model.comment.count];
            
            
            NSDictionary *dic = [responseObj ksObjectForKey:kData];
            if (self.commentArray.count == 0) {
                [self.commentArray addObject:dic];
            }else{
                
                [self.commentArray insertObject:dic atIndex:0];
            }
            weakSelf.model.comment = weakSelf.commentArray.mutableCopy;
            weakSelf.model.comment_count = [NSString stringWithFormat:@"%zd",weakSelf.commentArray.count];
            
            [weakSelf.tableView reloadData];
//            [weakSelf.tableView scrollToBottom];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidChangeDynamicModelCommentAction" object:weakSelf.model];
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

#pragma mark - cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        if (_commentArray.count == 0) {
            return 1;
        }
        
        CGFloat rowHeight = 12 + 44 - 5;
        
//        CGSize contentSize = [Utilities calculateWidthAndHeightWithWidth:kScreenW - 23-44-10-12 height:10000000 text:_model.comment[indexPath.row][@"content"] font:PFRegularFont(14)].size;
        CGSize contentSize = [Utilities calculateWidthAndHeightWithWidth:kScreenW - 23-44-10-12 height:10000000 text:self.commentArray[indexPath.row][@"content"] font:PFRegularFont(14)].size;

        
        rowHeight += contentSize.height + 20;
        return  rowHeight;
        
    }else{
        
        CGFloat rowHeight = 7 + 40;
        if (_model.content == nil || [_model.content isEqualToString:@""]) {
        }else{
            CGSize contentSize = [Utilities getSpaceLabelHeight:_model.content withFont:PFRegularFont(14) withWidth:DistrictWidth lineSpace:UILABEL_LINE_SPACE];
            rowHeight += contentSize.height + 10;
        }
        //图片
        if ([_model.attachments_type isEqualToString:@"video"]) {
            rowHeight += 15 + OnePicWidth;
        }else{
            //图片
            CGFloat margin = 5;
            CGFloat picW = (DistrictWidth - margin * 2) / 3;
            if (_model.attachments.count == 0 ) {
                rowHeight += 0;
            }else if (_model.attachments.count == 1){
                rowHeight += (16 + OnePicWidth);
            }else if (_model.attachments.count < 4){
                rowHeight += (16 + picW + margin);
            }else if (_model.attachments.count < 7){
                rowHeight += (16 + picW * 2 + 2 * margin);
            }else{
                rowHeight += (16 + DistrictWidth);
            }
        }
        //商品
        if (_model.goods_url.length > 3){
            rowHeight += 10 + 60;
        }
        
        //圈子
        rowHeight += 11;
        
        //底部按钮 + 间距
        rowHeight += 15 + 20 + 10;
        return rowHeight;
    }
}

-(void)shareAction
{
    JSYShareView *shareView = [[JSYShareView alloc]initWithFrame:kScreenBounds model:_model type:JSYShareViewTypeCircle];
    [kKeyWindow addSubview:shareView];
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else{
        return 0.01;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 44;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView *headerView = [[UIView alloc]initWithFrame:kRectMake(0, 0, kScreenW, 44)];
    headerView.backgroundColor = kWhiteColor;
    UILabel *label = [[UILabel alloc]initWithFrame:kRectMake(12, 0, 150, 18)];
    label.text = [NSString stringWithFormat:@"%@(%zd)",kLocat(@"Dis_AllComments"),self.commentArray.count];
    
    label.font = PFRegularFont(18);
    label.textColor = k323232Color;
    
    [headerView addSubview:label];
    
    [label alignVertical];
    
    UIView *line = [[UIView alloc]initWithFrame:kRectMake(0, 43.5, headerView.width, 0.5)];
    [headerView addSubview:line];
    line.backgroundColor = kColorFromStr(@"cccccc");
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _isShowKeyBoard = NO;
    [self.chatKeyBoard keyboardDown];
    self.chatKeyBoard.placeHolder = kLocat(@"Dis_SaySomeThing");

}

@end

