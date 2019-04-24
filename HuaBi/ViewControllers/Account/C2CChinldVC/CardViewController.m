//
//  CardViewController.m
//  YJOTC
//
//  Created by l on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "CardViewController.h"
#import "CardTableViewCell.h"
#import "PayModel.h"
@interface CardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *list;
@property (nonatomic,strong)PayModel *model;
@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self lodata];
    self.view.backgroundColor = kRGBA(244, 244, 244, 1);
    [self.tableview registerNib:[UINib nibWithNibName:@"CardTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CardTableViewCell class])];
}

- (void)lodata{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"key"] = kUserInfo.token;
    param[@"uuid"] = [Utilities randomUUID];
    __weak typeof(self)weakSelf = self;
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:name_paymode] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        if (success) {
            NSLog(@"%@",responseObj);
            weakSelf.list = [NSMutableArray array];
            weakSelf.model = [PayModel mj_objectWithKeyValues:[responseObj ksObjectForKey:kData]];
            self.list = self.model.yinhang.mutableCopy;
            [self.tableview reloadData];
        }else{
            [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CardTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    bankModel *model = [self.list objectAtIndex:indexPath.row];
    [cell refreshWithModel:model];
    cell.del = ^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"key"] = kUserInfo.token;
        param[@"id"] = model.id;
        param[@"type"] = @"1";
        param[@"uuid"] = [Utilities randomUUID];
        __weak typeof(self)weakSelf = self;
        
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Api/Entrust/payDel"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            if (success) {
                [self lodata];
            }else{
                [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    };
    
    cell.defau = ^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"key"] = kUserInfo.token;
        param[@"id"] = model.id;
        param[@"type"] = @"1";
        param[@"uuid"] = [Utilities randomUUID];
        __weak typeof(self)weakSelf = self;
        
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Entrust/update_payment"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            if (success) {
                [self lodata];
            }else{
                [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
            }
        }];
        
    };
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
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
