//
//  QBSOrderViewController.m
//  Pods
//
//  Created by Sean Yue on 16/7/26.
//
//

#import "QBSOrderViewController.h"
#import "QBSOrderViewController+TableViewModel.h"

#import "QBSPaymentFooterView.h"
#import "QBSOrderActionBar.h"

#import "QBSCustomerServiceController.h"
#import "QBSOrderCommentViewController.h"

#import "QBSCartCommodity.h"
#import "QBSShippingAddress.h"
#import "QBSOrder.h"
#import "QBSUser.h"
#import "QBSOrderCommodity.h"

static const CGFloat kOrderFooterViewHeight = 44;
static NSString *const kContactCustomerServiceButtonTitle = @"联系客服";
static NSString *const kCommentButtonTitle = @"立即评价";
static NSString *const kConfirmDeliveryButtonTitle = @"确认收货";

@interface QBSOrderViewController () <QBSOrderActionBarDelegate,QBSOrderActionBarDataSource>
{
    UITableView *_layoutTV;
    QBSPaymentFooterView *_footerView;
    
    QBSOrderActionBar *_actionBar;
}
@property (nonatomic,retain,readonly) NSArray<QBSCartCommodity *> *cartCommodities;
@end

@implementation QBSOrderViewController

- (instancetype)initWithCartCommodities:(NSArray<QBSCartCommodity *> *)cartCommodities {
    self = [super init];
    if (self) {
        _cartCommodities = [cartCommodities bk_select:^BOOL(QBSCartCommodity *obj) {
            return obj.isSelected.boolValue;
        }];
    }
    return self;
}

- (instancetype)initWithOrderId:(NSString *)orderId isRecreatingOrder:(BOOL)isRecreatingOrder {
    self = [super init];
    if (self) {
        _order = [[QBSOrder alloc] init];
        _order.orderNo = orderId;
        _isRecreatingOrder = isRecreatingOrder;
        [self observeOrderStatusChange];
    }
    return self;
}

- (void)dealloc {
    [self stopObservingOrderStatusChange];
}

- (void)observeOrderStatusChange {
    [_order addObserver:self forKeyPath:NSStringFromSelector(@selector(status)) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)stopObservingOrderStatusChange {
    [self.order removeObserver:self forKeyPath:NSStringFromSelector(@selector(status))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(status))]) {
        NSString *oldStatus = [change objectForKey:NSKeyValueChangeOldKey];
        NSString *newStatus = [change objectForKey:NSKeyValueChangeNewKey];
        if (!QBSCompareObject(oldStatus, newStatus)) {
            SafelyCallBlock(self.statusUpdateAction, newStatus);
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = !self.isRecreatingOrder && [self.order isPlaced] ? @"订单详情":@"确认订单";
    self.selectedPayType = kQBSOrderPayTypeWeChat;

    _layoutTV = [[UITableView alloc] init];
    [self initTableView:_layoutTV];
    [self.view addSubview:_layoutTV];
    {
        [_layoutTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(kOrderFooterViewHeight);
        }];
    }
    
    if (_isRecreatingOrder) {
        [self reloadOrder];
    } else if ([self.order isPlaced]) {
        @weakify(self);
        [_layoutTV QBS_addPullToRefreshWithHandler:^{
            @strongify(self);
            [self reloadOrder];
        }];
        [_layoutTV QBS_triggerPullToRefresh];
    } else {
        [self updateFooterView];
        [self loadDefaultAddress];
    }
}

- (NSArray *)commodities {
    if (self.cartCommodities) {
        return self.cartCommodities;
    }
    return self.order.orderCommoditys;
}

