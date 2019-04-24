//
//  HBBaseTableViewDataSource.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBBaseTableViewDataSource.h"

@interface HBBaseTableViewDataSource ()

@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) HBBaseTableViewDataSourceCellConfigureBlock cellConfigureBlock;

@end

@implementation HBBaseTableViewDataSource

- (instancetype)initWithItems:(NSArray *)anItems
               cellIdentifier:(NSString *)aCellIdentifier
           cellConfigureBlock:(HBBaseTableViewDataSourceCellConfigureBlock)aCellConfigureBlock {
    
    self = [super init];
    if (self) {
        self.items = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.cellConfigureBlock = aCellConfigureBlock;
    }
    
    return self;
}

#pragma mark - Public

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.items.count) {
        return self.items[indexPath.row];
    }
    
    return nil;
}

#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    if (self.cellConfigureBlock) {
        id item = [self itemAtIndexPath:indexPath];
        self.cellConfigureBlock(cell, item);
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

@end
