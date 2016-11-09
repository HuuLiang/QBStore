//
//  QBSFeaturedCommodity.m
//  Pods
//
//  Created by Sean Yue on 16/7/8.
//
//

#import "QBSFeaturedCommodity.h"
#import "QBSCommodity.h"
#import "QBSHomeGroup.h"

@implementation QBSFeaturedCommodityListResponse
SynthesizeContainerPropertyElementClassMethod(channelRecommendationList, QBSFeaturedCommodityList)
@end

@implementation QBSFeaturedCommodityList
SynthesizePropertyClassMethod(data, QBSFeaturedCommodityListData)
@end

@implementation QBSFeaturedCommodityListData
SynthesizeContainerPropertyElementClassMethod(commodityList, QBSCommodity)
SynthesizeContainerPropertyElementClassMethod(groupItemList, QBSHomeGroup)
@end

@implementation QBSFeaturedCommodityPage

SynthesizeContainerPropertyElementClassMethod(channelRecommendationList, QBSFeaturedCommodityList)

@end

@implementation QBSFeaturedCommodityResponse

SynthesizePropertyClassMethod(homeColumnCommodityRmdDto, QBSFeaturedCommodityPage)

@end
