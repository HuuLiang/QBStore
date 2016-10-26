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
    payConfig.appId = @"3007001516";
    payConfig.privateKey = @"MIICXAIBAAKBgQDDcwpdnKCxBOLEsxtOeoecH/lbzOFDuqhF0MhLctnqLXrWqii2rsDT7Sfa/QjHNpYNgEfB057JG2tbBOJPp0S5c1w7MzIYTLGG1mcsMbtGRzhph0Exnuv6i8TRZiB6gndBnkxBKKYV5kmasDzUDJet2PFRPEsNWlX3sAI8nu/nMQIDAQABAoGANJw92Q71LlE7XWk823YeFMeCjtRqepm++/QERlLnF6MgYrIw/WOy4hj/VnIwL7eg0oeKSUFWh5nK3xhEdt52n9+iWuO6XEl3cpABySqiXyntuqyDRrpJZ/YXatZNVqJoVQPyyzXFdpkVk6Gu3Y54QwVR63mmlIZIDoh9KB5AKUECQQD6E0xvRhAQpH5Zmo87gWriJqaJy5fVXVaE9P2cTIyahnO0YNgLEkRDYHbJ2JRqMd0woknG2G5C/dNVIy8OHA7JAkEAyBRvuqjx0Qu9vvPsNC7UwjTqJ0wUVH1h/ctqsvguKtNIEZjhbGUZvJ9wj61iQRmI44+FmasC3FxLh0vD9OzBKQJBAJqcqeo2MCKKARBXLe1Fc5bE/Lw/Iu2o2qAzdEVZUqkLLag9I/WcYpYhou/itsf9clrqS6DkGS/UDQAbU7FuiXkCQH+2k88ZUin3Dapa9xYkIojI0AI/jOaVljwzYStWQdnyPZmF9baEHlaJi4cazJHzY66mCUiaoVvZyhhVo4KusWkCQHSn6+hImgRymP2ZcUfPnw0cvjmAi8DaKJLaQOq0GuyJLEP4O0+Y7EBN+XepWSWuktvEO4VZ/Cyx/KXQZxJ1o/s=";
    payConfig.publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCY/IWre5+nPB670I06c392eH6q5VxZMwnBClUFSndKZxGAj/mRViex73/aosKwFJ8yyxhhH8Ga3FoAsy1LRZ4DA9Hs9M8Zhl1Kp0hBV3A53a1fucAZQ8cST2dDXnWWi9zYBMG/dD8DoUm4sCP8RBEjNKj7B/n2HgOehOOvFcD7ZwIDAQAB";
    payConfig.waresid = @"1";
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
