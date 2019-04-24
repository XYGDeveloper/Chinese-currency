//
//  HBShoppingCartViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2019/3/26.
//  Copyright © 2019 前海数交平台运营. All rights reserved.
//

#import "HBShoppingCartViewController.h"
#import "HBShoppingCartItemCell.h"
#import "HBShopCartModel+Request.h"
#import "NSObject+SVProgressHUD.h"
#import "YWEmptyDataSetDataSource.h"
#import "YWAlert.h"
#import "HBConfirmOrderViewController.h"
#import "HBGoodsDetailViewController.h"

@interface HBShoppingCartViewController () <UITableViewDataSource, UITableViewDelegate, HBShoppingCartItemCellDelegate >

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UIButton *operationButton;
@property (weak, nonatomic) IBOutlet UIStackView *totalPriceContainerStackView;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;

@property (nonatomic, strong) NSArray<HBShopCartModel *> *models;
@property (nonatomic, strong) NSMutableArray<HBShopCartModel *> *deleteModels;
@property (nonatomic, strong) YWEmptyDataSetDataSource *emptyDataSetDataSource;
@property (nonatomic, strong) NSSet<NSString *> *selectedCartIDs;

@property (nonatomic, assign) BOOL isEditing;

@end

@implementation HBShoppingCartViewController

+ (instancetype)fromStroyboard {
    return [[UIStoryboard storyboardWithName:@"Shop" bundle:nil] instantiateViewControllerWithIdentifier:@"HBShoppingCartViewController"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self _requestCartDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"购物车";
    self.bottomContainerView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bottomContainerView.layer.shadowOpacity = 0.3;
    self.bottomContainerView.layer.shadowRadius = 2;
    self.bottomContainerView.layer.shadowOffset = CGSizeMake(0, -2);
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_requestCartDatas)];
    [self.tableView.mj_header beginRefreshing];
    
    self.emptyDataSetDataSource = [[YWEmptyDataSetDataSource alloc] initWithScrollView:self.tableView];
    self.tableView.emptyDataSetSource = self.emptyDataSetDataSource;
    self.tableView.emptyDataSetDelegate = self.emptyDataSetDataSource;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(_editOrDoneAction)];
    rightItem.tintColor = kColorFromStr(@"#FFD401");
    self.navigationItem.rightBarButtonItem = rightItem;
    
    if ([Utilities isExpired]) {
        [self gotoLoginVC];
    }
}

#pragma mark - Private

