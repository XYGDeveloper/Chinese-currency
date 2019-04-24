//
//  HBSelectCodeOfCountryView.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/13.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBSelectCodeOfCountryView.h"
#import "ICNNationalityCell.h"

@interface HBSelectCodeOfCountryView () <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HBSelectCodeOfCountryView

#pragma mark - Public

+ (instancetype)loadNibView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}



- (void)showInWindow {
    UIView *window = [UIApplication sharedApplication].keyWindow;
    [self showInView:window];
}

- (void)showInView:(UIView *)view {
    self.frame = view.bounds;
    [view addSubview:self];
    [view bringSubviewToFront:self];
    
    self.alpha = 0.;
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1.;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0.;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ICNNationalityCell" bundle:nil] forCellReuseIdentifier:@"ICNNationalityCell"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.codesOfCountry.count;
}

- (ICNNationalityModel *)modelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.codesOfCountry.count) {
        return self.codesOfCountry[indexPath.row];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICNNationalityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ICNNationalityCell" forIndexPath:indexPath];
    cell.model = [self modelAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(selectCodeOfCountryView:didSelectModel:)]) {
        [self.delegate selectCodeOfCountryView:self didSelectModel:[self modelAtIndexPath:indexPath]];
    }
    
    [self hide];
}

#pragma mark - Setters

- (void)setCodesOfCountry:(NSArray<ICNNationalityModel *> *)codesOfCountry {
    _codesOfCountry = codesOfCountry;
    
    
    
    [self.tableView reloadData];
}

@end
