//
//  QBSOrderListViewController.m
//  Pods
//
//  Created by Sean Yue on 16/8/3.
//
//

#import "QBSOrderListViewController.h"
#import "QBSTableHeaderFooterView.h"
#import "QBSSubtitledTableViewCell.h"
#import "QBSOrderCommodityListCell.h"
#import "QBSOrderListPriceCell.h"

#import "QBSCartCommodity.h"
#import "QBSOrder.h"
#import "QBSOrderCommodity.h"
#import "QBSUser.h"

#import "QBSOrderViewController.h"
#import "QBSOrderCommentViewController.h"
#import "QBSPlaceholderView.h"

static NSString *const kOrderHeaderReusableIdentifier = @"OrderHeaderReusableIdentifier";
static NSString *const kNormalCellReusableIdentifier = @"NormalCellReusableIdentifier";
static NSString *const kCommodityCellReusableIdentifier = @"CommodityCellReusableIdentifier";
static NSString *const kPriceCellReusableIdentifier = @"PriceCellReusableIdentifier";

typedef NS_ENUM(NSUInteger, QBSOrderListCellType) {
    QBSTitleCell,
    QBSDateCell,
    QBSCommodityCell,
    QBSPriceCell,
    QBSOrderListCellCount
};

@interface QBSOrderListViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTV;
}
@property (nonatomic,retain) NSMutableArray<QBSOrder *> *orders;
@property (nonatomic) NSUInteger currentPage;
@end

@implementation QBSOrderListViewController

DefineLazyPropertyInitialization(NSMutableArray, orders)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单记录";
    
    _layoutTV = [[UITableView alloc] init];
    _layoutTV.backgroundColor = self.view.backgroundColor;
    _layoutTV.delegate = self;
    _layoutTV.dataSource = self;
    _layoutTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_layoutTV registerClass:[QBSTableHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kOrderHeaderReusableIdentifier];
    [_layoutTV registerClass:[QBSSubtitledTableViewCell class] forCellReuseIdentifier:kNormalCellReusableIdentifier];
    [_layoutTV registerClass:[QBSOrderCommodityListCell class] forCellReuseIdentifier:kCommodityCellReusableIdentifier];
    [_layoutTV registerClass:[QBSOrderListPriceCell class] forCellReuseIdentifier:kPriceCellReusableIdentifier];
    [self.view addSubview:_layoutTV];
    {
        [_layoutTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutTV QBS_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadOrdersInPage:1];
    }];
    [_layoutTV QBS_addPagingRefreshWithHandler:^{
        @strongify(self);
        [self loadOrdersInPage:self.currentPage+1];
    }];
    [_layoutTV QBS_triggerPullToRefresh];
}

- (BOOL)isViewControllerDependsOnUserLogin {
    return YES;
}

- (void)loadOrdersInPage:(NSUInteger)page {
    @weakify(self);
    [[QBSRESTManager sharedManager] request_queryOrdersInPage:page withCompletionHandler:^(id obj, NSError *error) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutTV QBS_endPullToRefresh];
        
        if (obj) {
            if (page == 1) {
                [self.orders removeAllObjects];
            }
            
            QBSOrderList *orderList = obj;
            self.currentPage = orderList.paginator.page.unsignedIntegerValue;
            
            if (orderList.data) {
                [self.orders addObjectsFromArray:orderList.data];
                [self->_layoutTV reloadData];
            }
            
            if (self.currentPage == orderList.paginator.pages.unsignedIntegerValue) {
                [self->_layoutTV QBS_pagingRefreshNoMoreData];
            }
        } else {
            QBSHandleError(error);
        }
        
        if (self.orders.count == 0) {
            if (obj) {
                [QBSPlaceholderView showPlaceholderForView:self.view withImage:[UIImage imageNamed:@""] title:@"亲，您还未下过单哦~~~" buttonTitle:nil buttonAction:nil];
            } else {
                
            }
        } else {
            [[QBSPlaceholderView placeholderForView:self.view] hide];
        }
    }];
}

