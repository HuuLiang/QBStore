//
//  QBPaymentHttpClient.m
//  Pods
//
//  Created by Sean Yue on 2017/6/2.
//
//

#import "QBPaymentHttpClient.h"
#import <AFHTTPSessionManager.h>
#import "QBPaymentDefines.h"

NSString *const kQBPaymentHttpClientErrorDomain = @"com.qbpayment.errordomain.httpclient";

const NSInteger kQBPaymentHttpClientInvalidArgument = NSIntegerMin;

@interface QBPaymentHttpClient ()
@property (nonatomic,retain) AFHTTPSessionManager *sessionManager;
@end

@implementation QBPaymentHttpClient

+ (instancetype)sharedClient {
    static QBPaymentHttpClient *_sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] init];
    });
    return _sharedClient;
}

+ (instancetype)JSONRequestClient {
    static QBPaymentHttpClient *_JSONRequestClient;
    static dispatch_once_t jsonToken;
    dispatch_once(&jsonToken, ^{
        _JSONRequestClient = [[self alloc] init];
        _JSONRequestClient.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _JSONRequestClient.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return _JSONRequestClient;
}

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager) {
        return _sessionManager;
    }
    
    _sessionManager = [[AFHTTPSessionManager alloc] init];
    _sessionManager.requestSerializer.timeoutInterval = 30;
    return _sessionManager;
}

- (void)GET:(NSString *)url withParams:(id)params completionHandler:(QBPaymentHttpCompletionHandler)completionHandler {
    [self request:url withParams:params method:@"GET" completionHandler:completionHandler];
}

- (void)POST:(NSString *)url withParams:(id)params completionHandler:(QBPaymentHttpCompletionHandler)completionHandler {
    [self request:url withParams:params method:@"POST" completionHandler:completionHandler];
}

- (void)request:(NSString *)url withParams:(id)params method:(NSString *)method completionHandler:(QBPaymentHttpCompletionHandler)completionHandler {
    if ([method isEqualToString:@"GET"]) {
        [self.sessionManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            QBSafelyCallBlock(completionHandler, responseObject, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            QBSafelyCallBlock(completionHandler, nil, [NSError errorWithDomain:kQBPaymentHttpClientErrorDomain code:error.code userInfo:error.userInfo]);
        }];
    } else if ([method isEqualToString:@"POST"]) {
        [self.sessionManager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            QBSafelyCallBlock(completionHandler, responseObject, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            QBSafelyCallBlock(completionHandler, nil, [NSError errorWithDomain:kQBPaymentHttpClientErrorDomain code:error.code userInfo:error.userInfo]);
        }];
    } else {
        QBSafelyCallBlock(completionHandler, nil, [NSError errorWithDomain:kQBPaymentHttpClientErrorDomain code:kQBPaymentHttpClientInvalidArgument userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"不支持的请求方法：%@", method]}]);
    }
    
}
@end
