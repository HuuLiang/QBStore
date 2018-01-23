//
//  QBSCommodityDetail.h
//  Pods
//
//  Created by Sean Yue on 16/7/9.
//
//

#import <Foundation/Foundation.h>
#import "QBSJSONResponse.h"
#import "QBSCommodity.h"
#import "QBSCommodityTag.h"

@class QBSCommodityServiceMark;
@class QBSCommodityImageInfo;

@interface QBSCommodityDetail : QBSCommodity

@property (nonatomic) NSArray<QBSCommodityServiceMark *> *serviceList;

@property (nonatomic,retain) NSArray<QBSCommodityImageInfo *> *detailList;
@property (nonatomic,retain) NSArray<QBSCommodityImageInfo *> *displayList;
@property (nonatomic,retain) NSArray<QBSCommodity *> *guessCommodityList;

@end

@interface QBSCommodityServiceMark : NSObject
@property (nonatomic) NSString *imgUrl;
@property (nonatomic) NSString *serviceName;
@end

@interface QBSCommodityImageInfo : NSObject
@property (nonatomic) NSString *imgUrl;
@end

@interface QBSCommodityDetailResponse : QBSJSONResponse

@property (nonatomic,retain) QBSCommodityDetail *commodityInfo;

@end
