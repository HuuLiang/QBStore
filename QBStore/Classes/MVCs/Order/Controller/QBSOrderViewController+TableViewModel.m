//
//  QBSOrderViewController+TableViewModel.m
//  Pods
//
//  Created by Sean Yue on 16/8/25.
//
//

#import "QBSOrderViewController+TableViewModel.h"

#import "QBSSubtitledTableViewCell.h"
#import "QBSOrderAddressCell.h"
#import "QBSOrderCommodityListCell.h"
#import "QBSTableHeaderFooterView.h"
#import "QBSOrderPaymentCell.h"

#import "QBSOrder.h"
#import "QBSShippingAddress.h"
#import "QBSCartCommodity.h"
#import "QBSOrderCommodity.h"

#import "QBSOrderManifestViewController.h"
#import "QBSShippingAddressListViewController.h" 
#import "QBSNewShippingAddressViewController.h"

typedef NS_ENUM(NSUInteger, QBSPaymentType) {
    QBSPaymentTypeWeChat,
    QBSPaymentTypeAlipay,
//    QBSPaymentTypeCash,
    QBSPaymentTypeCount
};

typedef NS_ENUM(NSUInteger, QBSExtraRow) {
    QBSOrderDateRow,
    QBSOrderPaymentRow,
    QBSExtraRowCount
};

typedef NS_ENUM(NSUInteger, QBSDeliverySectionType) {
    QBSDeliveryCompany,
    QBSDeliveryNumber,
    QBSDeliverySectionCount
};

static NSString *const kSubtitledCellReusableIdentifier = @"SubtitledCellReusableIdentifier";
static NSString *const kAddressCellReusableIdentifier = @"AddressCellReusableIdentifier";
static NSString *const kCommodityListCellReusableIdentifier = @"CommodityListCellReusableIdentifier";
static NSString *const kCommodityPriceCellReusableIdentifier = @"CommodityPriceCellReusableIdentifier";
static NSString *const kHeaderViewReusableIdentifier = @"HeaderViewReusableIdentifier";
static NSString *const kPaymentCellReusableIdentifier = @"PaymentCellReusableIdentifier";

@interface QBSOrderViewController () <QBSShippingAddressListViewControllerDelegate>

@end

@implementation QBSOrderViewController (TableViewModel)

- (NSUInteger)paymentRowForPayType:(NSString *)payType {
    NSDictionary *payTypeMapping = @{kQBSOrderPayTypeWeChat:@(QBSPaymentTypeWeChat),
                                     kQBSOrderPayTypeAlipay:@(QBSPaymentTypeAlipay),
//                                     kQBSOrderPayTypeCOD:@(QBSPaymentTypeCash)
                                     };
    NSNumber *paymentType = payTypeMapping[payType];
    if (!paymentType) {
        return NSNotFound;
    }
    return paymentType.unsignedIntegerValue;
}

- (NSString *)payTypeForPaymentRow:(NSUInteger)row {
    NSDictionary *payTypeMapping = @{@(QBSPaymentTypeWeChat):kQBSOrderPayTypeWeChat,
                                     @(QBSPaymentTypeAlipay):kQBSOrderPayTypeAlipay,
//                                     @(QBSPaymentTypeCash):kQBSOrderPayTypeCOD
                                     };
    return payTypeMapping[@(row)];
}

- (void)paymentCellSetSelectedForPayType:(NSString *)payType {
    
    const NSInteger numberOfSections = [[self orderTableView] numberOfSections];
    if (QBSPaymentSection >= numberOfSections) {
        return ;
    }
    
    NSUInteger paymentRow = [self paymentRowForPayType:payType];
    if (paymentRow == NSNotFound) {
        return ;
    }
    
    
    const NSInteger paymentRows = [[self orderTableView] numberOfRowsInSection:QBSPaymentSection];
    
    for (NSUInteger i = 0; i < paymentRows; ++i) {
        QBSOrderPaymentCell *cell = [[self orderTableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:QBSPaymentSection]];
        
        cell.currentIsSelected = i == paymentRow;
    }
}

