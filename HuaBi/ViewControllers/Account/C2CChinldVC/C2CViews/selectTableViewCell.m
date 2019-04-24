//
//  selectTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "selectTableViewCell.h"
@interface selectTableViewCell()<UITextFieldDelegate>

@property (nonatomic, strong, readwrite) UILabel *typeName;

@property (nonatomic, strong, readwrite) UITextField *textField;


@end
@implementation selectTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.maxEditCount = INT16_MAX;
        [self.contentView addSubview:self.typeName];
        [self.contentView addSubview:self.textField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.typeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(@20);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(self.typeName.mas_right).offset(10);
        make.right.equalTo(@-10);
    }];
    
}


#pragma mark - Public Methods

- (void)setTypeName:(NSString *)typeName placeholder:(NSString *)placeholder
{
    self.typeName.text = typeName;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [str addAttribute:NSForegroundColorAttributeName value:kColorFromStr(@"#CCCCCC") range:NSMakeRange(0, placeholder.length)];
    self.textField.attributedPlaceholder = str;
}

- (NSString *)text {
    return [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)setText:(NSString *)text {
    self.textField.text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (self.contentChangedBlock) {
        self.contentChangedBlock();
    }
}

- (void)setEditAble:(BOOL)editAble {
    self.textField.enabled = editAble;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= self.maxEditCount && string.length > range.length) {
        return NO;
    }
    return YES;
}



#pragma mark - Properties
- (UILabel *)typeName {
    if (!_typeName) {
        _typeName = [[UILabel alloc] init];
        _typeName.textAlignment = NSTextAlignmentLeft;
        _typeName.font = [UIFont systemFontOfSize:14.0f];
        _typeName.textColor = [UIColor blackColor];
    }
    return _typeName;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:14.0f];
        _textField.textColor = [UIColor blackColor];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    }
    return _textField;
}
@end
