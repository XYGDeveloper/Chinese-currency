

#import <UIKit/UIKit.h>

@protocol PaymentMethodViewDelegate <NSObject>

/*
 * 选中支付方式
 */
- (void)PaymentMethodViewCheckPayMentAction:(UIButton *)paymentBtn;

@end

@interface PaymentMethodView : UIView

@property (nonatomic, weak) id<PaymentMethodViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame qrcode:(NSString *)qrcode;

@end
