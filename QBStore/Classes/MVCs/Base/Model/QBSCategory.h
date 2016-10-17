//
//  QBSCategory.h
//  Pods
//
//  Created by Sean Yue on 16/7/11.
//
//

#import <Foundation/Foundation.h>

@interface QBSCategory : NSObject

@property (nonatomic) NSNumber *columnId;
@property (nonatomic) NSString *columnImgUrl;
@property (nonatomic) NSString *columnName;
@property (nonatomic) NSNumber *columnType;
@property (nonatomic) NSNumber *isLeaf;

@end
