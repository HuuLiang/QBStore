//
//  QBSNewShippingAddressViewController.h
//  Pods
//
//  Created by Sean Yue on 16/8/1.
//
//

#import "QBSBaseViewController.h"

@class QBSShippingAddress;

@interface QBSNewShippingAddressViewController : QBSBaseViewController

@property (nonatomic) BOOL isUpdateAddress;

- (instancetype)initWithCompletionAction:(QBSAction)completionAction;
- (instancetype)initWithAddress:(QBSShippingAddress *)address completionAction:(QBSAction)completionAction;

@end
