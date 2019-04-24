
#import <Foundation/Foundation.h>

@class EmptyView, ApiResponse;
@interface EmptyManager : NSObject

+ (instancetype)sharedManager;

/**
 *  在指定页面添加一个空状态页面
 *
 *  @param parentView 需要添加空状态的页面
 *  @param image      空态页面需要显示的图片
 *  @param explain    空状态说明
 *  @param opText     空状态操作按钮文案
 *  @param opBlock    空状态操作回调
 *
 *  @return 空状态视图
 */
- (EmptyView *)showEmptyOnView:(UIView *)parentView
                     withImage:(UIImage *)image
                       explain:(NSString *)explain
                 operationText:(NSString *)opText
                operationBlock:(void(^)(void))opBlock;

- (EmptyView *)showNetErrorOnView:(UIView *)parentView
                   operationBlock:(void(^)(void))opBlock;

/** 网络错误提示页 */
- (EmptyView *)showNetErrorOnView:(UIView *)parentView
                         response:(ApiResponse *)response
                   operationBlock:(void(^)(void))opBlock;

/**
 *  移除parentView上的所有空态页面
 */
- (void)removeEmptyFromView:(UIView *)parentView;

@end


@interface EmptyView : UIView

- (void)refreshWithImage:(UIImage *)image
                 explain:(NSString *)explain
           operationText:(NSString *)opText
          operationBlock:(void(^)(void))opBlock;

- (void)netErrorLayout;

@end
