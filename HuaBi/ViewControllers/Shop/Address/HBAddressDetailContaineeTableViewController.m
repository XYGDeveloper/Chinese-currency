//
//  HBAddressDetailContaineeTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/4/7.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBAddressDetailContaineeTableViewController.h"
#import "HBMallAddressModel.h"
#import "NSObject+SVProgressHUD.h"
#import "BLAreaPickerView.h"
#import "UITextView+Placeholder.h"

@interface HBAddressDetailContaineeTableViewController () <BLPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *consigneeTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextView *detailAddressTextView;
@property (weak, nonatomic) IBOutlet UISwitch *isDefaultSwitch;
@property (weak, nonatomic) IBOutlet UITextField *areaInfoTextField;

@property (nonatomic, strong) HBMallAddressModel *model;
@property (nonatomic, assign) HBAddressDetailViewControllerType type;

@property (nonatomic, strong) BLAreaPickerView *areaPickerView;


@end

@implementation HBAddressDetailContaineeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBar ButtonItem = self.editButtonItem;
    
    self.tableView.backgroundColor = kColorFromStr(@"#F4F4F4");
    self.detailAddressTextView.placeholder = @"详细地址:如道路、门牌号、小区、楼栋号、单元等";
    self.detailAddressTextView.placeholderColor = self.detailAddressTextView.textColor;
}

- (void)configureWithModel:(HBMallAddressModel *)model type:(HBAddressDetailViewControllerType)type {
    self.model = model; self.type = type;
    switch (self.type) {
        case HBAddressDetailViewControllerTypeEdit:
        case HBAddressDetailViewControllerTypeShow:
        {
            self.consigneeTextField.text = self.model.name;
            self.phoneTextField.text = self.model.phone;
            self.detailAddressTextView.text = self.model.address;
            self.areaInfoTextField.text = self.model.area_info;
            self.isDefaultSwitch.on = [self.model.is_default isEqualToString:@"1"];
        }
            break;
            
        default:
            break;
    }
}

- (void)submit {
    NSString *name = self.consigneeTextField.text;
    NSString *phone = self.phoneTextField.text;
    NSString *areaInfo = self.areaInfoTextField.text;
    NSString *address = self.detailAddressTextView.text;
    NSString *isDefault = self.isDefaultSwitch.on ? @"1" : @"0";
    
    if (name.length == 0) {
        [self showInfoWithMessage:@"请填写收货人名"];
        [self.consigneeTextField becomeFirstResponder];
        return;
    }
    if (name.length > 25) {
        [self showInfoWithMessage:@"收货人姓名最多支持25个字"];
        [self.consigneeTextField becomeFirstResponder];
        return;
    }
    if (phone.length == 0) {
        [self showInfoWithMessage:@"请填写联系电话"];
        [self.phoneTextField becomeFirstResponder];
        return;
    }
    if (areaInfo.length < 2) {
        [self showInfoWithMessage:@"请选择所在地区"];
        return;
    }
    if (address.length == 0) {
        [self showInfoWithMessage:@"请填写详细地址"];
        [self.detailAddressTextView becomeFirstResponder];
        return;
    }
    if (address.length > 50) {
        [self showInfoWithMessage:@"详细地址最多支持50个字"];
        [self.detailAddressTextView becomeFirstResponder];
        return;
    }
    
    HBMallAddressModel *model = self.model;
    BOOL isAdd = (self.type == HBAddressDetailViewControllerTypeAdd);
    if (isAdd) {
        model = [HBMallAddressModel new];
    }
    model.name = name;
    model.phone = phone;
    model.address = address;
    model.is_default = isDefault;
    model.area_info = areaInfo;
    
    kShowHud;
    [model requestSaveOrAddAddressWithIsAdd:isAdd success:^(YWNetworkResultModel * _Nonnull obj) {
        kHideHud;
        if (obj.succeeded) {
            [self showSuccessWithMessage:obj.message];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HBAddressDetailViewControllerChanged" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kNavPop;
            });
        } else {
             [self showInfoWithMessage:obj.message];
        }
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        [self showErrorWithMessage:error.localizedDescription];
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        [self.areaPickerView bl_show];
    }
}

#pragma mark - BLPickerViewDelegate

- (void)bl_selectedAreaResultWithProvince:(NSString *)provinceTitle city:(NSString *)cityTitle area:(NSString *)areaTitle {
    NSString *areaString = [NSString stringWithFormat:@"%@ %@ %@", provinceTitle ?: @"", cityTitle, areaTitle];
    
    self.areaInfoTextField.text = areaString;
}

#pragma mark - Getters

- (BLAreaPickerView *)areaPickerView {
    if (!_areaPickerView) {
        _areaPickerView = [[BLAreaPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 175)];
        _areaPickerView.pickViewDelegate = self;
    }
    
    return _areaPickerView;
}
@end
