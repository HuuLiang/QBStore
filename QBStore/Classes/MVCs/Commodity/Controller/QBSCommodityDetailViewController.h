//
//  QBSCommodityDetailViewController.h
//  Pods
//
//  Created by Sean Yue on 16/7/8.
//
//

#import "QBSBaseViewController.h"

@class QBSCommodity;

@interface QBSCommodityDetailViewController : QBSBaseViewController

@property (nonatomic,readonly) NSNumber *commodityId;
@property (nonatomic,readonly) NSNumber *columnId;

- (instancetype)init __attribute__((unavailable("Use -initWithCommodityId:columnId: instead")));
- (instancetype)initWithCommodityId:(NSNumber *)commodityId columnId:(NSNumber *)columnId;

@end
