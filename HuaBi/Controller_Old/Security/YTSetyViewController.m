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

@end

@implementation YTSetyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_YTsetViewController_s1_title");
    self.view.backgroundColor = kRGBA(244, 244, 244, 1);
    [self.tableview registerNib:[UINib nibWithNibName:@"secutityTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([secutityTableViewCell class])];
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
    NSArray *imgs = @[@"acc_pwd",@"acc_email",@"acc_tele",@"log_pwd"];
    NSArray *titles = @[kLocat(@"k_YTsetViewController_s1"),kLocat(@"k_YTsetViewController_s2"),kLocat(@"k_YTsetViewController_s3"),kLocat(@"k_YTsetViewController_s4")];
    NSArray *detailtitles = @[kLocat(@"k_YTsetViewController_s1_det"),kLocat(@"k_YTsetViewController_s2_det"),kLocat(@"k_YTsetViewController_s3_det"),kLocat(@"k_YTsetViewController_s4_det")];
    NSArray *bTitles = @[kLocat(@"k_YTsetViewController_bt1"),kLocat(@"k_YTsetViewController_bt2"),kLocat(@"k_YTsetViewController_bt3"),kLocat(@"k_YTsetViewController_bt4")];
    cell.img.image = [UIImage imageNamed:imgs[indexPath.section]];
    cell.titleLabel.text = [titles objectAtIndex:indexPath.section];
    cell.detailLabel.text = [detailtitles objectAtIndex:indexPath.section];
    [cell.modifyBtn setTitle:[bTitles objectAtIndex:indexPath.section] forState:UIControlStateNormal];
    
    cell.detail = ^{
        if (indexPath.section == 0) {
            kNavPush([ModifyPwdViewController new]);
        }else if (indexPath.section == 1){
            kNavPush([BindMailViewController new]);
        }else if (indexPath.section == 2){
            kNavPush([BindTeleViewController new]);
        }else{
            kNavPush([ModifyLoginPWDViewController new]);
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        kNavPush([ModifyPwdViewController new]);
    }else if (indexPath.section == 1){
        kNavPush([BindMailViewController new]);
    }else if (indexPath.section == 2){
        kNavPush([BindTeleViewController new]);
    }else{
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
