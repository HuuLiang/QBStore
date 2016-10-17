//
//  QBSCategoryList.m
//  Pods
//
//  Created by Sean Yue on 16/7/11.
//
//

#import "QBSCategoryList.h"

@implementation QBSCategoryList

SynthesizeContainerPropertyElementClassMethod(columnList, QBSCategory)
//SynthesizeContainerPropertyElementClassMethod(tagsRmdForYouList, QBSCategoryTag)

@end

@implementation QBSCategoryListResponse

SynthesizePropertyClassMethod(channelDto, QBSCategoryList)

@end