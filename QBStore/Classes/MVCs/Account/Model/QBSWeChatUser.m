//
//  QBSWeChatUser.m
//  Pods
//
//  Created by Sean Yue on 16/7/28.
//
//

#import "QBSWeChatUser.h"

@implementation QBSWeChatUser

@end

@implementation QBSUser (QBSWeChatUser)

+ (instancetype)userFromWeChat:(QBSWeChatUser *)weChatUser {
    if (!weChatUser) {
        return nil;
    }

    QBSUser *user = [[self alloc] init];
    user.userType = kQBSUserTypeWeChat;
    user.openid = weChatUser.openid;
    user.logoUrl = weChatUser.headimgurl;
    user.name = weChatUser.nickname;
    
    if (weChatUser.sex.unsignedIntegerValue == 1) {
        user.sex = kQBSUserSexMale;
    } else if (weChatUser.sex.unsignedIntegerValue == 2) {
        user.sex = kQBSUserSexFemale;
    }
    return user;
}

@end
