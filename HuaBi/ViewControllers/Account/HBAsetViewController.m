//
//  HBAsetViewController.m
//  HuaBi
//
//  Created by XI YANGUI on 2018/10/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBAsetViewController.h"
#import "MemberHeaderTableViewCell.h"
#import "MyAssetsViewController.h"
#import "FlogViewController.h"
@interface HBAsetViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)MemberHeaderTableViewCell *header;

@end

@implementation HBAsetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"HBAsetViewController_header");
    self.tableview.separatorColor = kRGBA(24, 30, 50, 1);
    MemberHeaderTableViewCell *head =  [[[NSBundle mainBundle] loadNibNamed:@"MemberHeaderTableViewCell" owner:nil options:nil] lastObject];
    head.userInteractionEnabled = YES;
    head.baseInfoLabl.text = kLocat(@"HBAsetViewController_header");
    head.backgroundColor = kColorFromStr(@"#0B132A");
    self.header = head;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"asset"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"note"];
    self.tableview.tableHeaderView = self.header;
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"asset"];
        cell.backgroundColor = kColorFromStr(@"#0B132A");
        cell.textLabel.textColor = kColorFromStr(@"#DEE5FF");
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = kLocat(@"HBAsetViewController_s1");
        return cell;
//    }else{
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"note"];
//        cell.backgroundColor = kColorFromStr(@"#0B132A");
//        cell.textLabel.textColor = kColorFromStr(@"#DEE5FF");
//        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.textLabel.text = kLocat(@"HBAsetViewController_s2");
//
//        return cell;
//    }
    
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
//    if (indexPath.row == 0) {
        kNavPush([MyAssetsViewController new]);
//    }else{
//        kNavPush([FlogViewController new]);
//    }
}

@end