- (void)updateFooterView {
    if ([self canSelectPaymentType]) {
        if (_actionBar) {
            [_actionBar removeFromSuperview];
            _actionBar = nil;
        }
        
        if (!_footerView) {
            _footerView = [[QBSPaymentFooterView alloc] initWithPaymentTitle:nil allowsSelection:NO];
            [self.view addSubview:_footerView];
            {
                [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.equalTo(self.view);
                    make.height.mas_equalTo(kOrderFooterViewHeight);
                }];
                
                [_layoutTV mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view).offset(-kOrderFooterViewHeight);
                }];
            }
            
            @weakify(self);
            _footerView.paymentAction = ^(id obj) {
                @strongify(self);
                [self onPayment];
            };
        }
        
        __block CGFloat totalPrice = 0;
        __block CGFloat originalTotalPrice = 0;
        __block NSUInteger amount = 0;
        
        [self.commodities enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[QBSCartCommodity class]]) {
                QBSCartCommodity *commodity = (QBSCartCommodity *)obj;
                
                totalPrice += (commodity.currentPrice.floatValue /100 * commodity.amount.unsignedIntegerValue);
                originalTotalPrice += (commodity.originalPrice.floatValue / 100 * commodity.amount.unsignedIntegerValue);
                amount += commodity.amount.unsignedIntegerValue;
            } else if ([obj isKindOfClass:[QBSOrderCommodity class]]) {
                QBSOrderCommodity *commodity = (QBSOrderCommodity *)obj;
                
                totalPrice += (commodity.currentPrice.floatValue /100 * commodity.num.unsignedIntegerValue);
                originalTotalPrice += (commodity.originalPrice.floatValue / 100 * commodity.num.unsignedIntegerValue);
                amount += commodity.num.unsignedIntegerValue;
            }
        }];
        
        [self updateFooterViewPaymentTitle];
        [_footerView setPrice:totalPrice withOriginalPrice:originalTotalPrice andAmount:amount];
        
    } else {
        if (_footerView) {
            [_footerView removeFromSuperview];
            _footerView = nil;
        }
        
        if (!_actionBar) {
            _actionBar = [[QBSOrderActionBar alloc] init];
            _actionBar.backgroundColor = [UIColor whiteColor];
            _actionBar.delegate = self;
            _actionBar.dataSource = self;
            [self.view addSubview:_actionBar];
            {
                [_actionBar mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.equalTo(self.view);
                    make.height.mas_equalTo(kOrderFooterViewHeight);
                }];
            }
        }
        
        [_actionBar reloadButtons];
    }
}

- (void)updateFooterViewPaymentTitle {
    if (self.order.isPlaced) {
        if ([self.selectedPayType isEqualToString:kQBSOrderPayTypeCOD]) {
            _footerView.paymentTitle = @"确认";
            _footerView.showAmountInPaymentButton = NO;
        } else {
            _footerView.paymentTitle = @"支付";
            _footerView.showAmountInPaymentButton = NO;
        }
    } else {
        _footerView.paymentTitle = @"下单";
        _footerView.showAmountInPaymentButton = YES;
    }
}

- (void)setOrder:(QBSOrder *)order {
    BOOL orderStatusUpdated = !QBSCompareObject(order.status, _order.status);
    [self stopObservingOrderStatusChange];
    _order = order;
    [self observeOrderStatusChange];
    
    if (order.payType.length > 0 && ![_selectedPayType isEqualToString:order.payType]) {
        self.selectedPayType = order.payType;
    }
    
    [_layoutTV reloadData];
    
    if ([order isPlaced]) {
        @weakify(self);
        [_layoutTV QBS_addPullToRefreshWithHandler:^{
            @strongify(self);
            [self reloadOrder];
        }];
        
        self.title = @"订单详情";
    }
    
    [self updateFooterView];
    
    if (orderStatusUpdated) {
        SafelyCallBlock(self.statusUpdateAction, order.status);
    }
}

