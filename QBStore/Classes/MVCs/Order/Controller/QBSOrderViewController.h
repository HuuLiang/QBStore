//
//  QBSOrderViewController.h
//  Pods
//
//  Created by Sean Yue on 16/7/26.
//
//

#import "QBSBaseViewController.h"

@class QBSCartCommodity;
@class QBSOrder;
@class QBSShippingAddress;

@interface QBSOrderViewController : QBSBaseViewController

@property (nonatomic,retain,readonly) NSArray *commodities;
@property (nonatomic,readonly) BOOL isRecreatingOrder;
@property (nonatomic,retain) QBSOrder *order;
@property (nonatomic,retain) QBSShippingAddress *shippingAddress;
@property (nonatomic) NSString *selectedPayType;
@property (nonatomic,copy) QBSAction statusUpdateAction;

- (instancetype)init __attribute__((unavailable("Use -initWithCartCommodities: or -initWithOrderId:isRecreatingOrder: instead")));
- (instancetype)initWithCartCommodities:(NSArray<QBSCartCommodity *> *)cartCommodities;
- (instancetype)initWithOrderId:(NSString *)orderId isRecreatingOrder:(BOOL)isRecreatingOrder;

- (UITableView *)orderTableView;

@end
