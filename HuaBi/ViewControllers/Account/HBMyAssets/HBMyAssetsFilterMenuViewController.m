//
//  HBMyAssetsFilterMenuViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/10.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBMyAssetsFilterMenuViewController.h"
#import "HBMyAssetsFilterMenuCell.h"
#import "HBMyAssetsFilterModel+Request.h"

@interface HBMyAssetsFilterMenuViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *titles;
@property (weak, nonatomic) IBOutlet UIView * footerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSArray<HBMyAssetsFilterModel *> * _Nonnull array;

@property (nonatomic, assign) BOOL isFetchInProgress;

@end

@implementation HBMyAssetsFilterMenuViewController

+ (instancetype)fromStoryboard {
    return [UIStoryboard storyboardWithName:@"MyAssets" bundle:nil].instantiateInitialViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.backgroundColor = kThemeBGColor;
    self.footerView.backgroundColor = kThemeColor;
    self.tableView.separatorColor = kThemeBGColor;
    [self.cancelButton setTitle:kLocat(@"Cancel") forState:UIControlStateNormal];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

#pragma mark - Private

- (void)_requestCurrencyUserStreamFilter {
    if (self.array.count > 0) {
        return;
    }
    if (self.isFetchInProgress) {
        return;
    }
    self.isFetchInProgress = YES;
    [self.activityIndicatorView startAnimating];
    [HBMyAssetsFilterModel getCurrencyUserStreamFilterWithSuccess:^(NSArray<HBMyAssetsFilterModel *> * _Nonnull array, YWNetworkResultModel * _Nonnull model) {
        [self.activityIndicatorView stopAnimating];
        self.isFetchInProgress = NO;
        self.array = array;
        
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [self.activityIndicatorView stopAnimating];
        self.isFetchInProgress = NO;
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.array.count;
}

- (HBMyAssetsFilterModel *)modelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
      
        return [HBMyAssetsFilterModel createAllModel];
    } else if (indexPath.row < self.array.count) {
        return self.array[indexPath.row];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBMyAssetsFilterMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBMyAssetsFilterMenuCell" forIndexPath:indexPath];
    HBMyAssetsFilterModel *model = [self modelAtIndexPath:indexPath];
    cell.nameLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
    if (self.didSelectModelBlock) {
        HBMyAssetsFilterModel *model = [self modelAtIndexPath:indexPath];
        self.didSelectModelBlock(model);
    }
}

#pragma mark - Actions

- (IBAction)cancelAction:(id)sender {
    [self hide];
}

#pragma mark - Public

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController addChildViewController:self];
    [self didMoveToParentViewController:window.rootViewController];
    [window addSubview:self.view];
    CGFloat constant = 44.;
    if (@available(iOS 11.0, *)) {
        constant += window.safeAreaInsets.top;
    } else {
        constant += 20.;
    }
    
    self.tableView.y = constant;
    self.tableView.x = kScreenW;
    self.view.alpha = 0.01;
    [UIView animateWithDuration:0.1 animations:^{
        self.view.alpha = 1;
    }];
    [UIView animateWithDuration:0.2 delay:0.1 options:(7 << 16) |UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.tableView.x = kScreenW - 210.;
    } completion:nil];
    
    [self _requestCurrencyUserStreamFilter];
}

- (void)hide {
    
    [UIView animateWithDuration:0.2 delay:0 options:(7 << 16) animations:^{
        self.tableView.x = kScreenW;
    } completion:nil];
    
    [UIView animateWithDuration:0.1 delay:0.15 options:(7 << 16) animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self didMoveToParentViewController:nil];
        [self removeFromParentViewController];
    }];
}

@end
