//
//  QBSPaymentFooterView.h
//  Pods
//
//  Created by Sean Yue on 16/7/23.
//
//

#import <UIKit/UIKit.h>

@interface QBSPaymentFooterView : UIView

@property (nonatomic,readonly) BOOL allowsSelection;
@property (nonatomic) NSString *paymentTitle;

@property (nonatomic) UIColor *separatorColor UI_APPEARANCE_SELECTOR;

@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL editingSelection;

@property (nonatomic,copy) QBSAction selectionChangedAction;
@property (nonatomic,copy) QBSAction deleteSelectionAction;
@property (nonatomic,copy) QBSAction paymentAction;

@property (nonatomic,readonly) CGFloat currentPrice;
@property (nonatomic,readonly) CGFloat originalPrice;
@property (nonatomic,readonly) NSUInteger amount;

@property (nonatomic) BOOL showAmountInPaymentButton;

- (instancetype)init __attribute__((unavailable("Use - initWithPaymentTitle:allowsSelection: instead!")));
- (instancetype)initWithPaymentTitle:(NSString *)paymentTitle allowsSelection:(BOOL)allowsSelection;

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice andAmount:(NSUInteger)amount;

@end