- (void)initTableView:(UITableView *)tableView {
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[QBSSubtitledTableViewCell class] forCellReuseIdentifier:kSubtitledCellReusableIdentifier];
    [tableView registerClass:[QBSOrderAddressCell class] forCellReuseIdentifier:kAddressCellReusableIdentifier];
    [tableView registerClass:[QBSOrderCommodityListCell class] forCellReuseIdentifier:kCommodityListCellReusableIdentifier];
    [tableView registerClass:[QBSTableViewCell class] forCellReuseIdentifier:kCommodityPriceCellReusableIdentifier];
    [tableView registerClass:[QBSTableHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kHeaderViewReusableIdentifier];
    [tableView registerClass:[QBSOrderPaymentCell class] forCellReuseIdentifier:kPaymentCellReusableIdentifier];
}

- (BOOL)canSelectPaymentType {
    return ![self.order isPlaced] || self.order.shouldPay;
}

- (BOOL)canEditShippingAddress {
    return ![self.order isPlaced];
}

- (void)showManifests {
    QBSOrderManifestViewController *manifestVC = [[QBSOrderManifestViewController alloc] initWithCommodities:self.commodities];
    [self.navigationController pushViewController:manifestVC animated:YES];
}

- (void)commodityListUpdatePriceLabel:(UILabel *)label {
    if (![self.order isPlaced]) {
        label.attributedText = [[NSAttributedString alloc] initWithString:@"合计：？？？" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],
                                                                                                NSFontAttributeName:kSmallFont}];
        return ;
    }
    
    __block NSInteger currentPrice = 0;
    __block NSInteger originalPrice = 0;
    
    [self.commodities enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[QBSCartCommodity class]]) {
            currentPrice += ((QBSCartCommodity *)obj).currentPrice.unsignedIntegerValue;
            originalPrice += ((QBSCartCommodity *)obj).originalPrice.unsignedIntegerValue;
        } else if ([obj isKindOfClass:[QBSOrderCommodity class]]) {
            currentPrice += ((QBSOrderCommodity *)obj).currentPrice.unsignedIntegerValue;
            originalPrice += ((QBSOrderCommodity *)obj).originalPrice.unsignedIntegerValue;
        }
    }];
    
    NSString *prefixString = @"合计：";
    NSString *priceString = [NSString stringWithFormat:@"¥ %@", QBSIntegralPrice(currentPrice/100.)];
    NSString *originalPriceString = QBSIntegralPrice(originalPrice/100.);
    
    NSString *str = [prefixString stringByAppendingString:priceString];
    if (originalPrice > 0) {
        str = [str stringByAppendingFormat:@" %@", originalPriceString];
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],
                                NSFontAttributeName:kSmallFont} range:NSMakeRange(0, prefixString.length)];
    
    [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FD472B"],
                                NSFontAttributeName:kMediumFont} range:NSMakeRange(prefixString.length, priceString.length)];
    
    if (originalPrice > 0) {
        [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],
                                    NSFontAttributeName:kSmallFont,
                                    NSStrikethroughStyleAttributeName:@1} range:NSMakeRange(str.length-originalPriceString.length, originalPriceString.length)];
    }
    
    label.attributedText = attrString;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.commodities.count == 0 ? 0 : QBSOrderSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == QBSTitleSection) {
        if ([self.order isPlaced]) {
            return 1;
        } else {
            return 0;
        }
    } else if (section == QBSPaymentSection) {
        return [self canSelectPaymentType] ? QBSPaymentTypeCount : 0;
    } else if (section == QBSExtraSection) {
        if (![self canSelectPaymentType]) {
            return QBSExtraRowCount;
        } else if ([self.order isPlaced]) {
            return 1;
        } else {
            return 0;
        }
    } else if (section == QBSDeliverySection) {
        return [self.order isDelivered] ? QBSDeliverySectionCount:0;
    } else if (section == QBSCommodityListSection) {
        return [self canSelectPaymentType] ? 1 : 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == QBSTitleSection) {
        QBSSubtitledTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSubtitledCellReusableIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showSeparator = NO;
        cell.subtitleColor = [UIColor colorWithHexString:@"#FF206F"];
        cell.title = [NSString stringWithFormat:@"订单编号：%@", self.order.orderNo];
        cell.subtitle = self.order.statusString;
        return cell;
    } else if (indexPath.section == QBSAddressSection) {
        QBSOrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressCellReusableIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = [self canEditShippingAddress] ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
        cell.placeholder = @"暂无地址，请新增配送地址";
        
        if (self.shippingAddress) {
            cell.name = self.shippingAddress.name;
            cell.phone = self.shippingAddress.mobile;
            cell.address = [self.shippingAddress fullAddress];
        } else if (self.isRecreatingOrder || [self.order isPlaced]) {
            cell.name = self.order.receiverUsername;
            cell.phone = self.order.mobile;
            cell.address = self.order.addressInfo;
        } else {
            cell.name = nil;
            cell.phone = nil;
            cell.address = nil;
        }
        
        return cell;
    } else if (indexPath.section == QBSCommodityListSection) {
        if (indexPath.row == 0) {
            QBSOrderCommodityListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommodityListCellReusableIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.showSeparator = indexPath.row + 1 < [self tableView:tableView numberOfRowsInSection:indexPath.section];
            
            NSMutableArray *imageURLStrings = [NSMutableArray array];
            [self.commodities enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[QBSCartCommodity class]]) {
                    [imageURLStrings addObject:((QBSCartCommodity *)obj).imgUrl ?: @""];
                } else if ([obj isKindOfClass:[QBSOrderCommodity class]]) {
                    [imageURLStrings addObject:((QBSOrderCommodity *)obj).imgUrl ?: @""];
                }
            }];
            
            NSUInteger amount = [self.commodities QBS_sumInteger:^NSInteger(id obj) {
                if ([obj isKindOfClass:[QBSCartCommodity class]]) {
                    return ((QBSCartCommodity *)obj).amount.unsignedIntegerValue;
                } else if ([obj isKindOfClass:[QBSOrderCommodity class]]) {
                    return ((QBSOrderCommodity *)obj).num.unsignedIntegerValue;
                }
                return 0;
            }];
            
            cell.imageURLStrings = imageURLStrings;
            cell.amount = amount;
            
            @weakify(self);
            cell.commodityAction = ^(id obj) {
                @strongify(self);
                [self showManifests];
            };
            return cell;
        } else if (indexPath.row == 1) {
            QBSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommodityPriceCellReusableIdentifier forIndexPath:indexPath];
            cell.textLabel.textAlignment = NSTextAlignmentRight;
            [self commodityListUpdatePriceLabel:cell.textLabel];
            return cell;
        }
    } else if (indexPath.section == QBSExtraSection) {
        QBSSubtitledTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSubtitledCellReusableIdentifier forIndexPath:indexPath];
        cell.subtitleColor = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row < [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
            cell.showSeparator = YES;
        } else {
            cell.showSeparator = NO;
        }
        
        if (indexPath.row == QBSOrderDateRow) {
            cell.title = @"下单时间：";
            cell.subtitle = self.order.createTime;
        } else if (indexPath.row == QBSOrderPaymentRow) {
            cell.title = @"支付方式：";
            cell.subtitle = self.order.paymentTypeString;
        }
        
        return cell;
    } else if (indexPath.section == QBSPaymentSection) {
        QBSOrderPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:kPaymentCellReusableIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.currentIsSelected = [self paymentRowForPayType:self.selectedPayType] == indexPath.row;
        
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
            cell.showSeparator = NO;
        } else {
            cell.showSeparator = YES;
            cell.separatorInsets = UIEdgeInsetsMake(0, 15, 0, 0);
            cell.separatorColor = [UIColor colorWithHexString:@"#E9E9E9"];
        }
        
        if (indexPath.row == QBSPaymentTypeWeChat) {
            cell.imageView.image = [UIImage QBS_imageWithResourcePath:@"wechat"];
            cell.textLabel.text = [QBSOrder paymentTypeStringWithPaymentType:kQBSOrderPayTypeWeChat];
        } else if (indexPath.row == QBSPaymentTypeAlipay) {
            cell.imageView.image = [UIImage QBS_imageWithResourcePath:@"alipay"];
            cell.textLabel.text = [QBSOrder paymentTypeStringWithPaymentType:kQBSOrderPayTypeAlipay];
        }
