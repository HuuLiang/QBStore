//
//  QBSHomeFavourites.m
//  Pods
//
//  Created by Sean Yue on 16/7/7.
//
//

#import "QBSHomeFavourites.h"
#import "QBSCommodity.h"

@implementation QBSHomeFavourites

SynthesizePropertyClassMethod(guessYouLikeInfo, QBSHomeFavoritesInfo)

@end

@implementation QBSHomeFavoritesInfo

SynthesizeContainerPropertyElementClassMethod(commodityList, QBSCommodity)

@end