//
//  QBSJSONResponse.h
//  Pods
//
//  Created by Sean Yue on 16/7/7.
//
//

#import <Foundation/Foundation.h>

@class QBSPaginator;

@interface QBSJSONResponse : NSObject

@property (nonatomic) NSNumber *code;
@property (nonatomic) BOOL success;
@property (nonatomic) BOOL userShouldReLogin;

@property (nonatomic) QBSPaginator *paginator;

@end

@interface QBSPaginator : NSObject

@property (nonatomic) NSNumber *items;
@property (nonatomic) NSNumber *itemsPerPage;
@property (nonatomic) NSNumber *page;
@property (nonatomic) NSNumber *pages;

@end
