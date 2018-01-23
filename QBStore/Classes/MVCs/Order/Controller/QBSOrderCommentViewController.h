//
//  QBSOrderCommentViewController.h
//  Pods
//
//  Created by Sean Yue on 16/8/29.
//
//

#import "QBSBaseViewController.h"

@class QBSOrder;

@interface QBSOrderCommentViewController : QBSBaseViewController

@property (nonatomic,retain,readonly) QBSOrder *order;
@property (nonatomic,copy) QBSAction didCommentAction;

- (instancetype)initWithOrder:(QBSOrder *)order didCommentAction:(QBSAction)action;

@end
