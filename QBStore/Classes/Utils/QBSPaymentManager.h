//
//  QBSPaymentManager.h
//  QBStore
//
//  Created by Sean Yue on 2016/10/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^QBSPaymentCompletionHandler)(QBSPaymentResult paymentResult, QBSOrder *order);

@class QBSOrder;

@interface QBSPaymentManager : NSObject

DeclareSingletonMethod(sharedManager)

- (void)setup;
- (void)handleOpenURL:(NSURL *)url;
- (void)applicationWillEnterForeground:(UIApplication *)application;

- (void)payForOrder:(QBSOrder *)order withCompletionHandler:(QBSPaymentCompletionHandler)completionHandler;

@end
