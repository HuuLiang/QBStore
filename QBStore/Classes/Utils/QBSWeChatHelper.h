//
//  QBSWeChatHelper.h
//  Pods
//
//  Created by Sean Yue on 16/7/27.
//
//

#import <Foundation/Foundation.h>

@interface QBSWeChatHelper : NSObject

+ (instancetype)sharedHelper;

- (void)registerAppId:(NSString *)appId secrect:(NSString *)secret;
- (void)loginInViewController:(UIViewController *)viewController withCompletionHandler:(QBSCompletionHandler)completionHandler;
- (void)handleOpenURL:(NSURL *)url;

@end

extern NSString *const kQBSWeChatLoginErrorDomain;

extern const NSInteger kQBSWeChatLoginSDKCallFailureError;
extern const NSInteger kQBSWeChatLoginUserAuthRejectedError;
extern const NSInteger kQBSWeChatLoginUserAuthCancelledError;
extern const NSInteger kQBSWeChatLoginUserInfoFailureError;
extern const NSInteger kQBSWeChatLoginNetworkError;
extern const NSInteger kQBSWeChatLoginUnknownError;
