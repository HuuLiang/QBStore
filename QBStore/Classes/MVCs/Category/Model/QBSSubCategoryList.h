//
//  QBSSubCategoryList.h
//  Pods
//
//  Created by Sean Yue on 16/7/18.
//
//

#import <Foundation/Foundation.h>
#import "QBSJSONResponse.h"

@class QBSBanner;
@class QBSCategory;

@interface QBSSubCategoryList : NSObject

@property (nonatomic,retain) NSArray<QBSBanner *> *bannerList;
@property (nonatomic,retain) NSArray<QBSCategory *> *data;
@property (nonatomic) NSNumber *pageCount;
@property (nonatomic) NSNumber *pageNum;

@end

@interface QBSSubCategoryListResponse : QBSJSONResponse

@property (nonatomic,retain) QBSSubCategoryList *columnCommodityDto;

@end