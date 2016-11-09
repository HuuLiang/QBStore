//
//  QBSCartCommodity.m
//  Pods
//
//  Created by Sean Yue on 16/7/26.
//
//

#import "QBSCartCommodity.h"
#import "QBSCommodity.h"
#import "NSArray+Utilities.h"

@implementation QBSCartCommodity

+ (NSString *)primaryKey {
    return @"commodityId";
}

- (instancetype)initFromCommodity:(QBSCommodity *)commodity withAmount:(NSUInteger)amount columnId:(NSNumber *)columnId {
    self = [super init];
    if (self) {
        _columnId = columnId;
        _commodityId = commodity.commodityId;
        _commodityName = commodity.commodityName;
        _commodityViceName = commodity.commodityViceName;
        _imgUrl = commodity.imgUrl;
        _currentPrice = commodity.currentPrice;
        _originalPrice = commodity.originalPrice;
        _amount = @(amount);
        _isAvailable = @(commodity.commoditySts.unsignedIntegerValue==1);
        _isSelected = @(YES);
    }
    return self;
}

+ (void)totalSelectedAmountAsync:(void (^)(NSUInteger amount))asyncBlock {
    [QBSCartCommodity objectsFromPersistenceAsync:^(NSArray *objects) {
        asyncBlock([objects QBS_sumInteger:^NSInteger(QBSCartCommodity *obj) {
            if (!obj.isSelected.boolValue) {
                return 0;
            }
            
            return obj.amount.unsignedIntegerValue;
        }]);
    }];
}

+ (void)totalAmountAsync:(void (^)(NSUInteger amount))asyncBlock {
    [QBSCartCommodity objectsFromPersistenceAsync:^(NSArray *objects) {
        asyncBlock([objects QBS_sumInteger:^NSInteger(QBSCartCommodity *obj) {
            return obj.amount.unsignedIntegerValue;
        }]);
    }];
}
@end
