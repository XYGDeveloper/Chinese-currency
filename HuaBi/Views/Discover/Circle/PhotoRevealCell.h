//
//  PhotoRevealCell.h
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/11.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoRevealCell : UICollectionViewCell

- (void)reloadDataWithImage:(UIImage *)image;
- (void)removeData;

@property(nonatomic,strong)UIButton *deleteButton;


@property(nonatomic,assign)BOOL hasPic;


@end
