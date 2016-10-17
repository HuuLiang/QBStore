//
//  QBSCommodityDetailCommentViewController.h
//  Pods
//
//  Created by Sean Yue on 16/7/11.
//
//

#import "QBSBaseViewController.h"

@interface QBSCommodityDetailCommentViewController : QBSBaseViewController <QBSDynamicContentHeightDelegate>

@property (nonatomic,readonly) NSNumber *commodityId;
@property (nonatomic,readonly) CGFloat contentHeight;
@property (nonatomic,copy) QBSAction contentHeightChangedAction;

@property (nonatomic) BOOL shouldReloadData;

- (instancetype)init __attribute__((unavailable("Use -initWithCommodityId: instead!")));
- (instancetype)initWithCommodityId:(NSNumber *)commodityId;

@end