- (void)reloadOrder {
    if (self.isRecreatingOrder) {
        [self.view beginLoading];
    }
    @weakify(self);
    [[QBSRESTManager sharedManager] request_queryOrderById:self.order.orderNo
                                     withCompletionHandler:^(id obj, NSError *error)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (self.isRecreatingOrder) {
            [self.view endLoading];
        } else {
            [self->_layoutTV QBS_endPullToRefresh];
        }
        
        if (obj) {
            QBSOrder *order = [(QBSOrderResponse *)obj data];
            if (self.isRecreatingOrder) {
                self.order = [QBSOrder recreatedOrderWithOrder:order];
            } else {
                self.order = order;
            }
        } else if (self.isRecreatingOrder) {
            [[QBSHUDManager sharedManager] showError:@"无法获取到订单信息"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)loadDefaultAddress {
    @weakify(self);
    [[QBSRESTManager sharedManager] request_queryDefaultShippingAddressWithCompletionHandler:^(id obj, NSError *error) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (obj && !self.shippingAddress) {
            QBSShippingAddressResponse *resp = obj;
            self.shippingAddress = resp.data;
        }
        
        if (error) {
            error.qbsErrorMessage = [NSString stringWithFormat:@"无法获取默认地址：%@", error.qbsErrorMessage];
            QBSHandleError(error);
        }
    }];
}

- (void)onPayment {
    if ([self.order isPlaced]) {
        self.order.payType = self.selectedPayType;
        if ([self.order.payType isEqualToString:kQBSOrderPayTypeCOD]) {
            @weakify(self);
            [[QBSRESTManager sharedManager] request_modifyPaymentTypeByCODForOrder:self.order.orderNo withCompletionHandler:^(id obj, NSError *error) {
                QBSHandleError(error);
                
                @strongify(self);
                if (!self) {
                    return ;
                }
                
                if (obj) {
                    self.order.status = kQBSOrderStatusWaitDelivery;
                    [self->_layoutTV reloadData];
                    [self updateFooterView];
                }
            }];
        } else {
            [self payForOrder:self.order];
        }
        return ;
    }
    
//    if (!self.shippingAddress) {
//        [[QBSHUDManager sharedManager] showError:@"下单前必须要填写收货地址"];
//        return ;
//    }
    
    QBSOrder *order;
    if (self.isRecreatingOrder) {
        order = self.order;
    } else {
        order = [[QBSOrder alloc] init];
    }
    
#if defined(DEBUG) || defined(DEBUG_TOOL_ENABLED)
    order.totalPrice = @200;
#else
    order.totalPrice = @((NSUInteger)(_footerView.currentPrice*100));
#endif
    
    NSMutableString *commodityIds = [NSMutableString string];
    NSArray *commodities = self.cartCommodities;
    if (self.isRecreatingOrder) {
        commodities = self.order.orderCommoditys;
    }
    [commodities enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[QBSCartCommodity class]]) {
            QBSCartCommodity *commodity = (QBSCartCommodity *)obj;
            
            if (commodity.commodityId && commodity.amount.unsignedIntegerValue > 0) {
                [commodityIds appendFormat:@"%@-%@|", commodity.commodityId, commodity.amount];
            }
        } else if ([obj isKindOfClass:[QBSOrderCommodity class]]) {
            QBSOrderCommodity *commodity = (QBSOrderCommodity *)obj;
            
            if (commodity.commodityId && commodity.num.unsignedIntegerValue > 0) {
                [commodityIds appendFormat:@"%@-%@|", commodity.commodityId, commodity.num];
            }
        }
    }];
    if ([commodityIds hasSuffix:@"|"]) {
        [commodityIds deleteCharactersInRange:NSMakeRange(commodityIds.length-1, 1)];
    }
    order.commodityIds = commodityIds;
    order.userId = [QBSUser currentUser].userId;
    order.payType = self.selectedPayType;
    
    if (self.shippingAddress) {
        order.addressInfo = self.shippingAddress.fullAddress;
        order.receiverUsername = self.shippingAddress.name;
        order.mobile = self.shippingAddress.mobile;
    }
    
    if (order.addressInfo.length == 0 || order.receiverUsername.length == 0 || order.mobile.length == 0) {
        [[QBSHUDManager sharedManager] showError:@"收货地址填写不完整"];
        return ;
    }

    [self createOrder:order];
}

- (void)createOrder:(QBSOrder *)order {
    @weakify(self);
    [[QBSHUDManager sharedManager] showLoading:@"下单中..."];
    [[QBSRESTManager sharedManager] request_createOrder:order withCompletionHandler:^(id obj, NSError *error) {
        QBSHandleError(error);
        @strongify(self);
        
        if (obj) {
            QBSOrderResponse *resp = obj;
            QBSOrder *createdOrder = resp.data;
            order.orderNo = createdOrder.orderNo;
            order.status = createdOrder.status;
            order.createTime = createdOrder.createTime;
            if (self) {
                self->_isRecreatingOrder = NO;
            }
            [self onSuccessfullyCreatedOrder:order];
            
        }
    }];
}

- (void)onSuccessfullyCreatedOrder:(QBSOrder *)order {
    self.order = order;
    [QBSCartCommodity removeFromPersistenceWithObjects:self.cartCommodities];
    
    if (order.payType && ![order.payType isEqualToString:kQBSOrderPayTypeCOD]) {
        [self payForOrder:order];
    }
}

- (void)payForOrder:(QBSOrder *)order {
    @weakify(self);
    
    [[QBSPaymentManager sharedManager] payForOrder:order withCompletionHandler:^(QBSPaymentResult paymentResult, QBSOrder *order) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (paymentResult == QBSPaymentResultSuccess) {
            [self->_layoutTV QBS_triggerPullToRefresh];
        }
    }];
}

