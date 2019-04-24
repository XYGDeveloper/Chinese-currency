//
//  XYJGGView.m
//  XYCustomJGGExample
//
//  Created by XY Lv on 16/12/6.
//  Copyright © 2016年 吕欣宇. All rights reserved.
//

#import "XYJGGView.h"
#import "XYConstant.h"
#import "UIImageView+WebCache.h"
#import "IndexModel.h"
@implementation XYJGGView

- (instancetype)initWithFrame:(CGRect)xy_frame withXYPhotosDataMArr:(NSMutableArray *)xy_PhotosDataMArr withXYPlaceholderImg:(UIImage *)xy_placeholderImg withBgView:(UIView *)xy_bgView withXYItemViewTapBlock:(xyItemViewTapBlock)xy_itemViewTapBlock{
    for(UIView * view in xy_bgView.subviews){
        if([view isKindOfClass:[self class]]){
            [view removeFromSuperview];
        }
    }
    self = [super initWithFrame:xy_frame];
    if(self){
        self.xy_PhotosDataMArr = xy_PhotosDataMArr;
        self.xy_itemViewTapBlock = xy_itemViewTapBlock;
        CGFloat xy_itemX;
        CGFloat xy_itemY;
        CGFloat xy_itemW = 0;
        CGFloat xy_itemH = 0;

        int     xy_count = 1;
        CGFloat xy_itemViewH = 142;
        if(xy_PhotosDataMArr.count>0){
            if((xy_PhotosDataMArr.count>1&&xy_PhotosDataMArr.count<4)||(xy_PhotosDataMArr.count>4&&xy_PhotosDataMArr.count<14)){
                xy_itemW = XY_DefaultPhotoH;
                xy_itemH = 142;
                xy_count = 3;
            }else if(xy_PhotosDataMArr.count == 4){
                xy_itemW = XY_FourPhotoH;
                xy_itemH = 142;
                xy_count = 2;
            }else if(xy_PhotosDataMArr.count == 1){
                xy_itemW = XY_AlonePhotoH;
                xy_itemH = 142;
                xy_count = 1;
            }
        }

        for(int i=0;i<xy_PhotosDataMArr.count;i++){
            
            itemModel *model = [xy_PhotosDataMArr objectAtIndex:i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = kColorFromStr(@"#F6F7FB");
            button.layer.borderColor = kColorFromStr(@"#E9EAEC").CGColor;
            button.layer.borderWidth = 1.0;
            xy_itemX = (xy_itemW + XY_Padding)*(i%xy_count);
            xy_itemY = (xy_itemH + XY_Padding)*(i/xy_count);
            button.frame = CGRectMake(xy_itemX, xy_itemY, xy_itemW, xy_itemH);
            button.tag = i;
            if(i==(xy_PhotosDataMArr.count-1)){
                xy_itemViewH = xy_itemY + xy_itemH + XY_Padding*2;
                self.xy_itemViewH = xy_itemViewH;
                CGRect itemViewFrame = CGRectMake(xy_frame.origin.x, xy_frame.origin.y, xy_frame.size.width, xy_itemViewH);
                self.frame = itemViewFrame;
            }
            [self addSubview:button];
            
            UIImageView *topImg = [[UIImageView alloc]init];
            topImg.userInteractionEnabled = YES;
            topImg.image = [UIImage imageNamed:@"index_hot"];
            [button addSubview:topImg];
            [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.mas_equalTo(10);
                make.width.height.mas_equalTo(11);
            }];
            
            UILabel *label = [[UILabel alloc]init];
            label.textColor = kColorFromStr(@"#C3CED2");
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:12.0f];
            label.userInteractionEnabled = YES;
            [button addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(topImg.mas_right).mas_equalTo(5);
                make.centerY.mas_equalTo(topImg.mas_centerY);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(14);
            }];
            label.text = [NSString stringWithFormat:@"NO.%d",i + 1];
            
            UILabel *mlabel = [[UILabel alloc]init];
            mlabel.textColor = [UIColor blackColor];
            mlabel.textAlignment = NSTextAlignmentCenter;
            mlabel.font = [UIFont systemFontOfSize:14.0f];
            mlabel.userInteractionEnabled = YES;
            [button addSubview:mlabel];

            [mlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(button.mas_centerY);
                make.right.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.height.mas_equalTo(14);
            }];
            
            mlabel.text = [NSString stringWithFormat:@"%@/AT",model.currency_name];
            
            UILabel *slabel = [[UILabel alloc]init];
            slabel.textColor = kColorFromStr(@"#896FED");
            slabel.textAlignment = NSTextAlignmentCenter;
            slabel.font = [UIFont systemFontOfSize:18.0f];
            slabel.userInteractionEnabled = YES;
            [button addSubview:slabel];

            [slabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(mlabel.mas_top).mas_equalTo(-5);
                make.right.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.height.mas_equalTo(14);
            }];
            if ([model.price_status isEqualToString:@"0"]) {
                slabel.text = [NSString stringWithFormat:@"%@%%",model.H_change24];
            }else if ([model.price_status isEqualToString:@"1"]){
                slabel.text = [NSString stringWithFormat:@"+%@%%",model.H_change24];
            }else{
                slabel.text = [NSString stringWithFormat:@"%@%%",model.H_change24];
            }
            UILabel *xlabel = [[UILabel alloc]init];
            xlabel.textColor = kColorFromStr(@"#896FED");
            xlabel.textAlignment = NSTextAlignmentCenter;
            xlabel.font = [UIFont systemFontOfSize:10.0f];
            xlabel.userInteractionEnabled = YES;
            [button addSubview:xlabel];

            [xlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(mlabel.mas_bottom).mas_equalTo(5);
                make.right.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.height.mas_equalTo(14);
            }];
            
            xlabel.text = [NSString stringWithFormat:@"+%@",model.H_done_num24];
            UILabel *blabel = [[UILabel alloc]init];
            blabel.textColor = kColorFromStr(@"#193B56");
            blabel.textAlignment = NSTextAlignmentCenter;
            blabel.font = [UIFont systemFontOfSize:10.0f];
            blabel.userInteractionEnabled = YES;
            [button addSubview:blabel];
            [blabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(button.mas_bottom).mas_equalTo(-5);
                make.right.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.height.mas_equalTo(14);
            }];
            
            blabel.text = model.H_done_money24;
            
            UILabel *llabel = [[UILabel alloc]init];
            llabel.textColor = [UIColor blackColor];
            llabel.textAlignment = NSTextAlignmentCenter;
            llabel.font = [UIFont systemFontOfSize:10.0f];
            llabel.userInteractionEnabled = YES;
            [button addSubview:llabel];
            llabel.backgroundColor = [UIColor lightGrayColor];

            [llabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(blabel.mas_top).mas_equalTo(-5);
                make.centerX.mas_equalTo(button.mas_centerX);
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(1);
            }];
            
            [button addTarget:self action:@selector(xyItemViewTap:) forControlEvents:UIControlEventTouchUpInside];

        }
        
    }
    
    [xy_bgView addSubview:self];
    return self;
}

- (void)xyItemViewTap:(UIButton *)xySender{
    
    if(self.xy_itemViewTapBlock){
        self.xy_itemViewTapBlock(xySender.tag,_xy_PhotosDataMArr);
    }
}



@end












