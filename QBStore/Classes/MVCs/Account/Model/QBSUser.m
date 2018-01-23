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
NSString *const kQBSUserLoginNotification = @"com.qbstore.notification.userlogin";
NSString *const kQBSUserLogoutNotification = @"com.qbstore.notification.userlogout";

static NSString *const kUserDefaultsCurrentUserKey = @"com.qbstore.userdefaults.currentuser";

static NSString *const kUserDefaultsUserRecords = @"com.qbstore.userdefaults.userrecords";
static NSString *const kUserRecordsActivityTicketPromptionReviewedKey = @"activityTicketPromptionReviewed";

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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kQBSUserLoginNotification object:self];
}

- (void)logout {
    if (![self isLogin]) {
        return ;
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsCurrentUserKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _currentUser = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kQBSUserLogoutNotification object:nil];
}

- (NSString *)nickName {
    if ([self.userType isEqualToString:kQBSUserTypeNormal]) {
        return self.mobile;
    } else if ([self.userType isEqualToString:kQBSUserTypeWeChat]) {
        return self.name;
    } else {
        return nil;
    }
}

- (void)didReviewActivityTicketPromption {
    if (!self.isLogin) {
        return ;
    }
    
    NSDictionary *userRecords = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserRecords];
    
    NSMutableDictionary *userRecordsM = userRecords.mutableCopy;
    if (!userRecordsM) {
        userRecordsM = [NSMutableDictionary dictionary];
    }
    
    NSArray *promptionReviewedUsers = [userRecords objectForKey:kUserRecordsActivityTicketPromptionReviewedKey];
    
    NSMutableArray *promptionReviewedUsersM = promptionReviewedUsers.mutableCopy;
    if (!promptionReviewedUsersM) {
        promptionReviewedUsersM = [NSMutableArray array];
        [userRecordsM setObject:promptionReviewedUsersM forKey:kUserRecordsActivityTicketPromptionReviewedKey];
    }
    
    [promptionReviewedUsersM addObject:self.userId];
    [[NSUserDefaults standardUserDefaults] setObject:userRecordsM forKey:kUserDefaultsUserRecords];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)shouldPromptActivityTicket {
    if (!self.isLogin) {
        return YES;
    }
    
    NSDictionary *userRecords = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUserRecords];
    NSArray *promptionReviewedUsers = [userRecords objectForKey:kUserRecordsActivityTicketPromptionReviewedKey];
    return ![promptionReviewedUsers containsObject:self.userId];
}
@end

@implementation QBSUserLoginResponse

@end
