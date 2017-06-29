//
//  IappPaymentPlugin.m
//  Pods
//
//  Created by Sean Yue on 2017/6/1.
//
//

#import "IappPaymentPlugin.h"
#import <IapppayAlphaKit/IapppayAlphaKit.h>
#import <IapppayAlphaKit/IapppayAlphaOrderUtils.h>

@interface IappPaymentPlugin () <IapppayAlphaKitPayRetDelegate>

@end

@implementation IappPaymentPlugin

- (QBPluginType)pluginType {
    return QBPluginTypeIAppPay;
}

- (NSString *)pluginName {
    return @"爱贝支付";
}

- (void)setUrlScheme:(NSString *)urlScheme {
    [super setUrlScheme:urlScheme];
    [IapppayAlphaKit sharedInstance].appAlipayScheme = urlScheme;
}

- (void)payWithPaymentInfo:(QBPaymentInfo *)paymentInfo
         completionHandler:(QBPaymentCompletionHandler)completionHandler
{
    [super payWithPaymentInfo:paymentInfo completionHandler:completionHandler];
    
    NSDictionary *payTypeMapping = @{@(QBPaymentTypeWeChat):@(IapppayAlphaKitWeChatPayType),
                                     @(QBPaymentTypeAlipay):@(IapppayAlphaKitAlipayPayType)};
    
    NSNumber *iappPayType = payTypeMapping[@(paymentInfo.paymentType)];
    if (!iappPayType) {
        completionHandler(QBPayResultFailure, paymentInfo);
        return ;
    }
    
    self.paymentCompletionHandler = completionHandler;
    self.paymentInfo = paymentInfo;
    
    IapppayAlphaOrderUtils *order = [[IapppayAlphaOrderUtils alloc] init];
    order.appId = self.paymentConfiguration[@"appid"];
    order.cpPrivateKey = self.paymentConfiguration[@"privateKey"];
    order.cpOrderId = paymentInfo.orderId;
    order.waresId = self.paymentConfiguration[@"waresid"];
    order.waresName = paymentInfo.orderDescription;
    order.price = [NSString stringWithFormat:@"%.2f", paymentInfo.orderPrice/100.];
    order.appUserId = paymentInfo.userId ?: @"UnregisterUser";
    order.cpPrivateInfo = paymentInfo.reservedData;
    order.notifyUrl = self.paymentConfiguration[@"notifyUrl"];
    
    NSString *trandData = [order getTrandData];
    [[IapppayAlphaKit sharedInstance] makePayForTrandInfo:trandData payMethodType:iappPayType.integerValue payDelegate:self];
}

- (void)handleOpenURL:(NSURL *)url {
    [[IapppayAlphaKit sharedInstance] handleOpenUrl:url];
}

#pragma mark - IapppayAlphaKitPayRetDelegate

- (void)iapppayAlphaKitPayRetCode:(IapppayAlphaKitPayRetCode)statusCode resultInfo:(NSDictionary *)resultInfo {
    NSDictionary *paymentStatusMapping = @{@(IapppayAlphaKitPayRetSuccessCode):@(QBPayResultSuccess),
                                           @(IapppayAlphaKitPayRetFailedCode):@(QBPayResultFailure),
                                           @(IapppayAlphaKitPayRetCancelCode):@(QBPayResultCancelled)};
    NSNumber *paymentResult = paymentStatusMapping[@(statusCode)];
    if (!paymentResult) {
        paymentResult = @(QBPayResultUnknown);
    }
    
    NSString *signature = [resultInfo objectForKey:@"Signature"];
    if (paymentResult.unsignedIntegerValue == QBPayResultSuccess) {
        if (![IapppayAlphaOrderUtils checkPayResult:signature withAppKey:self.paymentConfiguration[@"publicKey"]]) {
            QBLog(@"支付成功，但是延签失败！");
            paymentResult = @(QBPayResultFailure);
        }
    }
    
    [[self class] commitPayment:self.paymentInfo withResult:paymentResult.unsignedIntegerValue];
    
    QBSafelyCallBlock(self.paymentCompletionHandler, paymentResult.unsignedIntegerValue, self.paymentInfo);
    self.paymentCompletionHandler = nil;
    self.paymentInfo = nil;
}
@end
