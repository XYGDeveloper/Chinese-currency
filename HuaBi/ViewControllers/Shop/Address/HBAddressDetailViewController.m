//
//  HBAddressDetailViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/7.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBAddressDetailViewController.h"
#import "HBAddressDetailContaineeTableViewController.h"
#import "HBMallAddressModel.h"



@interface HBAddressDetailViewController ()

@property (nonatomic, strong) HBMallAddressModel *model;
@property (nonatomic, assign) HBAddressDetailViewControllerType type;

@end

@implementation HBAddressDetailViewController

+ (instancetype)fromStoryboard {
    
    return [[UIStoryboard storyboardWithName:@"Shop" bundle:nil] instantiateViewControllerWithIdentifier:@"HBAddressDetailViewController"];
}

+ (instancetype)getShowedVCWithModel:(HBMallAddressModel *)model {
    HBAddressDetailViewController *vc = [self fromStoryboard];
    vc.model = model;
    vc.type = HBAddressDetailViewControllerTypeShow;
    vc.title = @"编辑地址";
    return vc;
}

+ (instancetype)getEditVCWithModel:(HBMallAddressModel *)model {
    HBAddressDetailViewController *vc = [self fromStoryboard];
    vc.model = model;
    vc.type = HBAddressDetailViewControllerTypeEdit;
    vc.title = @"编辑地址";
    return vc;
}

+ (instancetype)getAddVC {
    HBAddressDetailViewController *vc = [self fromStoryboard];
    vc.type = HBAddressDetailViewControllerTypeAdd;
    vc.title = @"新增地址";
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.containeeVC configureWithModel:self.model type:self.type];
}

#pragma mark - Actions

- (IBAction)saveAction:(id)sender {
    [self.containeeVC submit];
}



#pragma mark - Getters

- (HBAddressDetailContaineeTableViewController *)containeeVC {
    return (HBAddressDetailContaineeTableViewController *)self.childViewControllers.firstObject;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
