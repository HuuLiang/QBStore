//
//  QBPaymentNetworkingManager.m
//  Pods
//
//  Created by Sean Yue on 2017/6/2.
//
//

#import "QBPaymentNetworkingManager.h"
#import "QBPaymentHttpClient.h"
#import "NSString+md5.h"
#import "NSString+crypt.h"
#import "NSObject+BaseRepresentation.h"
#import "QBPaymentInfo.h"
#import "QBPaymentConfiguration.h"

static NSString *const kQBPaymentNetworkingSignKey = @"qdge^%$#@(sdwHs^&";
static NSString *const kQBPaymentCryptPassword = @"wdnxs&*@#!*qb)*&qiang";

NSString *const kQBPaymentConfigurationProducationURL = @"http://pay.rdgongcheng.cn/paycenter/appPayConfig.json";
NSString *const kQBPaymentConfigurationTestURL = @"http://120.24.252.114:8084/paycenter/appPayConfig.json";

static NSString *const kQBPaymentCommitURL = @"http://pay.rdgongcheng.cn/paycenter/qubaPr.json";
static NSString *const kQBPaymentConfigurationStandbyURL = @"http://sts.ayyygs.com/paycenter/appPayConfig-%@-%@.json";
static NSString *const kQBQueryOrderURL = @"http://phas.rdgongcheng.cn/pd-has/successOrderIds.json";

static NSString *const kQBPaymentConfigCacheFile = @"paymentconfiguration";

@interface QBPaymentNetworkingManager ()
@property (nonatomic,retain) dispatch_queue_t cacheQueue;
@property (nonatomic,retain) NSString *paymentConfigurationCachedPath;
@end

@implementation QBPaymentNetworkingManager

QBSynthesizeSingletonMethod(defaultManager)

- (dispatch_queue_t)cacheQueue {
    if (_cacheQueue) {
        return _cacheQueue;
    }
    
    _cacheQueue = dispatch_queue_create("com.qbpayment.QBPaymentNetworkingManager.cachequeue", nil);
    return _cacheQueue;
}

- (NSString *)paymentConfigurationCachedPath {
    if (_paymentConfigurationCachedPath) {
        return _paymentConfigurationCachedPath;
    }
    
    NSArray<NSString *> *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if (cachePaths.firstObject) {
        _paymentConfigurationCachedPath = [NSString stringWithFormat:@"%@/%@", cachePaths.firstObject, kQBPaymentConfigCacheFile.md5];
    }
    return _paymentConfigurationCachedPath;
}

- (BOOL)validateParametersForSigning {
    return QBP_STRING_IS_NOT_EMPTY(self.appId) && QBP_STRING_IS_NOT_EMPTY(self.channelNo) && self.pv;
}

- (void)request_commitPaymentInfo:(QBPaymentInfo *)paymentInfo withCompletionHandler:(QBCompletionHandler)completionHandler {
    if (![self validateParametersForSigning] || !paymentInfo.userId || QBP_STRING_IS_EMPTY(paymentInfo.orderId)) {
        QBSafelyCallBlock(completionHandler, NO, nil);
        return ;
    }
    
    NSDictionary *statusDic = @{@(QBPayResultSuccess):@(1), @(QBPayResultFailure):@(0), @(QBPayResultCancelled):@(2), @(QBPayResultUnknown):@(0)};
    NSDictionary *paymentSubTypeDic = @{@(QBPaymentTypeWeChat):@"WEIXIN",
                                        @(QBPaymentTypeAlipay):@"ALIPAY",
                                        @(QBPaymentTypeUPPay):@"UNIONPAY",
                                        @(QBPaymentTypeQQ):@"QQPAY"};
    
    NSString *appVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    NSDictionary *params = @{@"uuid":paymentInfo.userId,
                             @"orderNo":paymentInfo.orderId,
                             @"imsi":@"999999999999999",
                             @"imei":@"999999999999999",
                             @"payMoney":@(paymentInfo.orderPrice).stringValue,
                             @"channelNo":self.channelNo,
                             @"contentId":paymentInfo.contentId.stringValue ?: @"0",
                             @"contentType":paymentInfo.contentType.stringValue ?: @"0",
                             @"pluginType":@(paymentInfo.paymentType),
                             @"payType":paymentSubTypeDic[@(paymentInfo.paymentType)] ?: @"",
                             @"payPointType":@(paymentInfo.currentPayPointType * 10 + paymentInfo.targetPayPointType),
                             @"appId":self.appId,
                             @"versionNo":@(appVersion.integerValue),
                             @"status":statusDic[@(paymentInfo.paymentResult)],
                             @"pV":self.pv,
                             @"payTime":paymentInfo.paymentTime};
    
    [[QBPaymentHttpClient sharedClient] POST:kQBPaymentCommitURL
                                  withParams:[self encryptParams:params]
                           completionHandler:^(id obj, NSError *error)
    {
        NSDictionary *decryptedResponse = [self decryptResponse:obj];
        QBLog(@"Payment response : %@", decryptedResponse);
        
        NSNumber *respCode = decryptedResponse[@"response_code"];
        BOOL success = respCode.unsignedIntegerValue == 100;
        if (success) {
            paymentInfo.paymentStatus = QBPayStatusProcessed;
            [paymentInfo save];
        } else {
            QBLog(@"‼️Payment: fails to commit the order with orderId:%@‼️", paymentInfo.orderId);
        }
        QBSafelyCallBlock(completionHandler, success, respCode);
    }];
}