//        else if (indexPath.row == QBSPaymentTypeCash) {
//            cell.imageView.image = [UIImage QBS_imageWithResourcePath:@"cash"];
//            cell.textLabel.text = [QBSOrder paymentTypeStringWithPaymentType:kQBSOrderPayTypeCOD];
//        }
        return cell;
    } else if (indexPath.section == QBSDeliverySection) {
        QBSSubtitledTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSubtitledCellReusableIdentifier forIndexPath:indexPath];
        cell.subtitleColor = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
            cell.showSeparator = NO;
        } else {
            cell.showSeparator = YES;
        }
        
        if (indexPath.row == QBSDeliveryCompany) {
            cell.title = @"物流公司：";
            cell.subtitle = self.order.deliveryName;
        } else if (indexPath.row == QBSDeliveryNumber) {
            cell.title = @"物流单号：";
            cell.subtitle = self.order.deliveryNo;
        }
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QBSTableHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderViewReusableIdentifier];
    
    if (section == QBSPaymentSection) {
        headerView.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        headerView.textLabel.font = kSmallFont;
        headerView.textLabel.text = @"支付方式";
    } else {
        headerView.textLabel.text = nil;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == QBSTitleSection) {
        return [self.order isPlaced] ? 44 : 0;
    } else if (indexPath.section == QBSAddressSection) {
        return CGRectGetWidth(tableView.bounds)/5;
    } else if (indexPath.section == QBSCommodityListSection) {
        return indexPath.row == 0 ? CGRectGetWidth(tableView.bounds)/5 : 44;
    } else if (indexPath.section == QBSExtraSection) {
        return [self tableView:tableView numberOfRowsInSection:indexPath.section] == 0 ? 0 :44;
    } else if (indexPath.section == QBSPaymentSection) {
        return [self canSelectPaymentType] ? MAX(kScreenHeight * 0.08,44) : 0;
    } else if (indexPath.section == QBSDeliverySection) {
        return [self tableView:tableView numberOfRowsInSection:indexPath.section] == 0 ? 0 : 44;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else if (section == QBSPaymentSection) {
        return [self canSelectPaymentType] ? 30: 0;
    } else if (section == QBSExtraSection) {
        return [self tableView:tableView numberOfRowsInSection:section] == 0 ? 0 : 10;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == QBSAddressSection) {
        if (![self canEditShippingAddress]) {
            return ;
        }
        
        @weakify(self);
        if (self.shippingAddress || self.order.addressInfo) {
            QBSShippingAddressListViewController *listVC = [[QBSShippingAddressListViewController alloc] initWithDelegate:self];
            [self.navigationController pushViewController:listVC animated:YES];
        } else {
            QBSNewShippingAddressViewController *addressVC = [[QBSNewShippingAddressViewController alloc] initWithCompletionAction:^(id obj) {
                @strongify(self);
                self.shippingAddress = obj;
            }];
            [self.navigationController pushViewController:addressVC animated:YES];
        }
        
    } else if (indexPath.section == QBSCommodityListSection) {
        [self showManifests];
    } else if (indexPath.section == QBSPaymentSection) {
        if ([self canSelectPaymentType]) {
            self.selectedPayType = [self payTypeForPaymentRow:indexPath.row];
        }
    }
}

#pragma mark - QBSShippingAddressListViewControllerDelegate

- (void)shippingAddressListViewController:(QBSShippingAddressListViewController *)viewController
                 didSelectShippingAddress:(QBSShippingAddress *)shippingAddress
{
    if (!shippingAddress) {
        return ;
    }
    
    [viewController.navigationController popViewControllerAnimated:YES];
    
    self.shippingAddress = shippingAddress;
}

@end
