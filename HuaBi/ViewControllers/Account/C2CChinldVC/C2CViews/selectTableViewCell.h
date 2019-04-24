//
//  selectTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface selectTableViewCell : UITableViewCell
@property (nonatomic, strong, readonly) UILabel *typeName;

@property (nonatomic, strong, readonly) UITextField *textField;

@property (nonatomic, assign) NSInteger maxEditCount;

@property (nonatomic, copy) void(^contentChangedBlock)();

@property (nonatomic, copy) NSString *text;

//设置是否可以编辑，默认为YES
- (void)setEditAble:(BOOL)editAble;

- (void)setTypeName:(NSString *)typeName
        placeholder:(NSString *)placeholder;

@end


