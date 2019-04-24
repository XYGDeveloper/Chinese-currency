//
//  C2CViewController.m
//  YJOTC
//
//  Created by l on 2018/9/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "C2CViewController.h"
#import "DVSwitch.h"
#import "C2CHeaderTableViewCell.h"
#import "BCBitemTableViewCell.h"
#import "UILabel+HeightLabel.h"

@interface C2CViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) DVSwitch *switcher;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *TypeLabel;
@property (strong, nonatomic) UITextField *sellInpriceField;
@property (strong, nonatomic) UITextField *sellIncountField;
@property (strong, nonatomic) UIView *caculateView;
@property (strong, nonatomic) UILabel *caculatedes;
@property (strong, nonatomic) UILabel *caculateCount;
@property (strong, nonatomic) UIView *caculateButtonView;
@property (strong, nonatomic) UIButton *caculateButton;
@property (strong, nonatomic) C2CHeaderTableViewCell *head;
@property (strong, nonatomic) UILabel *footer;

@end

@implementation C2CViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"k_meViewcontroler_s1_2");
    [self layOutsubs];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableview.backgroundColor = kRGBA(244, 244, 244, 1);
    self.view.backgroundColor = kRGBA(244, 244, 244, 1);
    self.tableview.separatorColor = kRGBA(244, 244, 244, 1);
//    [self.Tableview registerNib:[UINib nibWithNibName:@"MyAsetTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyAsetTableViewCell class])];
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"BCBitemTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([BCBitemTableViewCell class])];
    self.footer = [[UILabel alloc]initWithFrame:CGRectMake(20,0, kScreenW -40, 0) text:kLocat(@"k_bcbViewController_des") font:[UIFont systemFontOfSize:16.0f] textColor:kColorFromStr(@"#AAAAAA") textAlignment:NSTextAlignmentLeft adjustsFont:NO];
    self.footer.numberOfLines = 0;
    self.footer.frame = CGRectMake(20,20, kScreenW -40, [self.footer contentSize].height);
    self.tableview.tableFooterView = self.footer;
    // Do any additional setup after loading the view from its nib.
}

- (void)layOutsubs{
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 197+45+91)];
    self.tableview.tableHeaderView = self.contentView;
    self.switcher = [[DVSwitch alloc] initWithStringsArray:@[kLocat(@"k_bcbViewController_sellin"), kLocat(@"k_bcbViewController_sellout")]];
    self.switcher.backgroundColor = kRGBA(244, 244, 244, 1);
    self.switcher.sliderColor = kColorFromStr(@"#896FED");
    self.switcher.labelTextColorInsideSlider = [UIColor whiteColor];
    self.switcher.labelTextColorOutsideSlider = kColorFromStr(@"#999999");
    self.switcher.layer.cornerRadius = 26/2;
    self.switcher.layer.masksToBounds = YES;
    self.switcher.layer.borderWidth = 1;
    self.switcher.layer.borderColor = kColorFromStr(@"#896FED").CGColor;
    self.switcher.frame = CGRectMake(100, 15,kScreenW - 100*2, 25);
    [self.contentView addSubview:self.switcher];
    [self.switcher selectIndex:0 animated:YES];
    [self.switcher setPressedHandler:^(NSUInteger index) {
        NSLog(@"Did press position on first switch at index: %lu", (unsigned long)index);
        
    }];
    
    self.TypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.switcher.frame)+15, kScreenW, 40) text:@"AT交易" font:[UIFont systemFontOfSize:14.0F] textColor:kColorFromStr(@"#896FED") textAlignment:NSTextAlignmentCenter adjustsFont:YES];
    self.TypeLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.TypeLabel];
    
    self.sellInpriceField = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.TypeLabel.frame)+5, kScreenW-40, 45)];
    self.sellInpriceField.textAlignment = NSTextAlignmentRight;
    self.sellInpriceField.placeholder = @"买入价格";
    [self.contentView addSubview:self.sellInpriceField];
    
    self.sellIncountField = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.sellInpriceField.frame)+5, kScreenW-40, 45)];
    self.sellIncountField.placeholder = @"买入数量";
    self.sellIncountField.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.sellIncountField];
    
    self.caculateView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sellIncountField.frame)+5, kScreenW, 45)];
    self.caculateView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.caculateView];
    
    self.caculatedes = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, (kScreenW-40)/2, 45) text:@"需要" font:[UIFont systemFontOfSize:14.0f] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft adjustsFont:YES];
    [self.caculateView addSubview:self.caculatedes];
    
    self.caculateCount = [[UILabel alloc]initWithFrame:CGRectMake(20+(kScreenW-40)/2, 0, (kScreenW-40)/2, 45) text:@"CNY" font:[UIFont systemFontOfSize:14.0f] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentRight adjustsFont:YES];
    [self.caculateView addSubview:self.caculateCount];
    
    self.caculateButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.caculateView.frame)+5, kScreenW, 50)];
    self.caculateButtonView.backgroundColor = kRGBA(244, 244, 244, 1);
    [self.contentView addSubview:self.caculateButtonView];
    self.caculateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.caculateButtonView addSubview:self.caculateButton];
    self.caculateButton.frame = CGRectMake(0, 0, kScreenW, 45);
    self.caculateButton.backgroundColor = kColorFromStr(@"#896FED");
    
    self.head =  [[[NSBundle mainBundle] loadNibNamed:@"C2CHeaderTableViewCell" owner:nil options:nil] lastObject];
    self.head.frame = CGRectMake(0, CGRectGetMaxY(self.caculateButtonView.frame), kScreenW, 35);
    [self.contentView addSubview:self.head];
    
}


#pragma mark- layOutsubviews


#pragma mark- TableviewDelegateAndDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BCBitemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BCBitemTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/**
 <#Description#>
 
 @param tableView <#tableView description#>
 @param indexPath <#indexPath description#>
 */

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    kNavPush([MyAssetDetailViewController new]);
//}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    }else{
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

@end
