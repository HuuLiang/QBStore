//
//  QBSHomeFavourites.h
//  Pods
//
//  Created by Sean Yue on 16/7/7.
//
//

#import <Foundation/Foundation.h>
#import "QBSJSONResponse.h"

@class QBSHomeFavoritesInfo;
@class QBSCommodity;

@interface QBSHomeFavourites : QBSJSONResponse

@property (nonatomic,retain) QBSHomeFavoritesInfo *guessYouLikeInfo;

@end

@interface QBSHomeFavoritesInfo : NSObject

@property (nonatomic) NSNumber *columnId;
@property (nonatomic,retain) NSArray<QBSCommodity *> *commodityList;
@property (nonatomic) NSNumber *guessId;
@property (nonatomic) NSNumber *pageCount;
@property (nonatomic) NSNumber *pageNum;

@end