//
//  YWCircleSpaceListCell.h
//  ywshop
//
//  Created by 周勇 on 2017/11/6.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YWCircleListCellDeleagte <NSObject>

-(void)comment:(UIView *)commentLabel userDidClickYWCircleSpaceListCellCommentWithInfo:(NSDictionary *)dic;

@end



@interface YWCircleSpaceListCell : UITableViewCell

@property(nonatomic,strong)YWDynamicModel *model;

@property(nonatomic,strong)UIButton *showMoreButton;

@property(nonatomic,weak)id<YWCircleListCellDeleagte> delegate;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UILabel *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UIView *goodsView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;


@end
