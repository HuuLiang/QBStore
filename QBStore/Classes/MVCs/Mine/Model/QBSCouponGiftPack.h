//
//  QBSCouponGiftPack.h
//  QBStore
//
//  Created by ylz on 2016/12/21.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSJSONResponse.h"

@interface QBSCouponGiftInfo : NSObject

@property (nonatomic) NSNumber *amount;
@property (nonatomic) NSString *beginDate;
@property (nonatomic) NSString *endDate;
@property (nonatomic) NSNumber *couponId;
//@property (nonatomic) NSString *expiredImgUrl;
@property (nonatomic) NSNumber *minimalExpense;//满多少可用
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *sts;//优惠价状态


@end

@interface QBSCouponGiftPack : QBSJSONResponse

@property (nonatomic,retain) NSArray<QBSCouponGiftInfo *> *couponList;

@end
