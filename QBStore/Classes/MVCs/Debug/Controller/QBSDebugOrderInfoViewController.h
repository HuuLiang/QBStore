//
//  QBSDebugOrderInfoViewController.h
//  Pods
//
//  Created by Sean Yue on 16/8/29.
//
//

#import "QBSBaseViewController.h"

@class QBSOrder;

@interface QBSDebugOrderInfoViewController : QBSBaseViewController

@property (nonatomic,retain,readonly) QBSOrder *order;
@property (nonatomic,copy) QBSAction orderUpdateAction;

- (instancetype)initWithOrder:(QBSOrder *)order;

@end
