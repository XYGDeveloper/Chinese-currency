
#import "EmptyManager.h"
#import "ApiResponse.h"

@implementation EmptyManager

+ (instancetype)sharedManager {
    static EmptyManager *__manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[EmptyManager alloc] init];
    });
    return __manager;
}

- (EmptyView *)showEmptyOnView:(UIView *)parentView
              withImage:(UIImage *)image
                explain:(NSString *)explain
          operationText:(NSString *)opText
         operationBlock:(void(^)(void))opBlock {
    
    [self removeEmptyFromView:parentView];
    
    EmptyView *view = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0 , parentView.width, parentView.height)];;
    
    view.backgroundColor = kThemeColor;
    [view refreshWithImage:image explain:explain operationText:opText operationBlock:opBlock];
    
    [parentView addSubview:view];
    
    return view;
}

- (EmptyView *)showNetErrorOnView:(UIView *)parentView
                   operationBlock:(void(^)(void))opBlock {
    return [self showNetErrorOnView:parentView response:nil operationBlock:opBlock];
}

- (EmptyView *)showNetErrorOnView:(UIView *)parentView
                         response:(ApiResponse *)response
                   operationBlock:(void(^)(void))opBlock {
    if (parentView == nil) {
        return nil;
    }
    
    [self removeEmptyFromView:parentView];
    
    EmptyView *view = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, parentView.width, parentView.height)];
    [view netErrorLayout];
    [view refreshWithImage:[UIImage imageNamed:@"net_error"] explain:kLocat(@"net_alert_load_page") operationText:kLocat(@"net_alert_load_refresh") operationBlock:^{
        [self removeEmptyFromView:parentView];
        if (opBlock) {
            opBlock();
        }
    }];
    [parentView addSubview:view];
    return view;
}

- (void)removeEmptyFromView:(UIView *)parentView {
    for (UIView *subView in parentView.subviews) {
        if ([subView isKindOfClass:[EmptyView class]]) {
            [subView removeFromSuperview];
        }
    }
}

@end






////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface EmptyView ()

@property (nonatomic, strong) UIImageView *emptyImgView;

@property (nonatomic, strong) UILabel *emptyLabel;

@property (nonatomic, strong) UIButton *operationButton;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, copy) void(^operationBlock)(void);

@end

@implementation EmptyView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self.operationButton addTarget:self action:@selector(operationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.emptyImgView];
        [self addSubview:self.emptyLabel];
        [self addSubview:self.operationButton];
        self.backgroundColor = kRGBA(24, 30, 50, 1);
        [self configLayout];
    }
    return self;
}

- (void)configLayout {
    [self.emptyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@140);
        make.centerX.equalTo(self);
    }];
    
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emptyImgView.mas_bottom).offset(20);
        make.left.right.equalTo(@0);
    }];
    
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emptyLabel.mas_bottom).offset(14);
        make.centerX.equalTo(self);
        make.width.equalTo(@141);
        make.height.equalTo(@44);
    }];
    
}

- (void)netErrorLayout {
    [self.emptyImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@100);
        make.top.equalTo(@50);
        make.centerX.equalTo(self);
    }];
}

#pragma mark - Public Methods
- (void)refreshWithImage:(UIImage *)image
                 explain:(NSString *)explain
           operationText:(NSString *)opText
          operationBlock:(void(^)(void))opBlock {
    self.emptyImgView.image = image;
    self.emptyImgView.size = image.size;
    
    self.emptyLabel.text = explain;

    self.operationButton.hidden = opText.length <= 0;
    [self.operationButton setTitle:opText forState:UIControlStateNormal];
    self.operationBlock = opBlock;
}





#pragma mark - Events
- (void)operationButtonClicked:(id)sender {
    if (self.operationBlock) {
        self.operationBlock();
    }
}

#pragma mark - Properties
- (UIImageView *)emptyImgView {
    if (!_emptyImgView) {
        _emptyImgView = [[UIImageView alloc] init];
        _emptyImgView.contentMode = UIViewContentModeScaleAspectFill;
        _emptyImgView.clipsToBounds = YES;
    }
    return _emptyImgView;
}

- (UILabel *)emptyLabel {
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] init];
        _emptyLabel.backgroundColor = [UIColor clearColor];
        _emptyLabel.font = PFLihgtFont(14);
        _emptyLabel.textColor = kRGBA(153, 153, 153, 1);
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _emptyLabel;
}

- (UIButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _operationButton.titleLabel.font = PFLihgtFont(14);
        [_operationButton setTitle:@"刷新重试" forState:UIControlStateNormal];
        [_operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_operationButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
        _operationButton.backgroundColor = kColorFromStr(@"#4173C8");
        _operationButton.layer.cornerRadius = 6.0;
        _operationButton.layer.masksToBounds = YES;
    }
    return _operationButton;
}

@end
