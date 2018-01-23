//
//  QBSFeaturedCommodity.h
//  Pods
//
//  Created by Sean Yue on 16/7/8.
//
//

#import <Foundation/Foundation.h>
#import "QBSJSONResponse.h"
#import "QBSCommodity.h"

typedef NS_ENUM(NSUInteger, QBSFeaturedType) {
    QBSFeaturedTypeUnspecified,
    QBSFeaturedTypeGroup,
    QBSFeaturedTypePromotion,
    QBSFeaturedTypeRecommendationColumn,
    QBSFeaturedTypeRecommendationCommodity
};

@class QBSHomeGroup;

@interface QBSFeaturedCommodityListData : QBSCommodity

@property (nonatomic) NSNumber *columnId;
@property (nonatomic) NSNumber *columnType;
@property (nonatomic) NSNumber *isLeaf;

// rmdType = QBSFeaturedTypeRecommendation
@property (nonatomic) NSNumber *columnRecommendationId;
@property (nonatomic) NSString *columnRmdImgUrl;

// rmdType = QBSFeaturedTypePromotion
@property (nonatomic) NSNumber *duration;
@property (nonatomic) NSString *nextBeginTime;
@property (nonatomic) NSNumber *promotionId;
@property (nonatomic) NSString *promotionName;

// rmdType = QBSFeaturedTypePromotion or QBSFeaturedTypeRecommendation
@property (nonatomic,retain) NSArray<QBSCommodity *> *commodityList;

// rmdType = QBSFeaturedTypeGroup
@property (nonatomic) NSNumber *groupId;
@property (nonatomic,retain) NSArray<QBSHomeGroup *> *groupItemList;

@end

@interface QBSFeaturedCommodityList : NSObject
@property (nonatomic) NSNumber *rmdType;
@property (nonatomic) NSNumber *relId;
@property (nonatomic,retain) QBSFeaturedCommodityListData *data;
@end

@interface QBSFeaturedCommodityListResponse : QBSJSONResponse

@property (nonatomic,retain) NSArray<QBSFeaturedCommodityList *> *channelRecommendationList;

@end

@interface QBSFeaturedCommodityPage : NSObject

@property (nonatomic,retain) NSArray<QBSFeaturedCommodityList *> *channelRecommendationList;
@property (nonatomic) NSNumber *pageCount;

@end

@interface QBSFeaturedCommodityResponse : QBSJSONResponse

@property (nonatomic,retain) QBSFeaturedCommodityPage *homeColumnCommodityRmdDto;

@end
