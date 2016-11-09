//
//  QBSCommodityDetail.m
//  Pods
//
//  Created by Sean Yue on 16/7/9.
//
//

#import "QBSCommodityDetail.h"

@implementation QBSCommodityDetail

SynthesizeContainerPropertyElementClassMethod(serviceList, QBSCommodityServiceMark)
SynthesizeContainerPropertyElementClassMethod(detailList, QBSCommodityImageInfo)
SynthesizeContainerPropertyElementClassMethod(displayList, QBSCommodityImageInfo)
SynthesizeContainerPropertyElementClassMethod(guessCommodityList, QBSCommodity)

@end

@implementation QBSCommodityServiceMark

@end

@implementation QBSCommodityImageInfo

@end

@implementation QBSCommodityDetailResponse

SynthesizePropertyClassMethod(commodityInfo, QBSCommodityDetail)

@end
