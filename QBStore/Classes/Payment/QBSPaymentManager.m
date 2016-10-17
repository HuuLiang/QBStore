//
//  QBSPaymentManager.m
//  Pods
//
//  Created by Sean Yue on 16/8/20.
//
//

#import "QBSPaymentManager.h"
#import "IappPayMananger.h"
#import "QBSOrder.h"

@implementation QBSPaymentManager

SynthesizeSingletonMethod(sharedManager, QBSPaymentManager)

- (void)setup {
    IappPayConfig *payConfig = [[IappPayConfig alloc] init];
    payConfig.appId = @"3006339410";
    payConfig.privateKey = @"MIICWwIBAAKBgQCHEQCLCZujWicF6ClEgHx4L/OdSHZ1LdKi/mzPOIa4IRfMOS09qDNV3+uK/zEEPu1DgO5Cl1lsm4xpwIiOqdXNRxLE9PUfgRy4syiiqRfofAO7w4VLSG4S0VU5F+jqQzKM7Zgp3blbc5BJ5PtKXf6zP3aCAYjz13HHH34angjg0wIDAQABAoGASOJm3aBoqSSL7EcUhc+j2yNdHaGtspvwj14mD0hcgl3xPpYYEK6ETTHRJCeDJtxiIkwfxjVv3witI5/u0LVbFmd4b+2jZQ848BHGFtZFOOPJFVCylTy5j5O79mEx0nJN0EJ/qadwezXr4UZLDIaJdWxhhvS+yDe0e0foz5AxWmkCQQDhd9U1uUasiMmH4WvHqMfq5l4y4U+V5SGb+IK+8Vi03Zfw1YDvKrgv1Xm1mdzYHFLkC47dhTm7/Ko8k5Kncf89AkEAmVtEtycnSYciSqDVXxWtH1tzsDeIMz/ZlDGXCAdUfRR2ZJ2u2jrLFunoS9dXhSGuERU7laasK0bDT4p0UwlhTwJAVF+wtPsRnI1PxX6xA7WAosH0rFuumax2SFTWMLhGduCZ9HEhX97/sD7V3gSnJWRsDJTasMEjWtrxpdufvPOnDQJAdsYPVGMItJPq5S3n0/rv2Kd11HdOD5NWKsa1mMxEjZN5lrfhoreCb7694W9pI31QWX6+ZUtvcR0fS82KBn3vVQJAa0fESiiDDrovKHBm/aYXjMV5anpbuAa5RJwCqnbjCWleZMwHV+8uUq9+YMnINZQnvi+C62It4BD+KrJn5q4pwg==";
    payConfig.publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCbNQyxdpLeMwE0QMv/dB3Jn1SRqYE/u3QT3ig2uXu4yeaZo4f7qJomudLKKOgpa8+4a2JAPRBSueDpiytR0zN5hRZKImeZAu2foSYkpBqnjb5CRAH7roO7+ervoizg6bhAEx2zlltV9wZKQZ0Di5wCCV+bMSEXkYqfASRplYUvHwIDAQAB";
    payConfig.waresid = @"3";
    payConfig.privateInfo = [NSString stringWithFormat:@"%@$%@", [QBSConfiguration defaultConfiguration].RESTAppId, [QBSConfiguration defaultConfiguration].channelNo];
    payConfig.alipayURLScheme = @"comqbstoresdkiapppayurlscheme";
    [IappPayMananger sharedMananger].payConfig = payConfig;
}

- (void)handleOpenURL:(NSURL *)url {
    [[IappPayMananger sharedMananger] handleOpenURL:url];
}

- (void)payForOrder:(QBSOrder *)order withCompletionHandler:(QBSPaymentCompletionHandler)completionHandler {
    
    NSDictionary *payTypeMapping = @{kQBSOrderPayTypeWeChat:@(IappPayTypeWeChat),
                                     kQBSOrderPayTypeAlipay:@(IappPayTypeAlipay)};
    
    NSNumber *iAppPayType = payTypeMapping[order.payType];
    
#ifdef DEBUG
    NSAssert(iAppPayType != nil, @"QBSPaymentManager: wrong pay type!");
#endif
    
    if (!iAppPayType) {
        SafelyCallBlock(completionHandler, QBSPaymentResultFailure, order);
        return ;
    }
    
    [IappPayMananger sharedMananger].payConfig.appUserId = order.userId;
    [[IappPayMananger sharedMananger] payWithOrder:order.orderNo
                                             price:order.totalPrice.unsignedIntegerValue
                                           payType:iAppPayType.unsignedIntegerValue
                                 completionHandler:^(IappPayResult payResult, NSError *error)
    {
        NSDictionary *payResultMapping = @{@(IappPayResultSuccess):@(QBSPaymentResultSuccess),
                                           @(IappPayResultFailure):@(QBSPaymentResultFailure),
                                           @(IappPayResultCancelled):@(QBSPaymentResultCancelled)};
        
        NSNumber *paymentResult = payResultMapping[@(payResult)];
        if (!paymentResult) {
            paymentResult = @(QBSPaymentResultUnknown);
        }
        
        [self onPaymentResult:paymentResult.unsignedIntegerValue forOrder:order withError:error];
        
        SafelyCallBlock(completionHandler, paymentResult.unsignedIntegerValue, order);
    }];
}

- (void)onPaymentResult:(QBSPaymentResult)paymentResult forOrder:(QBSOrder *)order withError:(NSError *)error {
    if (paymentResult == QBSPaymentResultSuccess) {
        [[QBSHUDManager sharedManager] showSuccess:@"支付成功"];
    } else {
        
        if (paymentResult == QBSPaymentResultFailure) {
            NSString *errorMessage = error.qbsErrorMessage;
            [[QBSHUDManager sharedManager] showError:errorMessage.length > 0 ?[NSString stringWithFormat:@"支付失败：%@", errorMessage]:@"支付失败"];
        } else if (paymentResult == QBSPaymentResultCancelled) {
            [[QBSHUDManager sharedManager] showError:@"支付取消"];
        }
    }
    
}
@end
