//
//  QBSTreasureCommodity.h
//  QBStore
//
//  Created by Sean Yue on 2016/12/21.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBSJSONResponse.h"
#import "QBSCommodity.h"

@interface QBSTreasureCommodity : QBSCommodity

@property (nonatomic) NSNumber *numLimited;
@property (nonatomic) NSNumber *numParticipants;

@end

@interface QBSTreasureCommodityList : NSObject

@property (nonatomic) NSNumber *indianaId;
@property (nonatomic) NSNumber *indianaType;
@property (nonatomic) NSString *lotteryTS;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *phase;
@property (nonatomic) NSUInteger price;

@property (nonatomic,retain) NSArray<QBSTreasureCommodity *> *commodityList;

@end

@interface QBSTreasureCommodityListResponse : QBSJSONResponse

@property (nonatomic,retain) NSArray<QBSTreasureCommodityList *> *indianaList;

@end
