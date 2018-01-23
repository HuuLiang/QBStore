//
//  QBSCommodityDetailSubViewController.h
//  Pods
//
//  Created by Sean Yue on 16/7/18.
//
//

#import "QBSBaseViewController.h"

@class QBSCommodityDetail;

@interface QBSCommodityDetailSubViewController : QBSBaseViewController <QBSDynamicContentHeightDelegate>

@property (nonatomic,readonly) NSNumber *commodityId;
@property (nonatomic,retain) QBSCommodityDetail *commodityDetail;
@property (nonatomic,readonly) CGFloat contentHeight;
@property (nonatomic,copy) QBSAction contentHeightChangedAction;

- (instancetype)init __attribute__((unavailable("Use initWithCommodityId: instead!")));
- (instancetype)initWithCommodityId:(NSNumber *)commodityId;

@end
