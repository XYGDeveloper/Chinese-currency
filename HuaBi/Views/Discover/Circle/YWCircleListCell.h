//
//  YWCircleListCell.h
//  ywshop
//
//  Created by 周勇 on 2017/10/26.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>
//#define DistrictViewWith (kScreenW - 12 - 8 - 45)



@protocol YWCircleListCellDeleagte <NSObject>

-(void)commnetLabel:(UIView *)commentLabel userDidClickJSYCircleListCellCommentWithInfo:(NSDictionary *)dic;



@end

@interface YWCircleListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *attentionButton;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property(nonatomic,strong)UIButton *showMoreButton;


@property(nonatomic,weak)id<YWCircleListCellDeleagte> delegate;

@property(nonatomic,strong)YWDynamicModel *model;

/**  cell类型,0是圈子列表 1是搜索列表  */
@property(nonatomic,assign)NSInteger type;



@end
