//
//  QBSWeChatHelper.m
//  Pods
//
//  Created by Sean Yue on 16/7/27.
//
//

#import "QBSWeChatHelper.h"
#import "AFNetworking.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "QBSWeChatUser.h"

static NSString *const kWeChatAuthState = @"QBStoreSDKAuth";
static NSString *const kWeChatAccessTokenURL = @"https://api.weixin.qq.com/sns/oauth2/access_token";
static NSString *const kWeChatUserInfoURL = @"https://api.weixin.qq.com/sns/userinfo";

NSString *const kQBSWeChatLoginErrorDomain = @"com.qbstore.errordomain.wechatlogin";

const NSInteger kQBSWeChatLoginSDKCallFailureError = -1;
const NSInteger kQBSWeChatLoginUserAuthRejectedError = -4;
const NSInteger kQBSWeChatLoginUserAuthCancelledError = -2;
const NSInteger kQBSWeChatLoginUnknownError = NSIntegerMin;
const NSInteger kQBSWeChatLoginUserInfoFailureError = -5;
const NSInteger kQBSWeChatLoginNetworkError = -999;

@interface QBSWeChatHelper () <WXApiDelegate>
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *secret;
@property (nonatomic,copy) QBSCompletionHandler loginCompletionHandler;
@end

@implementation QBSWeChatHelper

SynthesizeSingletonMethod(sharedHelper, QBSWeChatHelper)

- (void)registerAppId:(NSString *)appId secrect:(NSString *)secret {
    _appId = appId;
    _secret = secret;
    
    [WXApi registerApp:appId];
}

- (void)loginInViewController:(UIViewController *)viewController withCompletionHandler:(QBSCompletionHandler)completionHandler {
    
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = kWeChatAuthState ;
    
    BOOL success = NO;
    if ([WXApi isWXAppInstalled]) {
        success = [WXApi sendReq:req];
    } else {
        success = [WXApi sendAuthReq:req viewController:viewController delegate:self];
    }
    
    if (success) {
        self.loginCompletionHandler = completionHandler;
    } else {
        NSError *error = [NSError errorWithDomain:kQBSWeChatLoginErrorDomain
                                             code:kQBSWeChatLoginSDKCallFailureError
                                         userInfo:@{kQBSErrorMessageKeyName:@"微信登录失败：无法打开微信登录"}];
        QBSLogError(error);
        SafelyCallBlock(completionHandler, nil, error);
    }
}

- (void)handleOpenURL:(NSURL *)url {
    [WXApi handleOpenURL:url delegate:self];
}

- (AFHTTPSessionManager *)newSessionManager {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    return sessionManager;
}

- (void)onSuccessfullyRespondLoginWithCode:(NSString *)loginCode {
    NSDictionary *accessTokenParams = @{@"appid":self.appId, @"secret":self.secret, @"code":loginCode, @"grant_type":@"authorization_code"};
    
    @weakify(self);
    [[self newSessionManager] GET:kWeChatAccessTokenURL
                       parameters:accessTokenParams
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSString *accessToken = responseObject[@"access_token"];
        NSString *openid = responseObject[@"openid"];
        
        if (accessToken == nil || openid == nil) {
            NSError *err = [NSError errorWithDomain:kQBSWeChatLoginErrorDomain
                                               code:kQBSWeChatLoginNetworkError
                                           userInfo:@{kQBSErrorMessageKeyName:@"微信登录失败：access_token/openid为空"}];
            QBSLogError(err);
            SafelyCallBlock(self.loginCompletionHandler, nil, err);
            return ;
        }
        
        [[self newSessionManager] GET:kWeChatUserInfoURL
                           parameters:@{@"access_token":accessToken,
                                        @"openid":openid}
                             progress:nil
                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
        {
            @strongify(self);
            NSDictionary *resp = responseObject;
            NSNumber *errorCode = resp[@"errcode"];
            NSString *errorMessage = resp[@"errmsg"];
            
            if (errorCode) {
                NSError *error = [NSError errorWithDomain:kQBSWeChatLoginErrorDomain
                                                     code:kQBSWeChatLoginUserInfoFailureError
                                                 userInfo:@{kQBSErrorMessageKeyName:[NSString stringWithFormat:@"微信登录失败：%@(错误码：%@)", errorMessage, errorCode]}];
                QBSLogError(error);
                SafelyCallBlock(self.loginCompletionHandler, nil, error);
                return ;
            }
            
            QBSWeChatUser *user = [QBSWeChatUser objectFromDictionary:resp];
            SafelyCallBlock(self.loginCompletionHandler, user, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSError *err = [NSError errorWithDomain:kQBSWeChatLoginErrorDomain
                                               code:kQBSWeChatLoginNetworkError
                                           userInfo:@{kQBSErrorMessageKeyName:@"微信登录失败：网络问题"}];
            QBSLogError(err);
            SafelyCallBlock(self.loginCompletionHandler, nil, err);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError *err = [NSError errorWithDomain:kQBSWeChatLoginErrorDomain
                                           code:kQBSWeChatLoginNetworkError
                                       userInfo:@{kQBSErrorMessageKeyName:@"微信登录失败：网络问题"}];
        QBSLogError(err);
        SafelyCallBlock(self.loginCompletionHandler, nil, err);
    }];
}

#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq *)req {
    
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if (authResp.errCode == 0) {
            [self onSuccessfullyRespondLoginWithCode:authResp.code];
        } else {
            NSError *error;
            if (authResp.errCode == kQBSWeChatLoginUserAuthRejectedError) {
                error = [NSError errorWithDomain:kQBSWeChatLoginErrorDomain
                                            code:kQBSWeChatLoginUserAuthRejectedError
                                        userInfo:@{kQBSErrorMessageKeyName:@"微信登录失败：用户拒绝授权"}];
            } else if (authResp.errCode == kQBSWeChatLoginUserAuthCancelledError) {
                error = [NSError errorWithDomain:kQBSWeChatLoginErrorDomain
                                            code:kQBSWeChatLoginUserAuthCancelledError
                                        userInfo:@{kQBSErrorMessageKeyName:@"微信登录失败：用户取消授权"}];
            } else {
                error = [NSError errorWithDomain:kQBSWeChatLoginErrorDomain
                                            code:kQBSWeChatLoginUnknownError
                                        userInfo:@{kQBSErrorMessageKeyName:@"微信登录失败：未知错误"}];
            }
            
            QBSLogError(error);
            SafelyCallBlock(self.loginCompletionHandler, nil, error);
            self.loginCompletionHandler = nil;
        }
    }
}
@end
