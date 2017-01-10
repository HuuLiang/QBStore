//
//  QBSCouponPopModel.h
//  QBStore
//
//  Created by ylz on 2016/12/21.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBSConponInfo : NSObject

@property (nonatomic) NSNumber *amount;
@property (nonatomic) NSNumber *giftPackId;
@property (nonatomic) NSString *imgUrl;
@property (nonatomic) NSString *name;

@end

@interface QBSCouponPopModel : QBSJSONResponse

@property (nonatomic,retain) QBSConponInfo *giftPackInfo;

@end
