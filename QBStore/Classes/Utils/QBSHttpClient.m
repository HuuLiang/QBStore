//
//  QBSHttpClient.m
//  Pods
//
//  Created by Sean Yue on 16/7/7.
//
//

#import "QBSHttpClient.h"
#import "AFNetworking.h"
#import "NSString+crypt.h"

static NSString *const kEncryptionPassword = @"qb%Fm@2016_&";
NSString *const kQBSHttpClientArgErrorDomain = @"com.qbstore.errordomain.arg";

@interface QBSHttpClient ()
@property (nonatomic,readonly) NSURL *baseURL;
@property (nonatomic,retain) AFHTTPSessionManager *sessionManager;
@end

@implementation QBSHttpClient

+ (instancetype)sharedClient {
    static QBSHttpClient *_sharedClient;
    static dispatch_once_t _sharedOnceToken;
    dispatch_once(&_sharedOnceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:[QBSConfiguration defaultConfiguration].baseURL]];
    });
    return _sharedClient;
}

//+ (instancetype)paymentClient {
//    static QBSHttpClient *_paymentClient;
//    static dispatch_once_t _paymentOnceToken;
//    dispatch_once(&_paymentOnceToken, ^{
//        _paymentClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:[QBSConfiguration defaultConfiguration].paymentBaseURL]];
//    });
//    return _paymentClient;
//}

- (instancetype)initWithBaseURL:(NSURL *)baseURL {
    self = [self init];
    if (self) {
        _baseURL = baseURL;
    }
    return self;
}

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager) {
        return _sessionManager;
    }
    
    _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
    return _sessionManager;
}

- (void)requestURL:(NSString *)urlPath
        withParams:(id)params
        methodType:(QBSHttpMethodType)methodtype
 completionHandler:(QBSCompletionHandler)completionHandler
{
    QBSLog(@"Request URL: %@ with params: \n%@", urlPath, params);
    
    id encryptedParams = [self encryptParams:params];
    if (methodtype == QBSHttpMethodGET) {
        [self.sessionManager GET:urlPath parameters:encryptedParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            QBSLog(@"QBStoreSDK HTTP URL:%@ \nResponse: %@", urlPath, responseObject);
            SafelyCallBlock(completionHandler, responseObject, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            QBSLog(@"QBStoreSDK HTTP URL:%@ \nNetwork Error: %@", urlPath, error.localizedDescription);
            SafelyCallBlock(completionHandler, nil, error);
        }];
    } else if (methodtype == QBSHttpMethodPOST) {
        [self.sessionManager POST:urlPath parameters:encryptedParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            QBSLog(@"QBStoreSDK HTTP URL:%@ \nResponse: %@", urlPath, responseObject);
            SafelyCallBlock(completionHandler, responseObject, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            QBSLog(@"QBStoreSDK HTTP URL:%@ \nNetwork Error: %@", urlPath, error.localizedDescription);
            SafelyCallBlock(completionHandler, nil, error);
        }];
    } else {
        NSError *error = [NSError errorWithDomain:kQBSHttpClientArgErrorDomain code:-1 userInfo:@{kQBSErrorMessageKeyName:@"The HTTP method type is NOT supported!"}];
        QBSLog(@"QBStoreSDK HTTP URL:%@ \nError:%@", urlPath, error.userInfo[kQBSErrorMessageKeyName]);
        SafelyCallBlock(completionHandler, nil, error);
    }
}

- (id)encryptParams:(id)params {
    if (!params) {
        return nil;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    if (!jsonData) {
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *encryptedDataString = [jsonString encryptedStringWithPassword:[kEncryptionPassword.md5 substringToIndex:16]];
    return @{@"data":encryptedDataString};
}
@end
