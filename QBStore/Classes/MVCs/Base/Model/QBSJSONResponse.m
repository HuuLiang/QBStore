//
//  QBSJSONResponse.m
//  Pods
//
//  Created by Sean Yue on 16/7/7.
//
//

#import "QBSJSONResponse.h"

@interface QBSJSONResponse ()

@end

@implementation QBSJSONResponse

//- (BOOL)success {
//    return self.code.integerValue == 200;
//}

- (void)setCode:(NSNumber *)code {
    _code = code;
    _success = code.integerValue == 200;
    _userShouldReLogin = code.integerValue == 1014;
}

SynthesizePropertyClassMethod(paginator, QBSPaginator)

@end

@implementation QBSPaginator

@end