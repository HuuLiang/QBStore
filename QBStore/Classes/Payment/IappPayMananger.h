//
//  IappPayMananger.h
//  YYKuaibo
//
//  Created by Sean Yue on 16/6/15.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IappPayType) {
    IappPayTypeUnspecified,
    IappPayTypeWeChat,
    IappPayTypeAlipay
};

typedef NS_ENUM(NSUInteger, IappPayResult) {
    IappPayResultUnknown = 0,
    IappPayResultSuccess,
    IappPayResultFailure,
    IappPayResultCancelled
};

typedef void (^IappPayCompletionHandler)(IappPayResult payResult, NSError *error);

@class IappPayConfig;
@interface IappPayMananger : NSObject

@property (nonatomic,retain) IappPayConfig *payConfig;

+ (instancetype)sharedMananger;
- (void)payWithOrder:(NSString *)orderId price:(NSUInteger)price payType:(IappPayType)payType completionHandler:(IappPayCompletionHandler)completionHandler;
- (void)handleOpenURL:(NSURL *)url;

@end

@interface IappPayConfig : NSObject

@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *privateKey;
@property (nonatomic) NSString *publicKey;
@property (nonatomic) NSString *notifyUrl;
@property (nonatomic) NSString *waresid;
@property (nonatomic) NSString *appUserId;
@property (nonatomic) NSString *privateInfo;
@property (nonatomic) NSString *alipayURLScheme;

@end

extern NSString *const kIappPayErrorDomain;
extern const NSInteger kIappPayParameterErrorCode;
