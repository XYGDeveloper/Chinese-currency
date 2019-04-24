//
//  YWMineNickNameController.m
//  ywshop
//
//  Created by 周勇 on 2017/11/16.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YWMineNickNameController.h"

@interface YWMineNickNameController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *tf;

@property(nonatomic,strong)UIButton *finishButton;


@end

@implementation YWMineNickNameController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];

    if (_type) {
        self.title = kLocat(@"Dis_GroupName");
    }else{
        self.title = @"修改昵称";
    }
    
    [self setupUI];
    
}

-(void)setupUI
{
    [self setupNavi];

    UIView *bgView = [[UIView alloc]initWithFrame:kRectMake(0, 64 + 20, kScreenW, 40)];
    bgView.backgroundColor = kWhiteColor;
    [self.view addSubview:bgView];
    
    
    UITextField *tf = [[UITextField alloc] initWithFrame:kRectMake(kMargin, 0, kScreenW - 2 *kMargin, 40)];
    [bgView addSubview:tf];
    tf.delegate = self;
    tf.textColor = k323232Color;
    tf.font = PFRegularFont(16);
    [tf becomeFirstResponder];
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.text = _niceName;
    _tf = tf;
    



    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.5)];
    lineView.backgroundColor = kColorFromStr(@"e6e6e6");
    
    [bgView addSubview:lineView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kScreenW, 0.5)];
    lineView1.backgroundColor = kColorFromStr(@"e6e6e6");
    
    [bgView addSubview:lineView1];
}
-(void)setupNavi
{
    UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    editButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [editButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    [editButton setTitleColor: kWhiteColor forState: UIControlStateNormal];
    editButton.titleLabel.font = [UIFont pingFangSC_RegularFontSize:16];
    //    [editButton setImage:[UIImage imageNamed:@"liaotianICON"] forState:UIControlStateNormal];
    [editButton setTitle:kLocat(@"Dis_Done") forState:UIControlStateNormal];
    [editButton setTitleColor:kColorFromStr(@"#999999") forState:UIControlStateNormal];

    [editButton sizeToFit];  // 设置按钮大小
    _finishButton = editButton;

    
    
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightNegativeSpacer.width = -8;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView: editButton];  // 自定义UIBarButtonItem对象
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: rightNegativeSpacer, rightItem, nil];  // 设置导航条右边的按钮
    
}
-(void)textFieldDidChange
{
    UITextField *textField = _tf;
    NSInteger maxCharCount;
    if (_type) {
        maxCharCount = 15;
    }else{
        maxCharCount = 12;

    }
    
    if (textField.text.length > maxCharCount) {
        UITextRange *markedRange = [textField markedTextRange];
        if (markedRange) {
            return;
        }
        //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
        //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
        NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:maxCharCount];
        textField.text = [textField.text substringToIndex:range.location];
    }
//    _countLabel.text = [NSString stringWithFormat:@"%zd/15",15 - _nameTF.text.length];
    
    if (_tf.text.length) {
        
        [_finishButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    }else{
        [_finishButton setTitleColor:kColorFromStr(@"#999999") forState:UIControlStateNormal];

    }

}

-(void)finishAction
{
    
    if (_type) {
     
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidUpdataEMGroupNameKey" object:_tf.text];
        [self backAction];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"act"] = @"mb_member_info";
    param[@"op"] = @"update_member_info";
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);

    param[@"request_type"] = @"nick";
    param[@"nick"] = _tf.text;
    param[@"uuid"] = [Utilities randomUUID];
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:kUpdataProfile] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            YJUserInfo *model = kUserInfo;
            model.name = _tf.text;
            [model saveUserInfo];
            kNavPop;
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

@end
