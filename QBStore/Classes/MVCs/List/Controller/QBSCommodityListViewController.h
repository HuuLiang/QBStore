//
//  QBSCommodityListViewController.h
//  Pods
//
//  Created by Sean Yue on 16/7/6.
//
//

#import "QBSBaseViewController.h"

@interface QBSCommodityListViewController : QBSBaseViewController

@property (nonatomic,readonly) NSNumber *columnId;
@property (nonatomic,readonly) QBSColumnType columnType;
@property (nonatomic,readonly) NSString *columnName;

- (instancetype)init __attribute__((unavailable("Use - initWithColumnId:columnType:columnName: instead")));
- (instancetype)initWithColumnId:(NSNumber *)columnId columnType:(QBSColumnType)columnType columnName:(NSString *)columnName;

@end
