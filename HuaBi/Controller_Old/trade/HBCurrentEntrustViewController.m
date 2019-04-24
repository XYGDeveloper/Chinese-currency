//
//  HBCurrentEntrustViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBCurrentEntrustViewController.h"
#import "HBCurrentEntrustCell.h"

@interface HBCurrentEntrustViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation HBCurrentEntrustViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupUI];
}

#pragma mark - Private

- (void)_setupUI {
    
    [self _setupTableView];
    
}

- (void)_setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"HBCurrentEntrustCell" bundle:nil] forCellReuseIdentifier:@"HBCurrentEntrustCell"];
    self.tableView.backgroundColor = kThemeBGColor;
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBCurrentEntrustCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBCurrentEntrustCell" forIndexPath:indexPath];
    
    return cell;
}

@end
