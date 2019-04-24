//
//  YWHomeContainerCell.h
//  ywshop
//
//  Created by 前海数交（ZJ） on 2018/8/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWHomeContainerCellDelegate<NSObject>

- (void)containerCellScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)containerCellScrollViewBeginDecelerating:(UIScrollView *)scrollView;

@end

@interface YWHomeContainerCell : UITableViewCell

@property (nonatomic, strong) NSArray<UIViewController *> *containeeVCs;
@property (nonatomic, weak) id<YWHomeContainerCellDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
