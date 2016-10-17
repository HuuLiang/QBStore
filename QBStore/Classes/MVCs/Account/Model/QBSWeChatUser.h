//
//  QBSWeChatUser.h
//  Pods
//
//  Created by Sean Yue on 16/7/28.
//
//

#import <Foundation/Foundation.h>
#import "QBSUser.h"

@interface QBSWeChatUser : NSObject

@property (nonatomic) NSString *openid;
@property (nonatomic) NSString *nickname;
@property (nonatomic) NSNumber *sex;
@property (nonatomic) NSString *province;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *country;
@property (nonatomic) NSString *headimgurl;
@property (nonatomic) NSString *unionid;

@end

@interface QBSUser (QBSWeChatUser)

+ (instancetype)userFromWeChat:(QBSWeChatUser *)weChatUser;

@end