- (void)updateOrderToStatus:(NSString *)orderStatus {
    @weakify(self);
    
    [[QBSHUDManager sharedManager] showLoading];
    [[QBSRESTManager sharedManager] request_modifyStatusOfOrder:self.order.orderNo toStatus:orderStatus withCompletionHandler:^(id obj, NSError *error) {
        QBSHandleError(error);
        
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (obj) {
            self.order.status = orderStatus;
            [self->_layoutTV reloadData];
            [self updateFooterView];
        }
    }];
}

- (void)onConfirmDelivery {
    [self updateOrderToStatus:kQBSOrderStatusWaitComment];
//    @weakify(self);
//    
//    [[QBSHUDManager sharedManager] showLoading];
//    [[QBSRESTManager sharedManager] request_modifyStatusOfOrder:self.order.orderNo toStatus:kQBSOrderStatusWaitComment withCompletionHandler:^(id obj, NSError *error) {
//        QBSHandleError(error);
//        
//        @strongify(self);
//        if (!self) {
//            return ;
//        }
//        
//        if (obj) {
//            self.order.status = kQBSOrderStatusWaitComment;
//            [self->_layoutTV reloadData];
//            [self updateFooterView];
//        }
//    }];
}

- (void)onComment {
    @weakify(self);
    QBSOrderCommentViewController *commentVC = [[QBSOrderCommentViewController alloc] initWithOrder:self.order didCommentAction:^(id obj) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        self.order.status = kQBSOrderStatusCommented;
        [self->_layoutTV reloadData];
        [self updateFooterView];
    }];
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (BOOL)isViewControllerDependsOnUserLogin {
    return YES;
}

- (void)setShippingAddress:(QBSShippingAddress *)shippingAddress {
    _shippingAddress = shippingAddress;
    [_layoutTV reloadSections:[NSIndexSet indexSetWithIndex:QBSAddressSection] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)setSelectedPayType:(NSString *)selectedPayType {
    NSString *oldSelectedPayType = _selectedPayType;
    _selectedPayType = selectedPayType;
    
    if (![oldSelectedPayType isEqualToString:selectedPayType]) {
        [self paymentCellSetSelectedForPayType:selectedPayType];
        [self updateFooterViewPaymentTitle];
    }
}

- (UITableView *)orderTableView {
    return _layoutTV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - QBSOrderActionBarDelegate,QBSOrderActionBarDataSource

- (NSUInteger)numberOfButtons:(QBSOrderActionBar *)actionBar {
    if ([self.order.status isEqualToString:kQBSOrderStatusDelivered]
        || [self.order.status isEqualToString:kQBSOrderStatusWaitComment]) {
        return 2;
    } else {
        return 1;
    }
}

- (NSString *)actionBar:(QBSOrderActionBar *)actionBar titleAtIndex:(NSUInteger)index {
    if (index == 0) {
        return kContactCustomerServiceButtonTitle;
    } else if (index == 1) {
        return [self.order.status isEqualToString:kQBSOrderStatusDelivered] ? kConfirmDeliveryButtonTitle : kCommentButtonTitle;
    } else {
        return nil;
    }
}

- (UIImage *)actionBar:(QBSOrderActionBar *)actionBar imageAtIndex:(NSUInteger)index {
    if (index == 0) {
        return [UIImage QBS_imageWithResourcePath:@"customer_service"];
    } else if (index == 1) {
        NSString *imagePath = [self.order.status isEqualToString:kQBSOrderStatusDelivered] ? @"confirm_delivery" : @"order_comment";
        return [UIImage QBS_imageWithResourcePath:imagePath];
    } else {
        return nil;
    }
}

- (void)actionBar:(QBSOrderActionBar *)actionBar didClickButtonAtIndex:(NSUInteger)index {
    NSString *title = [actionBar buttonTitleAtIndex:index];
    if ([title isEqualToString:kContactCustomerServiceButtonTitle]) {
        QBSCustomerServiceController *csController = [[QBSCustomerServiceController alloc] init];
        [csController showInView:self.view.window];
    } else if ([title isEqualToString:kConfirmDeliveryButtonTitle]) {
        [self onConfirmDelivery];
    } else if ([title isEqualToString:kCommentButtonTitle]) {
        [self onComment];
    }
}
@end