- (void)payOrder:(QBSOrder *)order withPayType:(NSString *)payType {
    order.payType = payType;
    order.userId = [QBSUser currentUser].userId;
    
    @weakify(self);
    void (^ReloadSection)(QBSOrder *reloadedOrder) = ^(QBSOrder *reloadedOrder) {
        @strongify(self);
        [self reloadTableViewForOrder:order.orderNo withStatus:kQBSOrderStatusWaitDelivery];
    };
    
    if ([payType isEqualToString:kQBSOrderPayTypeAlipay]
        || [payType isEqualToString:kQBSOrderPayTypeWeChat]) {
        [[QBSPaymentManager sharedManager] payForOrder:order
                                 withCompletionHandler:^(QBSPaymentResult paymentResult, QBSOrder *payOrder)
         {
             @strongify(self);
             if (!self) {
                 return ;
             }
             
             if (paymentResult == QBSPaymentResultSuccess) {
                 ReloadSection(payOrder);
             }
         }];
    } else if ([payType isEqualToString:kQBSOrderPayTypeCOD]) {
        [[QBSHUDManager sharedManager] showLoading];
        [[QBSRESTManager sharedManager] request_modifyPaymentTypeByCODForOrder:order.orderNo
                                                         withCompletionHandler:^(id obj, NSError *error)
        {
            QBSHandleError(error);
            
            if (obj) {
                ReloadSection(order);
            }
        }];
    }
    
}

