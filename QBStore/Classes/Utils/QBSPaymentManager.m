//
//  QBSPaymentManager.m
//  QBStore
//
//  Created by Sean Yue on 2016/10/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSPaymentManager.h"
#import "QBSOrder.h"
#import <QBPaymentManager.h>
#import <QBPaymentConfig.h>
#import <QBPaymentInfo.h>

@implementation QBSPaymentManager

SynthesizeSingletonMethod(sharedManager, QBSPaymentManager)

- (void)setup {
    
    QBPaymentConfig *config = [[QBPaymentConfig alloc] init];
    config.payConfig = [[QBPaymentConfigSummary alloc] init];
    config.payConfig.wechat = kQBVIAPayConfigName;
    config.payConfig.alipay = kQBVIAPayConfigName;
    
    [[QBPaymentManager sharedManager] registerPaymentWithAppId:kQBSRESTAppId
                                                     paymentPv:@(kQBSPaymentPv.integerValue)
                                                     channelNo:kQBSChannelNo
                                                     urlScheme:@"comqbstoresdkiapppayurlscheme"
                                                        config:config
                                           shouldCommitPayment:NO];
}

- (void)handleOpenURL:(NSURL *)url {
    [[QBPaymentManager sharedManager] handleOpenUrl:url];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[QBPaymentManager sharedManager] applicationWillEnterForeground:application];
}

- (void)payForOrder:(QBSOrder *)order withCompletionHandler:(QBSPaymentCompletionHandler)completionHandler {
    if (![order.payType isEqualToString:kQBSOrderPayTypeWeChat]
        && ![order.payType isEqualToString:kQBSOrderPayTypeAlipay]) {
        QBSafelyCallBlock(completionHandler, QBSPaymentResultFailure, order);
        return ;
    }
    
    QBPaymentInfo *paymentInfo = [[QBPaymentInfo alloc] init];
    paymentInfo.orderId = order.orderNo;
    paymentInfo.orderPrice = order.totalPrice.unsignedIntegerValue;
    paymentInfo.paymentType = QBPayTypeVIAPay;
    paymentInfo.paymentSubType = [order.payType isEqualToString:kQBSOrderPayTypeWeChat] ? QBPaySubTypeWeChat : QBPaySubTypeAlipay;
    paymentInfo.payPointType = 1;
    paymentInfo.paymentResult = QBPayResultUnknown;
    paymentInfo.paymentStatus = QBPayStatusPaying;
    paymentInfo.userId = order.userId;
    
    NSDateFormatter *fomatter =[[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyyMMddHHmmss"];
    paymentInfo.paymentTime = [fomatter stringFromDate:[NSDate date]];
    
    NSString *appName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
    paymentInfo.orderDescription = [NSString stringWithFormat:@"%@-订单号：%@", appName, order.orderNo];
    
    [[QBPaymentManager sharedManager] startPaymentWithPaymentInfo:paymentInfo completionHandler:^(QBPayResult payResult, QBPaymentInfo *paymentInfo) {
        NSDictionary *resultMapping = @{@(QBPayResultUnknown):@(QBSPaymentResultUnknown),
                                        @(QBPayResultFailure):@(QBSPaymentResultFailure),
                                        @(QBPayResultSuccess):@(QBSPaymentResultSuccess),
                                        @(QBPayResultCancelled):@(QBSPaymentResultCancelled)};
        
        NSNumber *result = resultMapping[@(payResult)];
        if (!result) {
            result = @(QBPayResultFailure);
        }
        
        QBSafelyCallBlock(completionHandler, result.unsignedIntegerValue, order);
        
    }];
}
@end
