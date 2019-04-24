//
//  HBExchangeCurrencyPickerViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/16.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBExchangeCurrencyPickerViewController.h"
#import "HBExchangeCurrencysModel.h"

@interface HBExchangeCurrencyPickerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation HBExchangeCurrencyPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.currencyModes.count;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    HBExchangeCurrencyModel *model = [self modelForRow:row];
    return model.currency_name;
}

- (HBExchangeCurrencyModel *)modelForRow:(NSInteger)row {
    if (row < self.currencyModes.count) {
        return self.currencyModes[row];
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
        HBExchangeCurrencyModel *model = [self modelForRow:row];
        self.didSelectModelBlock(model);
    }
    [self hide];
}

#pragma mark - Setters



#pragma mark - Public

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Exchange" bundle:nil] instantiateViewControllerWithIdentifier:@"HBExchangeCurrencyPickerViewController"];
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
