//
//  lhScanQCodeViewController.h
//  lhScanQCodeTest
//
//  Created by bosheng on 15/10/20.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBackBlcok) (id);//1

@interface KSScanningViewController : YJBaseViewController

//@property (nonatomic, copy) void (^backValue)(NSString *scannedStr);
/**  扫描回调  */
@property(nonatomic,copy)CallBackBlcok callBackBlock;


@end
