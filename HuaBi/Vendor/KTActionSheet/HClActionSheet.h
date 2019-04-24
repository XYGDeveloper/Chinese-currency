//
//  KTActionSheet.h
//  
//
//  Created by hcl on 15/10/13.
//
//

#import <UIKit/UIKit.h>

///Block回调
typedef void (^SelectIndexBlock)(NSInteger index, NSString *title);

typedef NS_ENUM(NSUInteger, HClSheetStyle) {
    HClSheetStyleDefault = 0, //默认样式
    HClSheetStyleWeiChat, //像微信样式
};

@protocol KTActionSheetDelegate <NSObject>
///传递index和title,以及sender即HClActionSheet,可用tag等属性区别不同的HClActionSheet
- (void)sheetViewDidSelectIndex:(NSInteger)index
                          title:(NSString *)title
                         sender:(id)sender;

///简单传递出index和title
- (void)sheetViewDidSelectIndex:(NSInteger)index
                          title:(NSString *)title;
@end

@interface HClActionSheet : UIView

///标题颜色,默认是darkGrayColor
@property (strong, nonatomic) UIColor *titleTextColor;
///item字体颜色,默认是blueColor
@property (strong, nonatomic) UIColor *itemTextColor;
///取消字体颜色,默认是blueColor
@property (strong, nonatomic) UIColor *cancleTextColor;
///标题文字字体
@property (strong, nonatomic) UIFont *titleTextFont;
///item文字字体
@property (strong, nonatomic) UIFont *itemTextFont;
///取消文字字体
@property (strong, nonatomic) UIFont *cancleTextFont;
///取消按钮文字设置,默认是"取消"
@property (strong, nonatomic) NSString *cancleTitle;

///设置代理,则有两个代理方法可供选择
@property (weak, nonatomic) id delegate;

///初始化方法,title不传则不显示,tableView当item显示不完的时候可以滑动,style默认是UIActionSheet样式
- (id)initWithTitle:(NSString *)title
              style:(HClSheetStyle)style
         itemTitles:(NSArray *)itemTitles ;

///回调block中包含选中的index和title---也可实现代理方法获取选中的数据
- (void)didFinishSelectIndex:(SelectIndexBlock)block;

@end
