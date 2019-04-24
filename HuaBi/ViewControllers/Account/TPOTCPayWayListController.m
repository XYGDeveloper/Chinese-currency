//
//  TPOTCPayWayListController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCPayWayListController.h"
#import "TPOTCPayWayListCell.h"
#import "TPOTCPayWayNoBankAddController.h"
#import "TPOTCPayWayBankController.h"
#import "TPOTCPayWayModel.h"
#import "C2CViewController.h"
@interface TPOTCPayWayListController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray<TPOTCPayWayModel *> *dataArray;

@property(nonatomic,strong)UIView *addView;

@end

@implementation TPOTCPayWayListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorFromStr(@"#171F34");
    _dataArray = [NSMutableArray array];
    [self setupUI];
    
    [self addNavi];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self loadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_addView) {
        [_addView removeFromSuperview];
        _addView = nil;
    }
}

-(void)addNavi
{
  
    [self addLeftBarButtonWithImage:kImageFromStr(@"back_white") action:@selector(toback)];
    
    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    [rightbBarButton setTitle:kLocat(@"k_popview_select_paywechat_add") forState:(UIControlStateNormal)];
    [rightbBarButton setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    rightbBarButton.titleLabel.font = PFRegularFont(16);
    [rightbBarButton addTarget:self action:@selector(addAction) forControlEvents:(UIControlEventTouchUpInside)];
    rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth/375.0)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
}

- (void)toback{
    if (self.isNew == YES) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[C2CViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return ;
            }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)setupUI
{
    self.title = kLocat(@"OTC_main_payway");//OTC_main_payway
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,0, kScreenW, kScreenH-kNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    
    _tableView.backgroundColor = kColorFromStr(@"#171F34");
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCPayWayListCell" bundle:nil] forCellReuseIdentifier:@"TPOTCPayWayListCell"];
    __weak typeof(self)weakSelf = self;

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
}
-(void)loadData
{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = kUserInfo.user_id;
    param[@"page_size"] = @(100);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Bank/index"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        [_tableView.mj_header endRefreshing];
        NSLog(@"%@",responseObj);
        
        if (success) {
            [_dataArray removeAllObjects];
//            NSArray *datas = [responseObj ksObjectForKey:kData];

            for (NSDictionary * dic in [responseObj ksObjectForKey:kData][@"bank"]) {
               TPOTCPayWayModel *model =  [TPOTCPayWayModel modelWithJSON:dic];
                model.bankname = kYHK;
                [self.dataArray addObject:model];
            }

            for (NSDictionary * dic in [responseObj ksObjectForKey:kData][@"alipay"]) {
                TPOTCPayWayModel *model =  [TPOTCPayWayModel modelWithJSON:dic];
                model.bankname = kZFB;
                [self.dataArray addObject:model];
            }
            
            for (NSDictionary * dic in [responseObj ksObjectForKey:kData][@"wechat"]) {
                TPOTCPayWayModel *model =  [TPOTCPayWayModel modelWithJSON:dic];
                model.bankname = kWechat;
                [self.dataArray addObject:model];
            }
            
            [self.tableView reloadData];
            
            if (self.dataArray.count == 0) {
                [self showTips:kLocat(@"k_popview_list_counter_emptyData")];
            }
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
        
    }];
    
}





-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"TPOTCPayWayListCell";
    TPOTCPayWayListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    TPOTCPayWayModel *model = self.dataArray[indexPath.section];
  
//    NSDictionary *dic = self.dataArray[indexPath.section];
    if ([model.bankname isEqualToString:kZFB]) {
        cell.icon.image = kImageFromStr(@"gmxq_icon_zfb");
        cell.accountLabel.text = model.cardnum;
        cell.typeLabel.text = kLocat(@"k_popview_select_payalipay");
    }else if ([model.bankname isEqualToString:kWechat]){
        cell.icon.image = kImageFromStr(@"gmxq_icon_wx");
        cell.accountLabel.text = model.cardnum;
        cell.typeLabel.text = kLocat(@"k_popview_select_paywechat");
    }else{
        cell.icon.image = kImageFromStr(@"gmxq_icon_yhk");
        cell.accountLabel.text = model.cardnum;
        cell.typeLabel.text = kLocat(@"k_popview_select_paybank");
    }
    cell.paySwitch.on = model.status.intValue;
    cell.paySwitch.tag = indexPath.section;
    [cell.paySwitch addTarget:self action:@selector(switchPayway:) forControlEvents:UIControlEventValueChanged];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}




#pragma mark - 点击事件

