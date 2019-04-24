//
//  HBPickerViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBPickerViewController.h"

@interface HBPickerViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation HBPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.cancelButton setTitle:kLocat(@"net_alert_load_message_cancel") forState:UIControlStateNormal];
    [self.sureButton setTitle:kLocat(@"net_alert_load_message_sure") forState:UIControlStateNormal];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.models.count;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    id<HBPickerModel> model = [self modelForRow:row];
    return model.name;
}

- (id<HBPickerModel>)modelForRow:(NSInteger)row {
    if (row < self.models.count) {
        return self.models[row];
    }
    
    return nil;
}

#pragma mark - Actions

- (IBAction)cancelAction:(id)sender {
    [self hide];
}

- (IBAction)sureAction:(id)sender {
    if (self.didSelectModelBlock) {
        NSInteger row = [self.pickerView selectedRowInComponent:0];
        id<HBPickerModel> model = [self modelForRow:row];
        self.didSelectModelBlock(model);
    }
    [self hide];
}

#pragma mark - Setters



#pragma mark - Public

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"HoldingMoney" bundle:nil] instantiateViewControllerWithIdentifier:@"HBPickerViewController"];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController addChildViewController:self];
    [self didMoveToParentViewController:window.rootViewController];
    [window addSubview:self.view];
    
    CGFloat height = 243;
    if (@available(iOS 11.0, *)) {
        height += window.safeAreaInsets.bottom;
    }
    
    self.containerView.y = kScreenH;
    self.containerView.height = height;
    self.view.alpha = 0.01;
    [UIView animateWithDuration:0.1 animations:^{
        self.view.alpha = 1;
    }];
    [UIView animateWithDuration:0.2 delay:0.1 options:(7 << 16) |UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.containerView.y = kScreenH - height;
    } completion:nil];
    
}

- (void)hide {
    
    [UIView animateWithDuration:0.2 delay:0 options:(7 << 16) animations:^{
        self.containerView.y = kScreenH;
    } completion:nil];
    
    [UIView animateWithDuration:0.1 delay:0.15 options:(7 << 16) animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    
}



@end
