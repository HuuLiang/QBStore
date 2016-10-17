//
//  QBSCommodityComment.h
//  Pods
//
//  Created by Sean Yue on 16/7/17.
//
//

#import <Foundation/Foundation.h>
#import "QBSJSONResponse.h"

@interface QBSCommodityComment : NSObject

@property (nonatomic) NSString *content;
@property (nonatomic) NSString *evalTime;
@property (nonatomic) NSString *mobilePhone;

@end

@interface QBSCommodityCommentList : NSObject

@property (nonatomic,retain) NSArray<QBSCommodityComment *> *evalList;
@property (nonatomic) NSNumber *pageCount;
@property (nonatomic) NSNumber *pageNum;

@end

@interface QBSCommodityCommentListResponse : QBSJSONResponse

@property (nonatomic,retain) QBSCommodityCommentList *commodityEvalDto;

@end