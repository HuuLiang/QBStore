//
//  NSError+QBSError.h
//  Pods
//
//  Created by Sean Yue on 16/8/2.
//
//

#import <Foundation/Foundation.h>

@interface NSError (QBSError)

@property (nonatomic) NSString *qbsErrorMessage;
@property (nonatomic,readonly) NSInteger logicCode;

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code errorMessage:(NSString *)errorMessage;
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code errorMessage:(NSString *)errorMessage logicCode:(NSInteger)logicCode;

@end

extern NSString *const kQBSErrorMessageKeyName;
extern NSString *const kQBSLogicErrorCodeKeyName;
extern const NSInteger kQBSInvalidLogicErrorCode;