- (void)request_fetchPaymentConfigurationWithURLString:(NSString *)urlString
                                     completionHandler:(QBCompletionHandler)completionHandler
{
    if (![self validateParametersForSigning]) {
        QBSafelyCallBlock(completionHandler, NO, nil);
        return ;
    }
    
    QBCompletionHandler successHandler = ^(BOOL usingCache, id obj) {
        NSDictionary *response = [self decryptResponse:obj];
        QBLog(@"Fetch payment configuration with response:\n%@", response);
        
        NSNumber *code = response[@"code"];
        if (!code || code.unsignedIntegerValue != 100) {
            QBSafelyCallBlock(completionHandler, NO, response);
            return ;
        }
        
        QBPaymentConfiguration *config = [QBPaymentConfiguration objectFromDictionary:response];
        if (config && !usingCache) {
            dispatch_async(self.cacheQueue, ^{
                BOOL isCached = [(NSDictionary *)obj writeToFile:self.paymentConfigurationCachedPath atomically:YES];
                if (isCached) {
                    QBLog(@"✅Cached payment configuration to path : %@!✅", self.paymentConfigurationCachedPath);
                } else {
                    QBLog(@"‼️Fail to cache payment configuration to path : %@‼️", self.paymentConfigurationCachedPath);
                }
                
            });
        }
        QBSafelyCallBlock(completionHandler, config != nil, config);
    };
    
    QBPaymentHttpCompletionHandler handler = ^(id obj, NSError *error) {
        if (error) {
            QBSafelyCallBlock(completionHandler, NO, nil);
        } else {
            successHandler(NO, obj);
        }
    };
    
    NSDictionary *encryptedParams = [self encryptParams:@{@"appId":self.appId,
                                                          @"channelNo":self.channelNo,
                                                          @"pv":self.pv}];
    [[QBPaymentHttpClient sharedClient] POST:urlString
                                  withParams:encryptedParams
                           completionHandler:^(id obj, NSError *error)
    {
        if (error) {
            if ([urlString isEqualToString:kQBPaymentConfigurationProducationURL]) {
                [[QBPaymentHttpClient sharedClient] GET:[NSString stringWithFormat:kQBPaymentConfigurationStandbyURL, self.appId, self.pv]
                                             withParams:nil
                                      completionHandler:^(id obj, NSError *error) {
                                          if (error) {
                                              NSDictionary *cachedConfig = [[NSDictionary alloc] initWithContentsOfFile:self.paymentConfigurationCachedPath];
                                              if (cachedConfig) {
                                                  successHandler(YES, cachedConfig);
                                              } else {
                                                  handler(obj, error);
                                              }
                                          } else {
                                              handler(obj, error);
                                          }
                                      }];
            } else {
                handler(obj, error);
            }
            
        } else {
            handler(obj, error);
        }
    }];
}

- (void)request_queryOrders:(NSString *)orders
      withCompletionHandler:(QBCompletionHandler)completionHandler
{
    if (QBP_STRING_IS_EMPTY(orders)) {
        QBSafelyCallBlock(completionHandler, NO, nil);
        return ;
    }
    
    NSDictionary *encryptedParams = [self encryptParams:@{@"orderId":orders}];
    
    [[QBPaymentHttpClient sharedClient] POST:kQBQueryOrderURL
                                  withParams:encryptedParams
                           completionHandler:^(id obj, NSError *error)
    {
        NSString *response = [self decryptResponse:obj];
        
        QBLog(@"Manual activation response : %@", response);
        QBSafelyCallBlock(completionHandler, response.length>0, response);
    }];
}

- (NSDictionary *)encryptParams:(NSDictionary *)params {

    // Signing: appId, key, imsi, channelNo, pV
    NSArray *signingValues = @[self.appId, kQBPaymentNetworkingSignKey, @"999999999999999", self.channelNo, self.pv];
    
    NSMutableString *sign = [[NSMutableString alloc] init];
    [signingValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [sign appendFormat:@"%@", obj];
    }];
    [sign appendString:@"null"];
    
    __block NSMutableString *paramString = [NSMutableString string];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isKindOfClass:[NSString class]]) {
            NSString *keyValueString = [NSString stringWithFormat:@"&%@=%@", key, obj];
            [paramString appendString:keyValueString];
        }
    }];
    
    NSString *signedParams = [NSString stringWithFormat:@"sign=%@%@", sign.md5, paramString ?: @""];
    NSString *encryptedDataString = [signedParams encryptedStringWithPassword:[kQBPaymentCryptPassword.md5 substringToIndex:16]];
    return @{@"data":encryptedDataString, @"appId":self.appId};
}

- (id)decryptResponse:(id)response {
    if (![response isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSDictionary *originalResponse = (NSDictionary *)response;
    NSArray *keys = [originalResponse objectForKey:@"key"];
    NSString *dataString = [originalResponse objectForKey:@"data"];
    if (!keys || !dataString) {
        return nil;
    }
    
    NSString *decryptedString = [dataString decryptedStringWithKeys:keys];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[decryptedString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if (jsonObject == nil) {
        jsonObject = decryptedString;
    }
    return jsonObject;
}
@end
