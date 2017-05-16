//
//  WJPayManager.h
//  Pods
//
//  Created by Sean Yue on 2016/11/28.
//
//

#import <Foundation/Foundation.h>
#import <QBPaymentDefines.h>

/**
 注意：使用无极支付前，需要在Info.plist加入FFL_APPID=com.gjlixkl.hklcc
 **/

@class QBPaymentInfo;

@interface WJPayManager : NSObject

@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *signKey;
@property (nonatomic) NSString *notifyUrl;

+ (instancetype)sharedManager;
- (void)setup;

- (void)payWithPaymentInfo:(QBPaymentInfo *)paymentInfo
         completionHandler:(QBPaymentCompletionHandler)completionHandler;
- (void)applicationWillEnterForeground:(UIApplication *)application;

@end
