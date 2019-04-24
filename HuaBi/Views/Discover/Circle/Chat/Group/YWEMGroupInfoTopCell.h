//
//  YWEMGroupInfoTopCell.h
//  ywshop
//
//  Created by 周勇 on 2017/12/8.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWEMFriendModel.h"

@protocol YWEMGroupInfoTopCellDelegate <NSObject>
@optional

- (void)didClickCollectionCell:(NSInteger)index;


@end

@interface YWEMGroupInfoTopCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)NSArray<YWEMFriendModel *> *dataArray;

@property(nonatomic,strong)UICollectionView *collectView;

@property(nonatomic,weak)id<YWEMGroupInfoTopCellDelegate> delegate;

/**  刷新collectionView  */
-(void)reloadDataWith:(NSArray *)dataArray isOwner:(BOOL)isOwner;


@end
