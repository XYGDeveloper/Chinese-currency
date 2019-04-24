//
//  RlistViewController.m
//  YJOTC
//
//  Created by l on 2018/9/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "RlistViewController.h"
#import "RListTableViewCell.h"
@interface RlistViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSString *type;
@end

@implementation RlistViewController

- (instancetype)initWithType:(NSString *)type{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资产";
    [self layOutsubviews];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark- layoutSubviews

- (void)layOutsubviews{
    self.tableview.backgroundColor = kRGBA(244, 244, 244, 1);
    self.view.backgroundColor = kRGBA(244, 244, 244, 1);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"RListTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([RListTableViewCell class])];
 
}


#pragma mark- actions

#pragma mark- tableviewDelegateAndDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RListTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/**
 <#Description#>
 
 @param tableView <#tableView description#>
 @param indexPath <#indexPath description#>
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
