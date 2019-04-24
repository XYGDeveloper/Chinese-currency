

#import "PaymentMethodView.h"

@interface PaymentMethodView ()

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIImageView *qrimg;
@property (nonatomic, strong) NSString *qrcode;
@property (nonatomic, strong) UIButton *saveBtn;

@end

@implementation PaymentMethodView

- (instancetype)initWithFrame:(CGRect)frame qrcode:(NSString *)qrcode{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.qrcode = qrcode;
        [self LayoutUIs];
    }
    return self;
}

- (void)LayoutUIs
{
    self.backgroundColor = kColorFromStr(@"#171F34");
    //1.创建btn
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-80);
    // 2.设置按钮的图片
      [_leftBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(returnToPayView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftBtn];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.font = [UIFont systemFontOfSize:14.0f];
    titleLab.textColor =kRGBA(51, 51, 51, 1);
    titleLab.text = @"二维码";
    titleLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLab];

    self.qrimg = [[UIImageView alloc]init];
    
    self.qrimg.userInteractionEnabled = YES;
    self.qrimg.contentMode = UIViewContentModeScaleAspectFit;
//    self.qrimg.clipsToBounds = YES;
    [self addSubview:self.qrimg];
    
    [self.qrimg setImageWithURL:[NSURL URLWithString:self.qrcode] options:0];
    
    [self.qrimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_leftBtn.mas_bottom).mas_equalTo(20);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(kScreenH/3*2);
    }];
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveBtn setTitle:kLocat(@"k_in_c2c_tips_saveinfo") forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveBtn.backgroundColor = kColorFromStr(@"#4173C8");
    [self addSubview:self.saveBtn];
    self.saveBtn.layer.cornerRadius = 8;
    self.saveBtn.layer.masksToBounds = YES;
    [self.saveBtn addTarget:self action:@selector(saveImg:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.qrimg.mas_bottom).mas_equalTo(20);
        make.left.mas_equalTo(54);
        make.right.mas_equalTo(-54);
        make.height.mas_equalTo(45);
    }];
    
}

#pragma mark- 支付方式按钮布局约束
- (UIButton *)setPayMentBtnWithTitle:(NSString *)title andBackGroundColor:(UIColor *)baColor {
   UIButton *payBtn = [[UIButton alloc] init];
    payBtn.backgroundColor = baColor;
    [payBtn setTitle:title forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payMethodCheckClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:payBtn];
    return payBtn;
}

#pragma mark - 返回上一页支付页面
- (void)returnToPayView {
    __weak PaymentMethodView *weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.frame = CGRectMake(kScreenW, 0, kScreenW, kScreenH);
    } completion:^(BOOL finished) {
        
    }];

}

- (void)saveImg:(UIButton *)ges{
UIImageWriteToSavedPhotosAlbum(self.qrimg.image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),NULL); // 写入相册
}


-(void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        [[UIApplication sharedApplication].keyWindow showWarning:@"保存成功"];
    }
}

@end
