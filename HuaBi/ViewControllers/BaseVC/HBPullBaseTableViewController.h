//
//  HBPullBaseTableViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/18.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class HBBaseTableViewDataSource;
@interface HBPullBaseTableViewController : YJBaseViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) HBBaseTableViewDataSource *tableViewDataSource;
@property (nonatomic, assign) NSInteger pageSize;


- (void)registerNibCellWithClassName:(NSString *)className;

 //Subclass Override

- (void)requestDataWithPage:(NSInteger)page
                   pageSize:(NSInteger)pageSize
                    success:(void(^)(NSArray *array, YWNetworkResultModel *obj))success
                    failure:(void(^)(NSError *error))failure;

- (NSString *)cellIdentifier;

- (void)configureCell:(id)cell model:(id)model;

// Public

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
