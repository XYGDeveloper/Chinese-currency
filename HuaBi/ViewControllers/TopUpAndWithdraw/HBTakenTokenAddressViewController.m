//
//  HBTakenTokenAddressViewController.m
//  HuaBi
//
//  Created by l on 2019/2/22.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBTakenTokenAddressViewController.h"
#import "HBAddressListTableViewCell.h"
#import "HBAddressModel.h"
#import "HBGetAddressApi.h"
#import "HBAddressHeaderTableViewCell.h"
#import "HBAddAddressViewController.h"
#import "CommonAlert.h"
@interface HBTakenTokenAddressViewController ()<ApiRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)HBGetAddressApi *api;
@property (nonatomic,strong)NSMutableArray *addresslist;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation HBTakenTokenAddressViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableview.mj_header beginRefreshing];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"HBTokenWithdrawViewController_address");
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    header.backgroundColor = kColorFromStr(@"171F34");
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(13, 5, kScreenW - 13, 50)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:17.0f];
    label.textColor = [UIColor whiteColor];
    [header addSubview:label];
    label.text = [NSString stringWithFormat:@"%@%@",self.currencyName,kLocat(@"HBTokenWithdrawViewController_singleaddress")];
    self.tableview.tableHeaderView = header;
    [self.tableview registerNib:[UINib nibWithNibName:@"HBAddressListTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([HBAddressListTableViewCell class])];
    [self.addButton setTitle:kLocat(@"HBTokenWithdrawViewController_add_address") forState:UIControlStateNormal];
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
    //    initWithLanage:lang token:kUserInfo.token token_id:kUserInfo.user_id
    self.api  = [[HBGetAddressApi alloc]initWithLanage:lang token:kUserInfo.token token_id:kUserInfo.user_id currency_id:self.currency_id];
    self.api.delegate = self;
    __weak typeof(self) wself = self;
    self.tableview.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        kShowHud;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addresslist.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HBAddressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HBAddressListTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HBAddressModel *model = [self.addresslist objectAtIndex:indexPath.row];
    [cell refreshWithModel:model];
    
    cell.defau = ^(UIButton * _Nonnull sender) {
        //
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"currency_id"] = model.currency_id;
        param[@"name"] = model.name;
        param[@"address"] = model.qianbao_url;
        param[@"is_default"] = [NSString stringWithFormat:@"%d",sender.selected];
        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/add_qianbao_address"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
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
                self.api  = [[HBGetAddressApi alloc]initWithLanage:lang token:kUserInfo.token token_id:kUserInfo.user_id currency_id:self.currency_id];
                self.api.delegate = self;
                [self.api refresh];
            }else{
                [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    };
    
    cell.editor = ^(UIButton * _Nonnull sender) {
        //
        HBAddAddressViewController *add = [HBAddAddressViewController new];
        add.currencyid = self.currency_id;
        add.currencyName =self.currencyName;
        add.model = model;
        add.type = @"1";
        kNavPush(add);
    };
    
    cell.delet = ^(UIButton * _Nonnull sender) {
        //
        [CommonAlert AlertWith:kLocat(@"HBTokenWithdrawViewController_address_alert_title") detail:[NSString stringWithFormat:@"%@%@",kLocat(@"HBTokenWithdrawViewController_singleaddress"),model.qianbao_url] buttonTextLabel:kLocat(@"Confirm") controller:self sureAction:^{
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"key"] = kUserInfo.token;
            param[@"token_id"] = @(kUserInfo.uid);
            param[@"currency_id"] = model.currency_id;
            param[@"id"] = model.id;
            kShowHud;
            [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/del_address"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
                kHideHud;
                if (success) {
                    NSLog(@"删除成功");
                    //
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
                    self.api  = [[HBGetAddressApi alloc]initWithLanage:lang token:kUserInfo.token token_id:kUserInfo.user_id currency_id:self.currency_id];
                    self.api.delegate = self;
                    [self.api refresh];
                }else{
                    [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
                }
            }];
        } cancelEvent:^{
            
        }];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
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



- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    //    [self showTips:command.response.msg];
    kHideHud;
    [self.tableview.mj_footer resetNoMoreData];
    [self.tableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    self.addresslist  = [NSMutableArray array];
    [self.addresslist removeAllObjects];
    NSArray *array = (NSArray *)responsObject;
    NSLog(@"--------------%@",array);
    if (array.count <= 0) {
//        [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"empty"] explain:kLocat(@"empty_msg") operationText:@"" operationBlock:^{
//            [self.tableview.mj_header beginRefreshing];
//        }];
        [self.tableview reloadData];
    } else {
        [self.addresslist removeAllObjects];
        [self.addresslist addObjectsFromArray:array];
    }
    
    [self.tableview reloadData];

}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    
    [self.tableview.mj_header endRefreshing];
    kHideHud;
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    
    [self.tableview reloadData];

}


- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self showTips:command.response.msg];
    kHideHud;
    [self.tableview.mj_footer endRefreshing];
    [self.addresslist addObjectsFromArray:responsObject];
    [self.tableview reloadData];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.tableview.mj_footer endRefreshing];
    kHideHud;
    [self showTips:command.response.msg];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    kHideHud;
    [self.tableview.mj_footer endRefreshingWithNoMoreData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HBAddressModel *model = [self.addresslist objectAtIndex:indexPath.row];
    if (self.address) {
        self.address(model);
    }
    kNavPop;
}


- (IBAction)addAction:(id)sender {
    HBAddAddressViewController *add = [HBAddAddressViewController new];
    add.currencyid = self.currency_id;
    add.currencyName =self.currencyName;
    add.type = @"0";
    kNavPush(add);
}

@end
