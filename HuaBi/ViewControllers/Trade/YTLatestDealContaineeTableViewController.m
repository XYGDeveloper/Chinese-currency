//
//  YTLatestDealContaineeTableViewController.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTLatestDealContaineeTableViewController.h"
#import "YTLatestDealContaineeCell.h"

@interface YTLatestDealContaineeTableViewController ()
@property (weak, nonatomic) IBOutlet UIView *contianerHeaderView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeNumberLabel;

@end

@implementation YTLatestDealContaineeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.tableView.
    self.contianerHeaderView.backgroundColor = kThemeColor;
    self.timeLabel.text = kLocat(@"Time");
    self.typeLabel.text = kLocat(@"Type");
    self.tradePriceLabel.text = kLocat(@"Trade_price");
    self.tradeNumberLabel.text = kLocat(@"Trade_volume");
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.models.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTLatestDealContaineeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTLatestDealContaineeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.model = self.models[indexPath.row];
    return cell;
}

#pragma mark - Setters

- (void)setModels:(NSArray<Trade_list *> *)models {
    _models = models;
    
    [self.tableView reloadData];
}


#pragma mark - Public
static CGFloat const kCellHeight = 24.;
+ (CGFloat)getHeightWithModels:(NSArray<Trade_list *> *)models {
    return models.count * kCellHeight + 24.;
}

@end
