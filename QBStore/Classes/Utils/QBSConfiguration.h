//
//  QBSConfiguration.h
//  Pods
//
//  Created by Sean Yue on 16/7/6.
//
//

#import <Foundation/Foundation.h>

@interface QBSConfiguration : NSObject

@property (nonatomic) NSString *baseURL;
@property (nonatomic) NSString *paymentBaseURL;

@property (nonatomic,readonly) NSString *channelNo;
@property (nonatomic) NSString *RESTAppId;
@property (nonatomic) NSNumber *paymentRESTVersion;

+ (instancetype)defaultConfiguration;

@end
