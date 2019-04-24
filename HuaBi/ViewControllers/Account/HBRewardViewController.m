//
//  HBRewardViewController.m
//  HuaBi
//
//  Created by XI YANGUI on 2018/10/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBRewardViewController.h"
#import "MemberHeaderTableViewCell.h"
#import "MyRecommendViewController.h"
#import "MymineViewController.h"
#import "MymineViewController.h"
#import "MyBonusViewController.h"
#import "MyInviteViewController.h"
#import "HBTeamViewController.h"
#import "HBReceiveAwardListViewController.h"
#import "YWAlert.h"

@interface HBRewardViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)MemberHeaderTableViewCell *header;
@end


@implementation HBRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"HBRewardViewController_header");
    self.tableview.separatorColor = kThemeBGColor;
    self.tableview.backgroundColor = kThemeBGColor;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"s1"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"s2"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"s3"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"s3_1"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"s4"];
    self.tableview.tableFooterView = [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s1"];
        cell.backgroundColor = kColorFromStr(@"#0B132A");
        cell.textLabel.textColor = kColorFromStr(@"#DEE5FF");
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = kLocat(@"HBRewardViewController_s1");
        return cell;
        
    }
    else if(indexPath.row ==1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s2"];
        cell.backgroundColor = kColorFromStr(@"#0B132A");
        cell.textLabel.textColor = kColorFromStr(@"#DEE5FF");
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = kLocat(@"Receive award");
        
        return cell;
    }
    else if(indexPath.row ==2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s2"];
        cell.backgroundColor = kColorFromStr(@"#0B132A");
        cell.textLabel.textColor = kColorFromStr(@"#DEE5FF");
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = kLocat(@"HBRewardViewController_s2");

        return cell;
    }else if(indexPath.row ==3){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s3"];
        cell.backgroundColor = kColorFromStr(@"#0B132A");
        cell.textLabel.textColor = kColorFromStr(@"#DEE5FF");
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = kLocat(@"HBRewardViewController_s3");
        return cell;
    }else if(indexPath.row ==4){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s3_1"];
        cell.backgroundColor = kColorFromStr(@"#0B132A");
        cell.textLabel.textColor = kColorFromStr(@"#DEE5FF");
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = kLocat(@"HBRewardViewController_s3_1");
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s4"];
        cell.backgroundColor = kColorFromStr(@"#0B132A");
        cell.textLabel.textColor = kColorFromStr(@"#DEE5FF");
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = kLocat(@"HBRewardViewController_s4");
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        kNavPush([MyRecommendViewController new]);
    }
    else if(indexPath.row ==1){
        
        
        
        if ([Utilities getAuthStatus] == AuthenticationTypeAuthented) {
            kNavPush([HBReceiveAwardListViewController new]);
        } else {
            [YWAlert alertSorryWithMessage:kLocat(@"Receive award unverified tips") inViewController:self];
        }
        
    }
    else if(indexPath.row ==2){
        MymineViewController *vc = [MymineViewController new];
        vc.title = cell.textLabel.text;
        vc.type = @"62";//交易
        kNavPush(vc);
    }else if(indexPath.row ==3){
        MymineViewController *vc = [MymineViewController new];
        vc.title = cell.textLabel.text;
        vc.type = @"64";//分红
        kNavPush(vc);
    }else if(indexPath.row ==4){
        MymineViewController *vc = [MymineViewController new];
        vc.title = cell.textLabel.text;
        vc.type = @"63";//团队
        kNavPush(vc);
    }
    else{
        kNavPush([MyInviteViewController new]);
    }
}

@end
