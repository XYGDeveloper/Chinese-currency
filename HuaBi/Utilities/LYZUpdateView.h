//
//  LYZUpdateView.h
//  LeYiZhu-iOS
//
//  Created by mac on 2017/5/23.
//  Copyright © 2017年 乐易住智能科技. All rights reserved.
//

#import "BaseMessageView.h"

#pragma mark - AlertViewMessageObject

@interface UpdateViewMessageObject : NSObject

@property (nonatomic, strong) NSString                         *title;
@property (nonatomic, strong) NSString                         *content;
@property (nonatomic, strong) NSString                         *buttonTitle;
@property (nonatomic, assign) BOOL                               isforce;

@end

NS_INLINE UpdateViewMessageObject * MakeUpdateViewObject(NSString *title, NSString *content,NSString *buttonTitle, BOOL isforce) {
    
    UpdateViewMessageObject *object = [UpdateViewMessageObject new];
    object.content                 = content;
    object.title                       =  title;
    object.buttonTitle           =  buttonTitle;
    object.isforce                  = isforce;
    return object;
}


@interface LYZUpdateView : BaseMessageView

@end
