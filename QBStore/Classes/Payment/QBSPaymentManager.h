//
//  QBSPaymentManager.h
//  Pods
//
//  Created by Sean Yue on 16/8/20.
//
//

#import <Foundation/Foundation.h>

@class QBSOrder;

typedef void (^QBSPaymentCompletionHandler)(QBSPaymentResult paymentResult, QBSOrder *order);

@interface QBSPaymentManager : NSObject

DeclareSingletonMethod(sharedManager)

- (void)setup;
- (void)handleOpenURL:(NSURL *)url;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)payForOrder:(QBSOrder *)order withCompletionHandler:(QBSPaymentCompletionHandler)completionHandler;

@end
