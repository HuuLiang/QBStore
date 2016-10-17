//
//  QBSConfiguration.m
//  Pods
//
//  Created by Sean Yue on 16/7/6.
//
//

#import "QBSConfiguration.h"

@implementation QBSConfiguration

+ (instancetype)defaultConfiguration {
    static QBSConfiguration *_defaultConfiguration;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultConfiguration = [[self alloc] init];
    });
    return _defaultConfiguration;
}
@end
