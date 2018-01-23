//
//  QBSCartCommodity.h
//  Pods
//
//  Created by Sean Yue on 16/7/26.
//
//

#import "DBPersistence.h"

@class QBSCommodity;

@interface QBSCartCommodity : DBPersistence

@property (nonatomic) NSNumber *commodityId;
@property (nonatomic) NSString *commodityName;
@property (nonatomic) NSString *commodityViceName;
@property (nonatomic) NSNumber *columnId;
@property (nonatomic) NSString *imgUrl;
@property (nonatomic) NSNumber *currentPrice;
@property (nonatomic) NSNumber *originalPrice;
@property (nonatomic) NSNumber *amount;
@property (nonatomic) NSNumber *isAvailable;
@property (nonatomic) NSNumber *isSelected;

+ (void)totalSelectedAmountAsync:(void (^)(NSUInteger amount))asyncBlock;
+ (void)totalAmountAsync:(void (^)(NSUInteger amount))asyncBlock;

- (instancetype)initFromCommodity:(QBSCommodity *)commodity withAmount:(NSUInteger)amount columnId:(NSNumber *)columnId;

@end
