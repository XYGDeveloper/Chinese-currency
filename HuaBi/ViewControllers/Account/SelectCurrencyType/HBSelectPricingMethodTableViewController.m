//
//  HBSelectCurrencyTypeTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/1/21.
//  Copyright © 2019年 前海数交平台运营. All rights reserved.
//

#import "HBSelectPricingMethodTableViewController.h"
#import "HBBaseTableViewDataSource.h"
#import "UITableViewCell+HB.h"
#import "HBPricingMethodModel.h"

@interface HBSelectPricingMethodTableViewController ()

@property (nonatomic, strong) HBBaseTableViewDataSource *tableViewDataSource;

@property (nonatomic, strong) NSArray<HBPricingMethodModel *> *currencyModels;

@end

static NSString *const kHBSelectCurrencyTypeCellIdentifier = @"HBSelectCurrencyTypeCellIdentifier";

@implementation HBSelectPricingMethodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"HBSelectCurrencyTypeTableViewController.title");
    self.currencyModels = [HBPricingMethodModel allModels];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kHBSelectCurrencyTypeCellIdentifier];
    self.tableViewDataSource = [[HBBaseTableViewDataSource alloc] initWithItems:self.currencyModels cellIdentifier:kHBSelectCurrencyTypeCellIdentifier cellConfigureBlock:^(UITableViewCell  *_Nonnull cell, HBPricingMethodModel  *_Nonnull model) {
        cell.textLabel.text = model.displayName;
        cell.textLabel.textColor = kColorFromStr(@"#DEE5FF");
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.accessoryType = model.isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        cell.tintColor = [UIColor yellowColor];
        cell.backgroundColor = kThemeColor;
        [cell _addSelectedBackgroundView];
    }];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = kThemeBGColor;
    self.tableView.backgroundColor = kThemeBGColor;
    self.tableView.dataSource = self.tableViewDataSource;
    self.tableView.tableFooterView = [UIView new];
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HBPricingMethodModel *item = [self.tableViewDataSource itemAtIndexPath:indexPath];
    item.isSelected = YES;
    [self.tableView reloadData];
    
    kNavPop;
}


@end