- (void)_requestCartDatas {
    self.selectedCartIDs = [self _getSelectedCartIds];
    [HBShopCartModel requestCartsWithSuccess:^(NSArray<HBShopCartModel *> * _Nonnull models, YWNetworkResultModel * _Nonnull obj) {
        self.models = models;
        [self.tableView.mj_header endRefreshing];
        self.emptyDataSetDataSource.title = kLocat(@"empty_msg");
    } failure:^(NSError * _Nonnull error) {
        self.models = nil;
        self.emptyDataSetDataSource.title = error.localizedDescription;
        [self showErrorWithMessage:error.localizedDescription];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (NSSet *)_getSelectedCartIds {
    NSArray *selectedModels = [self.models filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected=YES"]];
    
    NSSet *selectedCartIds = [selectedModels mutableSetValueForKeyPath:@"cart_id"].copy;
    
    return selectedCartIds;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *models = [self currentModels];
    return models.count;
}

- (HBShopCartModel *)modelAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *models = [self currentModels];
    
    if (indexPath.row < models.count) {
        return models[indexPath.row];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBShoppingCartItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBShoppingCartItemCell" forIndexPath:indexPath];
    cell.model = [self modelAtIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HBShopCartModel *model = [self modelAtIndexPath:indexPath];
    HBGoodsDetailViewController *vc = [[HBGoodsDetailViewController alloc] initWithGoodsId:model.goods_id];
    kNavPush(vc);
}

#pragma mark - HBShoppingCartItemCellDelegate

- (void)checkBoxChangedWithShoppingCartItemCell:(HBShoppingCartItemCell *)cell {
    [self _updateAllButtonSelectedState];
    [self _caculateTotalMoney];
}

- (void)_updateAllButtonSelectedState {
    NSArray *selectedModels = [[self currentModels] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected=YES"]];
    if (selectedModels.count == 0) {
        self.allButton.selected = NO;
    } else {
        self.allButton.selected = (selectedModels.count == [self currentModels].count);
    }
    
}

- (void)shoppingCartItemCell:(HBShoppingCartItemCell *)cell
               changedNumber:(NSInteger)number
                       model:(HBShopCartModel *)model {
    kShowHud;
    [model requestModifyNumberOfCartWithNumber:number success:^(NSInteger stockNumber, YWNetworkResultModel * _Nonnull obj) {
        kHideHud;
        model.goods_number = [NSString stringWithFormat:@"%@", @(stockNumber)];
        [cell updateNumber];
        [self _caculateTotalMoney];
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        [cell updateNumber];
        [self showErrorWithMessage:error.localizedDescription];
    }];
}

#pragma mark - Actions

- (void)_editOrDoneAction {
    self.isEditing = !self.isEditing;
    
    if (self.isEditing) {
        self.deleteModels = @[].mutableCopy;
        for (HBShopCartModel *model in self.models) {
            HBShopCartModel *newModel = model.modelCopy;
            newModel.isSelected = NO;
            [self.deleteModels addObject:newModel];
        }
    }
    
    [self _updateUI];
    [self.tableView reloadData];
}

- (IBAction)selectAllAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[self currentModels] enumerateObjectsUsingBlock:^(HBShopCartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelected = sender.selected;
    }];
    [self.tableView reloadData];
    [self _caculateTotalMoney];
}


- (IBAction)submitOrDeleteAction:(id)sender {
    if (self.isEditing) {
        [self _deleteCarts];
    } else {
        [self _submitCarts];
    }
}

- (void)_deleteCarts {
    NSArray *needDeleteModels = [self.deleteModels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected=YES"]];
    
    [YWAlert alertWithTitle:@"提示" message:@"确认删除已选商品？" sureTitle:@"删除" cancelTitle:@"取消" sureAction:^{
        kShowHud;
        [HBShopCartModel requestDeleteCarts:needDeleteModels success:^(YWNetworkResultModel * _Nonnull obj) {
            kHideHud;
            
            if ([obj succeeded]) {
                NSMutableArray<HBShopCartModel *> *tmpModels = self.models.mutableCopy;
                for (HBShopCartModel *deleteModel in needDeleteModels) {
                    [tmpModels enumerateObjectsUsingBlock:^(HBShopCartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.cart_id isEqualToString:deleteModel.cart_id]) {
                            [tmpModels removeObject:obj];
                        }
                    }];
                    [self.deleteModels enumerateObjectsUsingBlock:^(HBShopCartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.cart_id isEqualToString:deleteModel.cart_id]) {
                            [self.deleteModels removeObject:obj];
                        }
                    }];
                }
                self.models = tmpModels;
                if (self.deleteModels.count == 0) {
                    [self _editOrDoneAction];
                }
                [self.tableView reloadData];
                [self _caculateTotalMoney];
            } else {
                [self showInfoWithMessage:obj.message];
            }
        } failure:^(NSError * _Nonnull error) {
            [self showErrorWithMessage:error.localizedDescription];
            kHideHud;
        }];
    } cancelAction:nil inViewController:self];
}

- (void)_caculateTotalMoney {
    NSArray<HBShopCartModel *> *selectedModels = [self.models filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected=YES"]];
    NSString *totalMoney = [HBShopCartModel caculateTotalMoneyWithModels:selectedModels];
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"%@ KOK", totalMoney];
}

- (void)_submitCarts {
   NSArray *selectedModels = [self.models filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected=YES"]];
    if (selectedModels.count == 0) {
        [self showInfoWithMessage:@"请选择商品"];
        return;
    }
    
    NSString *cartIDs = [HBShopCartModel getParameterOfCartIDsForModels:selectedModels];
    HBConfirmOrderViewController *vc = [HBConfirmOrderViewController fromStoryboard];
    vc.cartIDs = cartIDs;
    vc.isFromCart = YES;
    kNavPush(vc);
}

#pragma mark - Setters & Getters

- (NSArray<HBShopCartModel *> *)currentModels {
    return !self.isEditing ? self.models : self.deleteModels;
}

- (void)setModels:(NSArray<HBShopCartModel *> *)models {
    _models = models;

    if (self.selectedCartIDs.count > 0) {
        [_models enumerateObjectsUsingBlock:^(HBShopCartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self.selectedCartIDs containsObject:obj.cart_id]) {
                obj.isSelected = YES;
            }
        }];
    }
    [self.tableView reloadData];
}

- (void)_updateUI {
    self.navigationItem.rightBarButtonItem.title = !_isEditing ? @"编辑" : @"完成";
    self.totalPriceContainerStackView.hidden = _isEditing;
    NSString *operationTitle = _isEditing ? @"删除" : @"结算";
    [self.operationButton setTitle:operationTitle forState:UIControlStateNormal];
    [self _updateAllButtonSelectedState];
}

@end
