//
//  HBHelpCenterViewController.m
//  HuaBi
//
//  Created by l on 2018/10/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBHelpCenterViewController.h"
#import "HBHelpCenterHeaderTableViewCell.h"
#import "HBHelpCenterTableViewCell.h"
#import "HBCommonQuestionViewController.h"
#import "HBAboutUsViewController.h"
#import "HBNoticeViewController.h"

typedef NS_ENUM(NSInteger, CellType) {
    CellTypeOperationGuide = 0,
    CellTypeQAndA,
    CellTypeAboutUs,
    CellTypeNotice,
    CellTypeVersion,
};

@interface HBHelpCenterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSArray<NSString *> *titles;

@end

@implementation HBHelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_HBHelpCenteriewController_title");
    [self.tableview registerNib:[UINib nibWithNibName:@"HBHelpCenterTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([HBHelpCenterTableViewCell class])];
    self.tableview.backgroundColor = kThemeBGColor;
    self.tableview.tableFooterView = [UIView new];
    self.titles = @[kLocat(@"Operation guide"),
                    kLocat(@"k_HBHelpCenteriewController_normal"),
                    kLocat(@"k_HBHelpCenteriewController_about"),
                    kLocat(@"k_HBHelpCenteriewController_notice"),
                    kLocat(@"k_HBHelpCenteriewController_version"),];
}

- (void)loadData{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HBHelpCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HBHelpCenterTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.label.text = [self.titles objectAtIndex:indexPath.row];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    if (indexPath.row == CellTypeVersion) {
        NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        cell.deslabel.text = appCurVersion;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case CellTypeOperationGuide: {
            HBCommonQuestionViewController *vc = [HBCommonQuestionViewController new];
            vc.title = self.titles[indexPath.row];
            vc.judge = 170;
            kNavPush(vc);
        }
            break;
            
        case CellTypeQAndA: {
            HBCommonQuestionViewController *vc = [HBCommonQuestionViewController new];
            vc.title = self.titles[indexPath.row];
            vc.judge = 179;
            kNavPush(vc);
        }
            break;
        case CellTypeAboutUs:
            kNavPush([HBAboutUsViewController new]);
            break;
        case CellTypeNotice:
            kNavPush([HBNoticeViewController new]);
            break;
    }

    
}



@end
