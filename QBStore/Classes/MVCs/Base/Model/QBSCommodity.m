//
//  QBSCommodity.m
//  Pods
//
//  Created by Sean Yue on 16/7/7.
//
//

#import "QBSCommodity.h"
#import "QBSCartCommodity.h"
#import "QBSCommodityTag.h"

@implementation QBSCommodity

SynthesizeContainerPropertyElementClassMethod(tagsInfo, QBSCommodityTag)

- (void)addToCartWithColumnId:(NSNumber *)columnId completion:(void (^)(BOOL success))completionBlock {
    
    [QBSCartCommodity objectFromPersistenceWithPKValue:self.commodityId async:^(id obj) {
        QBSCartCommodity *commodity = obj;
        
        NSUInteger amount = 1;
        if (commodity) {
            amount = commodity.amount.unsignedIntegerValue + 1;
        }
        
        commodity = [[QBSCartCommodity alloc] initFromCommodity:self withAmount:amount columnId:columnId];
        [commodity saveWithCompletion:completionBlock];
    }];
}

- (BOOL)isAvailable {
    return self.commoditySts.unsignedIntegerValue == 1;
}

- (NSNumber *)currentPrice {
    if (_activityPrice) {
        return _activityPrice;
    }
    
    return _currentPrice;
}
@end
