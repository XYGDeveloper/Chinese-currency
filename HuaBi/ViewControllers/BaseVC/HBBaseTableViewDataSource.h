//
//  HBBaseTableViewDataSource.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HBBaseTableViewDataSourceCellConfigureBlock)(id cell, id model);


@interface HBBaseTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSArray *items;

- (instancetype)initWithItems:(NSArray *)anItems
               cellIdentifier:(NSString *)aCellIdentifier
           cellConfigureBlock:(HBBaseTableViewDataSourceCellConfigureBlock)aCellConfigureBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
