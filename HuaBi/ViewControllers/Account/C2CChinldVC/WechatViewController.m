//
//  WechatViewController.m
//  YJOTC
//
//  Created by l on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "WechatViewController.h"
#import "AlipayTableViewCell.h"
#import "PayModel.h"
@interface WechatViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *list;
@property (nonatomic,strong)PayModel *model;
@end

@implementation WechatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self lodata];
    self.view.backgroundColor = kRGBA(244, 244, 244, 1);
    [self.tableview registerNib:[UINib nibWithNibName:@"AlipayTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([AlipayTableViewCell class])];
    
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
            self.list = self.model.wechat.mutableCopy;
            [self.tableview reloadData];
        }else{
            [weakSelf showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlipayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AlipayTableViewCell class])];
    WechatModel *model = [self.list objectAtIndex:indexPath.section];
    [cell refreshWithWechatmodel:model];
    cell.del = ^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"key"] = kUserInfo.token;
        param[@"id"] = model.id;
        param[@"type"] = @"3";
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
        param[@"type"] = @"3";
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 5;
    }else{
        return 5;
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
