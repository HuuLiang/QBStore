//
//  QBSUser.h
//  Pods
//
//  Created by Sean Yue on 16/7/27.
//
//

#import <Foundation/Foundation.h>
#import "QBSJSONResponse.h"

#define QBSCurrentUserIsLogin ([QBSUser currentUser].isLogin)

@interface QBSUser : NSObject

@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *accessToken;

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *sex;
@property (nonatomic) NSNumber *age;
@property (nonatomic) NSString *mobile;
@property (nonatomic) NSString *userType;
@property (nonatomic) NSString *openid;
@property (nonatomic) NSString *logoUrl;
@property (nonatomic) NSString *veriCode;
//@property (nonatomic) NSString *uuid;

+ (instancetype)currentUser;
- (BOOL)isValid;
- (BOOL)isLogin;
- (void)login;
- (void)logout;
- (NSString *)nickName;

- (void)didReviewActivityTicketPromption;
- (BOOL)shouldPromptActivityTicket;

@end

// QBSUser.sex
extern NSString *const kQBSUserSexMale;
extern NSString *const kQBSUserSexFemale;

// QBSUser.userType
extern NSString *const kQBSUserTypeNormal;
extern NSString *const kQBSUserTypeWeChat;

@interface QBSUserLoginResponse : QBSJSONResponse

@property (nonatomic) NSString *data;
@property (nonatomic) NSString *accessToken;

@end

extern NSString *const kQBSUserShouldReLoginNotification;
extern NSString *const kQBSUserLoginNotification;
extern NSString *const kQBSUserLogoutNotification;
