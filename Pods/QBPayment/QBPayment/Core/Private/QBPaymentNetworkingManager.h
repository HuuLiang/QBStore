//
//  QBPaymentNetworkingManager.h
//  Pods
//
//  Created by Sean Yue on 2017/6/2.
//
//

#import <Foundation/Foundation.h>
#import "QBPaymentDefines.h"

@interface QBPaymentNetworkingManager : NSObject

@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *channelNo;
@property (nonatomic) NSNumber *pv;

QBDeclareSingletonMethod(defaultManager)

- (void)request_commitPaymentInfo:(QBPaymentInfo *)paymentInfo withCompletionHandler:(QBCompletionHandler)completionHandler;
- (void)request_fetchPaymentConfigurationWithURLString:(NSString *)urlString completionHandler:(QBCompletionHandler)completionHandler;

- (void)request_queryOrders:(NSString *)orders withCompletionHandler:(QBCompletionHandler)completionHandler;

@end

FOUNDATION_EXTERN NSString *const kQBPaymentConfigurationProducationURL;
FOUNDATION_EXTERN NSString *const kQBPaymentConfigurationTestURL;
