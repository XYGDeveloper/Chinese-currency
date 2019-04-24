//
//  YTSetyViewController.m
//  YJOTC
//
//  Created by l on 2018/10/9.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTSetyViewController.h"
#import "secutityTableViewCell.h"
#import "BindMailViewController.h"
#import "BindTeleViewController.h"
#import "ModifyLoginPWDViewController.h"
#import "ModifyPwdViewController.h"
@interface YTSetyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *email;
@property (nonatomic,strong)NSArray *imgs;
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)NSArray *detailtitles;
@property (nonatomic,strong)NSArray *bTitles;

@end

@implementation YTSetyViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = kUserInfo.user_id;
    NSLog(@"token----%@",kUserInfo.token);
    NSLog(@"%@",param);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Account/memberinfo"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {

            self.phone = [[responseObj ksObjectForKey:kData] ksObjectForKey:@"phone"];
            self.email = [[responseObj ksObjectForKey:kData] ksObjectForKey:@"email"];
            [self.tableview reloadData];
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_YTsetViewController_s1_title");
    self.view.backgroundColor = kRGBA(24, 30, 50, 1);
    [self.tableview registerNib:[UINib nibWithNibName:@"secutityTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([secutityTableViewCell class])];
    self.imgs = @[@"jymm_icon",@"bdyx_icon",@"bdsj_icon",@"dlmm_icon"];
    self.titles = @[kLocat(@"k_YTsetViewController_s1"),kLocat(@"k_YTsetViewController_s2"),kLocat(@"k_YTsetViewController_s3"),kLocat(@"k_YTsetViewController_s4")];
    self.detailtitles = @[kLocat(@"k_YTsetViewController_s1_det"),kLocat(@"k_YTsetViewController_s2_det"),kLocat(@"k_YTsetViewController_s3_det"),kLocat(@"k_YTsetViewController_s4_det")];
    self.bTitles = @[kLocat(@"k_YTsetViewController_bt1"),kLocat(@"k_YTsetViewController_bt2"),kLocat(@"k_YTsetViewController_bt3"),kLocat(@"k_YTsetViewController_bt4")];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    secutityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([secutityTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    cell.img.image = [UIImage imageNamed:self.imgs[indexPath.section]];
    cell.titleLabel.text = [self.titles objectAtIndex:indexPath.section];
    cell.detailLabel.text = [self.detailtitles objectAtIndex:indexPath.section];
    
    if (indexPath.section == 1) {
        BOOL isBinded = (self.email.length > 0);
        NSString *buttonTitle = isBinded ? kLocat(@"k_Bined") : kLocat(@"k_YTsetViewController_bt2");
        CGFloat alpha = isBinded ? 0.5 : 1.0;
        [cell.modifyBtn setTitle:buttonTitle forState:UIControlStateNormal];
        cell.modifyBtn.alpha = alpha;
    } else if (indexPath.section == 2) {
        BOOL isBinded = (self.phone.length > 0);
        NSString *buttonTitle = isBinded ? kLocat(@"k_Bined") : kLocat(@"k_YTsetViewController_bt3");
        CGFloat alpha = isBinded ? 0.5 : 1.0;
        [cell.modifyBtn setTitle:buttonTitle forState:UIControlStateNormal];
        cell.modifyBtn.alpha = alpha;
    } else {
        [cell.modifyBtn setTitle:[self.bTitles objectAtIndex:indexPath.section] forState:UIControlStateNormal];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        kNavPush([ModifyPwdViewController new]);
    }else if (indexPath.section == 1){
        BindMailViewController *mail = [BindMailViewController new];
        if (self.email.length <= 0) {
            mail.isBind = NO;
        }else{
            mail.isBind = YES;
            mail.mail = self.email;
        }
        kNavPush(mail);
    }
    else if (indexPath.section == 2){
        BindTeleViewController *phone = [BindTeleViewController new];
        if (self.phone.length <= 0) {
            phone.isBind = NO;
        }else{
            phone.isBind = YES;
            phone.telepphone = self.phone;
        }
        kNavPush(phone);
    }
    else{
        kNavPush([ModifyLoginPWDViewController new]);
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
        return 10;
    }else{
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
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

@end
