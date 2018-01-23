//
//  QBSCustomerService.h
//  Pods
//
//  Created by Sean Yue on 16/7/20.
//
//

#import <Foundation/Foundation.h>
#import "QBSJSONResponse.h"

@interface QBSCustomerService : NSObject

@property (nonatomic) NSString *contImgUrl;
@property (nonatomic) NSString *contName;
@property (nonatomic) NSString *contScheme;
@property (nonatomic) NSString *serviceTime;

@end

@interface QBSCustomerServiceList : QBSJSONResponse

@property (nonatomic,retain) NSArray<QBSCustomerService *> *cscidList;

+ (instancetype)sharedList;
- (void)saveAsSharedList;

@end