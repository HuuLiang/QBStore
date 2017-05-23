//
//  QBSConfiguration.m
//  Pods
//
//  Created by Sean Yue on 16/7/6.
//
//

#import "QBSConfiguration.h"

@implementation QBSConfiguration
@synthesize channelNo = _channelNo;

+ (instancetype)defaultConfiguration {
    static QBSConfiguration *_defaultConfiguration;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultConfiguration = [[self alloc] init];
    });
    return _defaultConfiguration;
}

- (NSString *)channelNo {
    if (_channelNo) {
        return _channelNo;
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ChannelNo" ofType:@"plist"];
    NSDictionary *channelDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    _channelNo = channelDic[@"ChannelNo"];
    return _channelNo;
}
@end
