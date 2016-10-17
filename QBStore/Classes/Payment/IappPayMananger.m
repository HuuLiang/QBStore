//
//  IappPayMananger.m
//  YYKuaibo
//
//  Created by Sean Yue on 16/6/15.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "IappPayMananger.h"
#import <IapppayAlphaKit/IapppayAlphaKit.h>
#import <IapppayAlphaKit/IapppayAlphaOrderUtils.h>

NSString *const kIappPayErrorDomain = @"com.qbstore.errordomian.iapppay";
const NSInteger kIappPayParameterErrorCode = -1;

@interface IappPayMananger () <IapppayAlphaKitPayRetDelegate>
@property (nonatomic,copy) IappPayCompletionHandler completionHandler;
@property (nonatomic) NSString *payingOrderId;
@end

@implementation IappPayMananger

+ (instancetype)sharedMananger {
    static IappPayMananger *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)setPayConfig:(IappPayConfig *)payConfig {
    _payConfig = payConfig;
    
    [IapppayAlphaKit sharedInstance].appAlipayScheme = payConfig.alipayURLScheme;
}

- (void)payWithOrder:(NSString *)orderId price:(NSUInteger)price payType:(IappPayType)payType completionHandler:(IappPayCompletionHandler)completionHandler {
    NSDictionary *payTypeMapping = @{@(IappPayTypeWeChat):@(IapppayAlphaKitWeChatPayType),
                                     @(IappPayTypeAlipay):@(IapppayAlphaKitAlipayPayType)};
    if (!payTypeMapping[@(payType)]) {
        NSError *error = [NSError errorWithDomain:kIappPayErrorDomain code:kIappPayParameterErrorCode errorMessage:@"支付参数错误"];
        completionHandler(IappPayResultFailure, error);
        return ;
    }
    
    self.completionHandler = completionHandler;
    self.payingOrderId = orderId;
    
    IapppayAlphaOrderUtils *order = [[IapppayAlphaOrderUtils alloc] init];
    order.appId = self.payConfig.appId;
    order.cpPrivateKey = self.payConfig.privateKey;
    order.cpOrderId = orderId;
    order.waresId = self.payConfig.waresid;
    order.price = [NSString stringWithFormat:@"%.2f", price/100.];
    order.appUserId = self.payConfig.appUserId;
    order.cpPrivateInfo = self.payConfig.privateInfo;
    order.notifyUrl = self.payConfig.notifyUrl;
    order.waresName = [NSString stringWithFormat:@"棒棒堂-订单号：%@", orderId];

    NSString *trandData = [order getTrandData];
    [[IapppayAlphaKit sharedInstance] makePayForTrandInfo:trandData payMethodType:[payTypeMapping[@(payType)] integerValue] payDelegate:self];
}

- (void)handleOpenURL:(NSURL *)url {
    [[IapppayAlphaKit sharedInstance] handleOpenUrl:url];
}

#pragma mark - IapppayAlphaKitPayRetDelegate

- (void)iapppayAlphaKitPayRetCode:(IapppayAlphaKitPayRetCode)statusCode resultInfo:(NSDictionary *)resultInfo {
    NSDictionary *paymentStatusMapping = @{@(IapppayAlphaKitPayRetSuccessCode):@(IappPayResultSuccess),
                                           @(IapppayAlphaKitPayRetFailedCode):@(IappPayResultFailure),
                                           @(IapppayAlphaKitPayRetCancelCode):@(IappPayResultCancelled)};
    
    NSNumber *paymentResult = paymentStatusMapping[@(statusCode)];
    if (!paymentResult) {
        paymentResult = @(IappPayResultUnknown);
    }

    NSError *error;
    NSString *signature = [resultInfo objectForKey:@"Signature"];
    if (paymentResult.unsignedIntegerValue == IappPayResultSuccess) {
        if (![IapppayAlphaOrderUtils checkPayResult:signature withAppKey:self.payConfig.publicKey]) {
#ifdef DEBUG
            NSLog(@"支付成功，但是延签失败！");
#endif
            paymentResult = @(IappPayResultFailure);
        }
    }
    
    if (paymentResult.unsignedIntegerValue != IappPayResultSuccess) {
        NSString *errorCode = resultInfo[@"RetCode"];
        NSString *errorMessage = resultInfo[@"ErrorMsg"];
        error = [NSError errorWithDomain:kIappPayErrorDomain code:errorCode.integerValue errorMessage:errorMessage];
    }
    
    if (self.completionHandler) {
        self.completionHandler(paymentResult.unsignedIntegerValue, error);
    }
    
    self.completionHandler = nil;
    self.payingOrderId = nil;
}
@end

@implementation IappPayConfig

@end
