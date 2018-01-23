//
//  QBSOrderViewController+TableViewModel.h
//  Pods
//
//  Created by Sean Yue on 16/8/25.
//
//

#import "QBSOrderViewController.h"

typedef NS_ENUM(NSUInteger, QBSOrderSection) {
    QBSTitleSection,
    QBSAddressSection,
    QBSCommodityListSection,
    QBSExtraSection,
    QBSPaymentSection,
    QBSDeliverySection,
    QBSOrderSectionCount
};

@interface QBSOrderViewController (TableViewModel) <UITableViewDelegate,UITableViewDataSource>

- (void)initTableView:(UITableView *)tableView;
- (BOOL)canSelectPaymentType;

- (void)paymentCellSetSelectedForPayType:(NSString *)payType;

@end
