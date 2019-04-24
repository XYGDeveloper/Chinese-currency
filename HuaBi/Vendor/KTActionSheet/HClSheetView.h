//
//  KTSheetView.h
//  
//
//  Created by hcl on 15/10/13.
//
//

#import <UIKit/UIKit.h>

@protocol KTSheetViewDelegate <NSObject>
- (void)sheetViewDidSelectIndex:(NSInteger)Index selectTitle:(NSString *)title;
@end

@interface HClSheetView : UIView
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id<KTSheetViewDelegate> delegate;
@property (strong, nonatomic) UIColor *cellTextColor;
@property (strong, nonatomic) UIFont *cellTextFont;
@property (strong, nonatomic) NSArray *dataSource;
@end
