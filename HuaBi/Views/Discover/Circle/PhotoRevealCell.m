//
//  PhotoRevealCell.m
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/11.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "PhotoRevealCell.h"


@interface PhotoRevealCell ()

@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation PhotoRevealCell

-(void)setHasPic:(BOOL)hasPic
{
    _hasPic = hasPic;
    if (hasPic == YES) {
        self.hidden = NO;
        self.deleteButton.hidden = NO;
//        self.userInteractionEnabled = NO;
    }else{
        self.hidden = YES;
//        self.userInteractionEnabled = YES;
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildingUI];
        [self layoutUI];
    }
    return self;
}

- (void)buildingUI {
    self.imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleToFill;
//    _imageView.backgroundColor = kPlaceholderImageColor;
    [self addSubview:_imageView];
    
    _deleteButton = [[UIButton alloc]initWithFrame:kRectMake(self.width - 20, 0, 20, 20)];
    [_deleteButton setImage:[UIImage imageNamed:@"img_delete"] forState:UIControlStateNormal];
    [self addSubview:_deleteButton];
    
}

- (void)layoutUI {
    __weak typeof(self)weakSelf = self;
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.and.right.equalTo(weakSelf);
    }];
}

- (void)reloadDataWithImage:(UIImage *)image {
    self.imageView.image = image;
    _deleteButton.hidden = NO;
}

-(void)removeData
{
    self.imageView.image = [UIImage imageNamed:@"add_img"];
    _deleteButton.hidden = YES;
}

@end
