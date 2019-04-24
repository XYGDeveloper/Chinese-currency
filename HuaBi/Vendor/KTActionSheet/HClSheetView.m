//
//  KTSheetView.m
//  
//
//  Created by hcl on 15/10/13.
//
//

#import "HClSheetView.h"
#import "HClSheetCell.h"

#define kWH ([[UIScreen mainScreen] bounds].size.height)
#define kWW ([[UIScreen mainScreen] bounds].size.width)


@interface HClSheetView()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *divLineHeight;

@end

@implementation HClSheetView

- (void)awakeFromNib
{
    _divLineHeight.constant = 0.5;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableView数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"HClSheetCell";
    HClSheetCell *cell= [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HClSheetCell" owner:self options:nil].lastObject;
        if (_cellTextColor) {
            cell.myLabel.textColor = _cellTextColor;
        }
    }
    cell.myLabel.text = _dataSource[indexPath.row];
    
    cell.myLabel.font = [UIFont systemFontOfSize:20];
    if (kWH == 667) {
        cell.myLabel.font = [UIFont systemFontOfSize:20];
    } else if (kWH > 667) {
        cell.myLabel.font = [UIFont systemFontOfSize:21];
    }
    
    if (_cellTextFont) {
        cell.myLabel.font = _cellTextFont;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger index = indexPath.row;
    HClSheetCell *cell = (HClSheetCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *cellTitle = cell.myLabel.text;

    if ([self.delegate respondsToSelector:@selector(sheetViewDidSelectIndex:selectTitle:)]) {
        [self.delegate sheetViewDidSelectIndex:index selectTitle:cellTitle];
    }
}


@end
