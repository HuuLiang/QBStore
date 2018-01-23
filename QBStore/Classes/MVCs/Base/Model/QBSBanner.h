//
//  QBSBanner.h
//  Pods
//
//  Created by Sean Yue on 16/7/18.
//
//

#import <Foundation/Foundation.h>
#import "QBSJSONResponse.h"

@interface QBSBanner : NSObject

@property (nonatomic) NSNumber *bannerId;
@property (nonatomic) NSString *bannerImgUrl;
@property (nonatomic) NSNumber *bannerType; //QBSRecommendType
@property (nonatomic) NSNumber *columnType;
@property (nonatomic) NSNumber *isLeaf;
@property (nonatomic) NSNumber *relId;

@end

@interface QBSBannerResponse : QBSJSONResponse

@property (nonatomic,retain) NSArray<QBSBanner *> *bannerList;

@end