- (void)reloadTableViewForOrder:(NSString *)orderId withStatus:(NSString *)status {
    QBSOrder *paidOrder = [self.orders bk_match:^BOOL(id obj) {
        return [obj orderNo] && [[obj orderNo] isEqualToString:orderId];
    }];
    paidOrder.status = status;
    
    NSUInteger index = [self.orders indexOfObject:paidOrder];
    if (index != NSNotFound) {
        [self->_layoutTV reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orders.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return QBSOrderListCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QBSOrder *order;
    if (indexPath.section < self.orders.count) {
        order = self.orders[indexPath.section];
    }
    
    if (indexPath.row == QBSTitleCell || indexPath.row == QBSDateCell) {
        QBSSubtitledTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNormalCellReusableIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showSeparator = YES;
        
        cell.title = indexPath.row == QBSTitleCell ? [NSString stringWithFormat:@"订单编号：%@", order.orderNo] : @"下单时间：";
        cell.subtitle = indexPath.row == QBSTitleCell ? order.statusString : order.createTime;
        
        cell.subtitleColor = indexPath.row == QBSTitleCell ? [UIColor colorWithHexString:@"#FF206F"] : nil;
//        QBSOrderListTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kTitleCellReusableIdentifier forIndexPath:indexPath];
//        cell.orderId = order.orderNo;
//        cell.orderStatus = order.statusString;
#ifdef DEBUG_TOOL_ENABLED
        if (indexPath.row == QBSTitleCell) {
            @weakify(self);
            cell.longPressAction = ^(id obj) {
                @strongify(self);
                [QBSUIHelper showOrderDebugPanelInViewController:self withOrder:order updateAction:^(id obj) {
                    @strongify(self);
                    [self->_layoutTV reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                }];
            };
        } else {
            cell.longPressAction = nil;
        }
#endif
        return cell;
    } else if (indexPath.row == QBSCommodityCell) {
        QBSOrderCommodityListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommodityCellReusableIdentifier forIndexPath:indexPath];
        cell.showSeparator = YES;
        
        cell.imageURLStrings = [order.orderCommoditys bk_map:^id(QBSOrderCommodity *obj) {
            return obj.imgUrl;
        }];
        
        cell.amount = [order.orderCommoditys QBS_sumInteger:^NSInteger(QBSOrderCommodity *obj) {
            return obj.num.unsignedIntegerValue;
        }];
        
        @weakify(self);
        cell.commodityAction = ^(id obj) {
            @strongify(self);
            [self tableView:self->_layoutTV didSelectRowAtIndexPath:indexPath];
        };
        return cell;
    } else if (indexPath.row == QBSPriceCell) {
        QBSOrderListPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:kPriceCellReusableIdentifier forIndexPath:indexPath];
        
        [cell setPrice:[order.orderCommoditys QBS_sumFloat:^CGFloat(QBSOrderCommodity *obj) {
            return obj.currentPrice.unsignedIntegerValue * obj.num.unsignedIntegerValue / 100.;
        }] withOriginalPrice:[order.orderCommoditys QBS_sumFloat:^CGFloat(QBSOrderCommodity *obj) {
            return obj.originalPrice.unsignedIntegerValue * obj.num.unsignedIntegerValue / 100.;
        }]];
        
        @weakify(self);
        if ([order.status isEqualToString:kQBSOrderStatusWaitPay]) {
            cell.paymentAction = ^(id obj) {
                [QBSUIHelper showPaymentSheetWithAction:^(id obj) {
                    @strongify(self);
                    [self payOrder:order withPayType:obj];
                }];
            };
        } else {
            cell.paymentAction = nil;
        }
        
        cell.confirmAction = nil;
        cell.rebuyAction = nil;
        cell.commentAction = nil;
        
        if ([order.status isEqualToString:kQBSOrderStatusDelivered]) {
            cell.confirmAction = ^(id obj) {
                [[QBSHUDManager sharedManager] showLoading];
                [[QBSRESTManager sharedManager] request_modifyStatusOfOrder:order.orderNo
                                                                   toStatus:kQBSOrderStatusWaitComment
                                                      withCompletionHandler:^(id obj, NSError *error)
                {
                    QBSHandleError(error);
                    
                    @strongify(self);
                    if (obj) {
                        [self reloadTableViewForOrder:order.orderNo withStatus:kQBSOrderStatusWaitComment];
                    }
                }];
            };
        } else if ([order.status isEqualToString:kQBSOrderStatusWaitComment]) {
            cell.commentAction = ^(id obj) {
                QBSOrderCommentViewController *commentVC = [[QBSOrderCommentViewController alloc] initWithOrder:order didCommentAction:^(id obj) {
                    @strongify(self);
                    [self reloadTableViewForOrder:order.orderNo withStatus:kQBSOrderStatusCommented];
                }];
                [self.navigationController pushViewController:commentVC animated:YES];
            };
        }
        
        if ([order.status isEqualToString:kQBSOrderStatusWaitComment]
            || [order.status isEqualToString:kQBSOrderStatusCommented]
            || [order.status isEqualToString:kQBSOrderStatusClosed]) {
            cell.rebuyAction = ^(id obj) {
                QBSOrderViewController *orderVC = [[QBSOrderViewController alloc] initWithOrderId:order.orderNo isRecreatingOrder:YES];
                [self.navigationController pushViewController:orderVC animated:YES];
            };
        }
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QBSTableHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kOrderHeaderReusableIdentifier];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    const CGFloat fullHeight = CGRectGetHeight(tableView.bounds);
    
    if (indexPath.row == QBSTitleCell || indexPath.row == QBSDateCell) {
        return MAX(fullHeight * 0.05, 28);
    } else if (indexPath.row == QBSCommodityCell) {
        return MAX(fullHeight * 0.117, 66);
    } else if (indexPath.row == QBSPriceCell) {
        return MAX(fullHeight * 0.067, 35);
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.orders.count) {
        QBSOrder *order = self.orders[indexPath.section];
        if (order.orderNo.length > 0) {
            QBSOrderViewController *orderVC = [[QBSOrderViewController alloc] initWithOrderId:order.orderNo isRecreatingOrder:NO];
            @weakify(self);
            orderVC.statusUpdateAction = ^(id obj) {
                @strongify(self);
                [self reloadTableViewForOrder:order.orderNo withStatus:obj];
            };
            [self.navigationController pushViewController:orderVC animated:YES];
        }
    }
}

@end
