//
//  QBSCategoryList.h
//  Pods
//
//  Created by Sean Yue on 16/7/11.
//
//

#import <Foundation/Foundation.h>
#import "QBSJSONResponse.h"
#import "QBSCategory.h"
#import "QBSCategoryTag.h"

@interface QBSCategoryList : NSObject

@property (nonatomic,retain) NSArray<QBSCategory *> *columnList;
//@property (nonatomic,retain) NSArray<QBSCategoryTag *> *tagsRmdForYouList;

@end

@interface QBSCategoryListResponse : QBSJSONResponse

@property (nonatomic,retain) QBSCategoryList *channelDto;

@end