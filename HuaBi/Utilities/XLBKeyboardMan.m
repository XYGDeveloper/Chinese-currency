//
//  XLBKeyboardMan.m
//  xlb
//
//  Created by XLB(ZhangJing) on 2017/5/5.
//

#import "XLBKeyboardMan.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XLBKeyboardManAction) {
    XLBKeyboardManActionShow = 1,
    XLBKeyboardManActionHide
};

@interface XLBKeyboardInfo : NSObject

@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) int animationCurve;
@property (nonatomic, assign) XLBKeyboardManAction action;
@property (nonatomic, assign) BOOL isSameAction;
@property (nonatomic, assign) CGFloat incrementHeight;
@property (nonatomic, assign) CGRect beginFrame;
@property (nonatomic, assign) CGRect endFrame;
@property (nonatomic, assign) CGFloat height;

@end

@implementation XLBKeyboardInfo

- (CGFloat)height {
    return self.endFrame.size.height;
}

@end

@interface XLBKeyboardMan ()

@property (nonatomic, strong) NSNotificationCenter *keyboardObserver;

@property (nonatomic, strong) XLBKeyboardInfo *keyboardInfo;
@property (nonatomic, assign) NSInteger appearPostIndex;

@end

@implementation XLBKeyboardMan

- (instancetype)initWithKeyboardAppearBlock:(XLBKeyboardManAnimateAppearBlock)anAppearBlock
                             disappearBlock:(XLBKeyboardManAnimateDisappearBlock)aDisappearBlock {
    self = [super init];
    if (self) {
        self.animateWhenKeyboardAppearBlock = anAppearBlock;
        self.animateWhenKeyboardDisappearBlock = aDisappearBlock;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private
- (void)handlerKeyboard:(NSNotification *)notification action:(XLBKeyboardManAction)action {
    NSDictionary *userInfo = notification.userInfo;
    if (!userInfo) {
        return;
    }
    
    NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat currentHeight = endFrame.size.height;
    CGFloat previousHiehgt = self.keyboardInfo ? self.keyboardInfo.height : 0;
    CGFloat incrementHeight = currentHeight - previousHiehgt;
    
    BOOL isSameAction;
    if (self.keyboardInfo) {
        isSameAction = (self.keyboardInfo.action == action);
    } else {
        isSameAction = NO;
    }
    
    XLBKeyboardInfo *keyboardInfo = [XLBKeyboardInfo new];
    keyboardInfo.animationDuration = animationDuration;
    keyboardInfo.beginFrame = beginFrame;
    keyboardInfo.endFrame = endFrame;
    keyboardInfo.isSameAction = isSameAction;
    keyboardInfo.incrementHeight = incrementHeight;
    keyboardInfo.action = action;
    
    self.keyboardInfo = keyboardInfo;
}

- (BOOL)isApplicationStateBackground {
    return [UIApplication sharedApplication].applicationState == UIApplicationStateBackground;
}

#pragma mark - Selectors
- (void)keyboardWillShow:(NSNotification *)notification {
    if ([self isApplicationStateBackground]) {
        return;
    }
    [self handlerKeyboard:notification action:XLBKeyboardManActionShow];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if ([self isApplicationStateBackground]) {
        return;
    }
    [self handlerKeyboard:notification action:XLBKeyboardManActionHide];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    if ([self isApplicationStateBackground]) {
        return;
    }
    self.keyboardInfo = nil;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    if ([self isApplicationStateBackground]) {
        return;
    }
    if (self.keyboardInfo.action == XLBKeyboardManActionShow) {
        [self handlerKeyboard:notification action:XLBKeyboardManActionShow];
    }
}

#pragma mark - Custom Accessors
- (void)setKeyboardObserveEnabled:(BOOL)keyboardObserveEnabled {
    if (keyboardObserveEnabled == _keyboardObserveEnabled) {
        return;
    }
    _keyboardObserveEnabled = keyboardObserveEnabled;
    self.keyboardObserver = _keyboardObserveEnabled ? [NSNotificationCenter defaultCenter] : nil;
}

- (void)setKeyboardObserver:(NSNotificationCenter *)keyboardObserver {
    [_keyboardObserver removeObserver:self];
    
    _keyboardObserver = keyboardObserver;
    if (_keyboardObserver) {
        [_keyboardObserver addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [_keyboardObserver addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [_keyboardObserver addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        [_keyboardObserver addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

- (void)setAnimateWhenKeyboardAppearBlock:(XLBKeyboardManAnimateAppearBlock)animateWhenKeyboardAppearBlock {
    _animateWhenKeyboardAppearBlock = animateWhenKeyboardAppearBlock;
    self.keyboardObserveEnabled = YES;
}

- (void)setAnimateWhenKeyboardDisappearBlock:(XLBKeyboardManAnimateDisappearBlock)animateWhenKeyboardDisappearBlock {
    _animateWhenKeyboardDisappearBlock = animateWhenKeyboardDisappearBlock;
    self.keyboardObserveEnabled = YES;
}

- (void)setKeyboardInfo:(XLBKeyboardInfo *)keyboardInfo {
    _keyboardInfo = keyboardInfo;
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        return;
    }
    
    if (!_keyboardInfo) {
        return;
    }
    
    if (_keyboardInfo.isSameAction && _keyboardInfo.incrementHeight == 0) {
        return;
    }
    
    NSUInteger options = _keyboardInfo.animationCurve << 16 | UIViewAnimationOptionBeginFromCurrentState;
    [UIView animateWithDuration:_keyboardInfo.animationDuration delay:0 options:options animations:^{
        switch (_keyboardInfo.action) {
            case XLBKeyboardManActionShow:
                if (self.animateWhenKeyboardAppearBlock) {
                    self.animateWhenKeyboardAppearBlock(self.appearPostIndex, _keyboardInfo.height, _keyboardInfo.incrementHeight);
                }
                self.appearPostIndex += 1;
                break;
            case XLBKeyboardManActionHide:
                if (self.animateWhenKeyboardDisappearBlock) {
                    self.animateWhenKeyboardDisappearBlock(_keyboardInfo.height);
                }
                self.appearPostIndex = 0;
                break;
        }
    } completion:nil];
}

@end
