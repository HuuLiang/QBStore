//
//  QBSShippingAddressListViewController.h
//  Pods
//
//  Created by Sean Yue on 16/8/2.
//
//

#import "QBSBaseViewController.h"

@class QBSShippingAddress;
@class QBSShippingAddressListViewController;

@protocol QBSShippingAddressListViewControllerDelegate <NSObject>

@optional
- (void)shippingAddressListViewController:(QBSShippingAddressListViewController *)viewController didSelectShippingAddress:(QBSShippingAddress *)shippingAddress;

@end

@interface QBSShippingAddressListViewController : QBSBaseViewController

@property (nonatomic,weak) id<QBSShippingAddressListViewControllerDelegate> delegate;

- (instancetype)initWithDelegate:(id<QBSShippingAddressListViewControllerDelegate>)delegate;

@end
