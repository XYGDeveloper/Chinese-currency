//
//  QuotationListViewController.m
//  YJOTC
//
//  Created by l on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "QuotationListViewController.h"
#import "QuotationableViewCell.h"
#import "EmptyManager.h"
#import "YTData_listModel.h"
#import "TPCurrencyInfoController.h"
#import "YTData_listModel+Request.h"
#import "HBQuotationableMenuCell.h"
#import "HBQuotationListHeaderView.h"

@interface QuotationListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *infoList;

@property (nonatomic, assign) BOOL isNeedReloadData;

@end

@implementation QuotationListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.tableview reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (NSMutableArray *)infoList{
    if (!_infoList) {
        _infoList = [NSMutableArray array];
    }
    return _infoList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"QuotationableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([QuotationableViewCell class])];
     [self.tableview registerNib:[UINib nibWithNibName:@"HBQuotationableMenuCell" bundle:nil] forCellReuseIdentifier:@"HBQuotationableMenuCell"];
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.separatorColor = kRGBA(24, 30, 50, 1);
    self.tableview.backgroundColor = kThemeBGColor;
    [self.tableview reloadData];
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
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListModel *model = [self.list objectAtIndex:indexPath.row];
    if (!self.isTypeOfMenu) {
        QuotationableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuotationableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        UIView *emptyview = [[UIView alloc]init];
//        emptyview.frame = CGRectMake(0, 0, 20, 20);
//        cell.accessoryView = emptyview;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = kColorFromStr(@"#0B132A");
        //    NSLog(@"---------%@",model.mj_keyValues);
        [cell refreshWithModel:model currencyName:self.tag];
        return cell;
    } else {
        HBQuotationableMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBQuotationableMenuCell"];
        cell.model = model;
        return cell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    }else{
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isTypeOfMenu) {
        return nil;
    }
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    ListModel *model = [self.list objectAtIndex:indexPath.row];
    kHideHud;
    
    if (self.didSelectCellBlock) {
        self.didSelectCellBlock(model);
        return;
    }
    TPCurrencyInfoController *info = [TPCurrencyInfoController new];
    model.trade_currency_mark = self.tag;
    info.model = model;
    if (self.navigationController) {
        kNavPush(info);
    } else {
        [kKeyWindow.visibleViewController.navigationController pushViewController:info animated:YES];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isNeedReloadData) {
        self.isNeedReloadData = NO;
        [self.tableview reloadData];
    }
}

#pragma mark - Setters

- (void)setList:(NSArray *)list {
    _list = list;
    if (self.tableview.isDragging || self.tableview.isDecelerating) {
        self.isNeedReloadData = YES;
        return;
    }
    [self.tableview reloadData];
    
}

@end
