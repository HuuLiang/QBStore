//
//  QBSCommodityList.m
//  Pods
//
//  Created by Sean Yue on 16/7/12.
//
//

#import "QBSCommodityList.h"

@implementation QBSCommodityList

SynthesizeContainerPropertyElementClassMethod(data, QBSCommodity)

@end

@implementation QBSCommodityListResponse

SynthesizePropertyClassMethod(columnCommodityDto, QBSCommodityList)

@end