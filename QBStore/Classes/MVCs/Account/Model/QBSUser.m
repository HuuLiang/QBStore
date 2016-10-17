//
//  QBSUser.m
//  Pods
//
//  Created by Sean Yue on 16/7/27.
//
//

#import "QBSUser.h"

NSString *const kQBSUserSexMale = @"M";
NSString *const kQBSUserSexFemale = @"F";

NSString *const kQBSUserTypeNormal = @"NORMAL";
NSString *const kQBSUserTypeWeChat = @"WEIXIN";

NSString *const kQBSUserShouldReLoginNotification = @"com.qbstore.notification.usershouldrelogin";

static NSString *kUserDefaultsCurrentUserKey = @"com.qbstore.userdefaults.currentuser";
static QBSUser *_currentUser;

@implementation QBSUser

+ (instancetype)currentUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCurrentUserKey];
        _currentUser = [self objectFromDictionary:dic];;
    });
    return _currentUser;
}

- (BOOL)isValid {
    if ([self.userType isEqualToString:kQBSUserTypeNormal]) {
        return self.mobile.length > 0;
    } else if ([self.userType isEqualToString:kQBSUserTypeWeChat]) {
        return self.name.length > 0 && self.openid.length > 0;
    }
    return NO;
}

- (BOOL)isLogin {
    return self.userType.length > 0 && self.userId.length > 0 && self.accessToken.length > 0;
}

- (void)login {
    if (![self isLogin]) {
        return ;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[self dictionaryRepresentation] forKey:kUserDefaultsCurrentUserKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _currentUser = self;
}

- (void)logout {
    if (![self isLogin]) {
        return ;
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsCurrentUserKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _currentUser = nil;
}

@end

@implementation QBSUserLoginResponse

@end