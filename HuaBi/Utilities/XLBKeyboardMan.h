//
//  XLBKeyboardMan.h
//  xlb
//
//  Created by XLB(ZhangJing) on 2017/5/5.
//

#import <Foundation/Foundation.h>

typedef void(^XLBKeyboardManAnimateAppearBlock)(NSInteger appearPostIndex, CGFloat keyboardHeight, CGFloat keyboardIncrementHeight);
typedef void(^XLBKeyboardManAnimateDisappearBlock)(CGFloat keyboardHeight);


/**
 参考Swift: https://github.com/nixzhu/KeyboardMan
 */
@interface XLBKeyboardMan : NSObject

@property (nonatomic, strong) XLBKeyboardManAnimateAppearBlock animateWhenKeyboardAppearBlock;
@property (nonatomic, strong) XLBKeyboardManAnimateDisappearBlock animateWhenKeyboardDisappearBlock;
//@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) BOOL keyboardObserveEnabled;

- (instancetype)initWithKeyboardAppearBlock:(XLBKeyboardManAnimateAppearBlock)anAppearBlock
                             disappearBlock:(XLBKeyboardManAnimateDisappearBlock)aDisappearBlock;

@end
