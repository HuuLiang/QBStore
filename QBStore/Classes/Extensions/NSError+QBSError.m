//
//  NSError+QBSError.m
//  Pods
//
//  Created by Sean Yue on 16/8/2.
//
//

#import "NSError+QBSError.h"
#import <objc/runtime.h>

NSString *const kQBSErrorMessageKeyName = @"com.qbstore.errordomian.errormessage";
NSString *const kQBSLogicErrorCodeKeyName = @"com.qbstore.errordomain.logicerrorcode";
const NSInteger kQBSInvalidLogicErrorCode = NSIntegerMax;

static const void *kQBSErrorMessageAssociatedKey = &kQBSErrorMessageAssociatedKey;

@implementation NSError (QBSError)

- (NSString *)qbsErrorMessage {
    NSString *errorMessage = objc_getAssociatedObject(self, kQBSErrorMessageAssociatedKey);
    if (errorMessage) {
        return errorMessage;
    }
    
    return self.userInfo[kQBSErrorMessageKeyName];
}

- (NSInteger)logicCode {
    NSNumber *logicCode = self.userInfo[kQBSLogicErrorCodeKeyName];
    if (logicCode) {
        return logicCode.integerValue;
    }
    
    return kQBSInvalidLogicErrorCode;
}

- (void)setQbsErrorMessage:(NSString *)qbsErrorMessage {
    objc_setAssociatedObject(self, kQBSErrorMessageAssociatedKey, qbsErrorMessage, OBJC_ASSOCIATION_COPY);
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code errorMessage:(NSString *)errorMessage {
    return [self errorWithDomain:domain code:code errorMessage:errorMessage logicCode:kQBSInvalidLogicErrorCode];
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code errorMessage:(NSString *)errorMessage logicCode:(NSInteger)logicCode {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo safelySetObject:errorMessage forKey:kQBSErrorMessageKeyName];
    if (logicCode != kQBSInvalidLogicErrorCode) {
        [userInfo setObject:@(logicCode) forKey:kQBSLogicErrorCodeKeyName];
    }
    
    return [self errorWithDomain:domain code:code userInfo:userInfo.count > 0 ? userInfo : nil];
}
@end
