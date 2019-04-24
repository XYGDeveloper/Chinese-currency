//
//  YWNetworkResultModel.h
//  ywshop
//
//  Created by 前海数交（ZJ） on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWNetworkResultModel : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) id result;

@property (nonatomic, assign, readonly) BOOL succeeded;

@property (nonatomic, strong, readonly) NSError *error;

@end
