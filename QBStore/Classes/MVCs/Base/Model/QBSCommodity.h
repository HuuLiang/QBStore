//
//  QBSCommodity.h
//  Pods
//
//  Created by Sean Yue on 16/7/7.
//
//

#import <Foundation/Foundation.h>

@interface QBSCommodity : NSObject

@property (nonatomic) NSNumber *commodityId;
@property (nonatomic) NSString *commodityName;
@property (nonatomic) NSString *commodityViceName;
@property (nonatomic) NSNumber *commoditySts;
@property (nonatomic) NSNumber *currentPrice;
@property (nonatomic) NSString *imgUrl;
@property (nonatomic) NSNumber *numSold;
@property (nonatomic) NSNumber *originalPrice;
@property (nonatomic) NSNumber *soldBase;
@property (nonatomic) NSString *tagsImgUrl;

- (void)addToCartWithColumnId:(NSNumber *)columnId completion:(void (^)(BOOL success))completionBlock;
- (BOOL)isAvailable;

@end
