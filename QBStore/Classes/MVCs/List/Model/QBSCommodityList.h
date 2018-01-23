//
//  QBSCommodityList.h
//  Pods
//
//  Created by Sean Yue on 16/7/12.
//
//

#import <Foundation/Foundation.h>
#import "QBSJSONResponse.h"
#import "QBSCommodity.h"

@interface QBSCommodityList : NSObject

@property (nonatomic,retain) NSArray<QBSCommodity *> *data;
@property (nonatomic) NSNumber *pageCount;
@property (nonatomic) NSNumber *pageNum;

@end

@interface QBSCommodityListResponse : QBSJSONResponse

@property (nonatomic,retain) QBSCommodityList *columnCommodityDto;

@end