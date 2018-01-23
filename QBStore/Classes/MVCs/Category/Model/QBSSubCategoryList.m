//
//  QBSSubCategoryList.m
//  Pods
//
//  Created by Sean Yue on 16/7/18.
//
//

#import "QBSSubCategoryList.h"
#import "QBSBanner.h"
#import "QBSCategory.h"

@implementation QBSSubCategoryList

SynthesizeContainerPropertyElementClassMethod(bannerList, QBSBanner)
SynthesizeContainerPropertyElementClassMethod(data, QBSCategory)

@end

@implementation QBSSubCategoryListResponse

SynthesizePropertyClassMethod(columnCommodityDto, QBSSubCategoryList)

@end