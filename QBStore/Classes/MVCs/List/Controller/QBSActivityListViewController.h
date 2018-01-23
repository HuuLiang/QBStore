//
//  QBSActivityListViewController.h
//  Pods
//
//  Created by Sean Yue on 16/7/19.
//
//

#import "QBSBaseViewController.h"

@class QBSFeaturedCommodityList;

@interface QBSActivityListViewController : QBSBaseViewController

//@property (nonatomic,readonly) NSNumber *columnId;
//@property (nonatomic,readonly) QBSColumnType columnType;
//@property (nonatomic,readonly) NSString *columnName;
@property (nonatomic,retain,readonly) NSArray<QBSFeaturedCommodityList *> *activityList;
@property (nonatomic,retain,readonly) QBSFeaturedCommodityList *currentActivity;
@property (nonatomic) NSUInteger duration;

- (instancetype)init __attribute__((unavailable("Use - initWithActivityList:currentActivity:duration: instead")));
//- (instancetype)initWithColumnId:(NSNumber *)columnId columnType:(QBSColumnType)columnType columnName:(NSString *)columnName;
- (instancetype)initWithActivityList:(NSArray<QBSFeaturedCommodityList *> *)activityList
                     currentActivity:(QBSFeaturedCommodityList *)currentActivity
                            duration:(NSUInteger)duration;

@end
