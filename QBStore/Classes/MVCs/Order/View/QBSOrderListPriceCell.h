//
//  QBSOrderListPriceCell.h
//  Pods
//
//  Created by Sean Yue on 16/8/3.
//
//

#import "QBSTableViewCell.h"

@interface QBSOrderListPriceCell : QBSTableViewCell

@property (nonatomic,copy) QBSAction paymentAction;
@property (nonatomic,copy) QBSAction commentAction;
@property (nonatomic,copy) QBSAction rebuyAction;
@property (nonatomic,copy) QBSAction confirmAction;

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice;

@end
