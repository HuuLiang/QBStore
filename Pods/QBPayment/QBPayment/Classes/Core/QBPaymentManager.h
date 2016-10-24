//
//  QBPaymentManager.h
//  kuaibov
//
//  Created by Sean Yue on 16/3/11.
//  Copyright © 2016年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBPaymentDefines.h"
#import "QBDefines.h"

FOUNDATION_EXTERN NSString *const kQBPaymentFetchConfigNotification;

@class QBPaymentConfig;

@interface QBPaymentManager : NSObject

+ (instancetype)sharedManager;

/**
 *  注册支付所用的appId, 支付的版本号，渠道号，以及
 *
 *  @param appId     appId
 *  @param pv        支付版本号(用于获取支付配置)
 *  @param channelNo 渠道号
 *  @param urlScheme 支付宝回调所用的url scheme；在某些第三方支付中，如果不注册该url scheme，可能会在调起时崩溃
 *  @param config    支付配置，如果为nil，则从服务器端获取支付配置
 *  @param shouldCommitPayment 是否提交支付信息
 */
- (void)registerPaymentWithAppId:(NSString *)appId paymentPv:(NSNumber *)pv channelNo:(NSString *)channelNo urlScheme:(NSString *)urlScheme;
- (void)registerPaymentWithAppId:(NSString *)appId
                       paymentPv:(NSNumber *)pv
                       channelNo:(NSString *)channelNo
                       urlScheme:(NSString *)urlScheme
                          config:(QBPaymentConfig *)config
             shouldCommitPayment:(BOOL)shouldCommitPayment;

/**
 *  开启支付
 *
 *  @param paymentInfo       支付信息
 *  @param completionHandler 回调block
 *
 *  @return 是否成功开启
 */
- (BOOL)startPaymentWithPaymentInfo:(QBPaymentInfo *)paymentInfo
                  completionHandler:(QBPaymentCompletionHandler)completionHandler;


- (void)activatePaymentInfos:(NSArray<QBPaymentInfo *> *)paymentInfos withCompletionHandler:(QBCompletionHandler)completionHandler;

/**
 *  查询当前支付是否集成了指定类型的SDK
 *
 *  @param payType       支付类型
 *
 *  @return 是否集成了该支付类型的SDK
 */
- (BOOL)IsSDKIntegratedForPayType:(QBPayType)payType;

/**
 *  刷新配置的支付类型
 *
 *  @param completionHandler    刷新操作之后的回调
 *
 */
- (void)refreshAvailablePaymentTypesWithCompletionHandler:(void (^)(void))completionHandler;

@end

@interface QBPaymentManager (ConfiguredPaymentTypes)

- (QBPayType)wechatPaymentType;
- (QBPayType)alipayPaymentType;
- (QBPayType)cardPayPaymentType;
- (QBPayType)qqPaymentType;

@end

@interface QBPaymentManager (ApplicationCallback)

- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)handleOpenUrl:(NSURL *)url;

@end

@interface QBPaymentManager (Test)

- (void)usePaymentConfigInTestServer:(BOOL)useTestConfig;

@end