-(void)addAction
{
    [UIView animateWithDuration:0.25 animations:^{
        self.addView.y = kStatusBarHeight;
        self.enablePanGesture = NO;
    }];
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPOTCPayWayNoBankAddController *vc = [TPOTCPayWayNoBankAddController new];
    TPOTCPayWayModel *model = self.dataArray[indexPath.section];
    vc.model = model;
    
    if ([model.bankname isEqualToString:kZFB]) {
        vc.type = TPOTCPayWayNoBankAddControllerTypeListZFB;
        kNavPush(vc);

    }else if ([model.bankname isEqualToString:kWechat]){
        vc.type = TPOTCPayWayNoBankAddControllerTypeListWX;
        kNavPush(vc);

    }else{
        TPOTCPayWayBankController *vc = [[TPOTCPayWayBankController alloc] init];
        vc.type = TPOTCPayWayBankControllerTypeList;
        vc.model = model;
        kNavPush(vc);
    }
}

//切换用户支付方式
-(void)switchPayway:(UISwitch *)swith
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"id"] = self.dataArray[swith.tag].pid;
    param[@"type"] = self.dataArray[swith.tag].bankname;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Bank/change"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self loadData];
        }
    }];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(UIView *)addView
{
    if (_addView == nil) {
        UIView *addView = [[UIView alloc] initWithFrame:kRectMake(0, kScreenH, kScreenW, kScreenH )];
        
        [self.navigationController.view addSubview:addView];
        
        addView.backgroundColor = kColorFromStr(@"#F4F4F4");
        kViewBorderRadius(addView, 10, 0, kRedColor);
    
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRectMake(12, 20, 200, 16) text:kLocat(@"k_popview_select_paymode") font:PFRegularFont(17) textColor:kColorFromStr(@"#434C63") textAlignment:0 adjustsFont:YES];
        [addView addSubview:titleLabel];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 50, 50)];
        [cancelButton setImage:kImageFromStr(@"gb_icon") forState:UIControlStateNormal];
        [addView addSubview:cancelButton];
        cancelButton.right = kScreenW;
        cancelButton.centerY = titleLabel.centerY;
        __weak typeof(self)weakSelf = self;

        [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
            [UIView animateWithDuration:0.25 animations:^{
                sender.superview.y = kScreenH;
                weakSelf.enablePanGesture = YES;
            }];
        }];
        
       
        UIButton *bankButton = [[UIButton alloc] initWithFrame:kRectMake(12, 50, kScreenW - 24, 55) title:kLocat(@"k_popview_select_paybank") titleColor:kColorFromStr(@"#434C63") font:PFRegularFont(16) titleAlignment:0];
        [addView addSubview:bankButton];
        bankButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, bankButton.bottom, bankButton.width, 0.5)];
        lineView.backgroundColor = kColorFromStr(@"#D6D6D6");
        [addView addSubview:lineView];
        
        
        UIButton *zfbButton = [[UIButton alloc] initWithFrame:kRectMake(12, lineView.bottom, kScreenW - 24, 55) title:kLocat(@"k_popview_select_payalipay") titleColor:kColorFromStr(@"#434C63") font:PFRegularFont(16) titleAlignment:0];
        [addView addSubview:zfbButton];
        zfbButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(12, zfbButton.bottom, zfbButton.width, 0.5)];
        lineView1.backgroundColor = kColorFromStr(@"#D6D6D6");
        [addView addSubview:lineView1];
        
      
        UIButton *wxButton = [[UIButton alloc] initWithFrame:kRectMake(12, lineView1.bottom, kScreenW - 24, 55) title:kLocat(@"k_popview_select_paywechat") titleColor:kColorFromStr(@"#434C63") font:PFRegularFont(16) titleAlignment:0];
        [addView addSubview:wxButton];
        wxButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(12, wxButton.bottom, wxButton.width, 0.5)];
        lineView2.backgroundColor = kColorFromStr(@"#D6D6D6");
        [addView addSubview:lineView2];
        
        bankButton.tag = 0;
        zfbButton.tag = 1;
        wxButton.tag = 2;
        [bankButton addTarget:self action:@selector(payWayAction:) forControlEvents:UIControlEventTouchUpInside];
        [zfbButton addTarget:self action:@selector(payWayAction:) forControlEvents:UIControlEventTouchUpInside];
        [wxButton addTarget:self action:@selector(payWayAction:) forControlEvents:UIControlEventTouchUpInside];
        _addView = addView;
    }
    return _addView;
}


-(void)payWayAction:(UIButton *)button
{
    [UIView animateWithDuration:0.25 animations:^{
        self.addView.y = kScreenH;
    }];
    
    self.enablePanGesture = YES;
    if (button.tag == 0) {
        TPOTCPayWayBankController *vc = [TPOTCPayWayBankController new];
        vc.type = TPOTCPayWayBankControllerTypeAdd;
        kNavPush(vc);
    }else if (button.tag == 1){
        TPOTCPayWayNoBankAddController *vc = [TPOTCPayWayNoBankAddController new];
        vc.type = TPOTCPayWayNoBankAddControllerTypeAddZFB;
        kNavPush(vc);
    }else{
        TPOTCPayWayNoBankAddController *vc = [TPOTCPayWayNoBankAddController new];
        vc.type = TPOTCPayWayNoBankAddControllerTypeAddWX;
        kNavPush(vc);
    }

}




@end
