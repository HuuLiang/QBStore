//
//  QBStoreSystem.m
//  QBStore
//
//  Created by Sean Yue on 2016/12/21.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBStoreSystem.h"

static NSString *const kLaunchSequenceUserDefaultsKey = @"com.qbstore.launchsequence";

@implementation QBStoreSystem

+ (instancetype)sharedSystem {
    static QBStoreSystem *_sharedSystem;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSystem = [[self alloc] init];
    });
    return _sharedSystem;
}

- (void)applicationDidFinishLaunch {
    NSUInteger launchSeq = [self launchSequence];
    [[NSUserDefaults standardUserDefaults] setObject:@(launchSeq+1) forKey:kLaunchSequenceUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSUInteger)launchSequence {
    NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:kLaunchSequenceUserDefaultsKey];
    return value.unsignedIntegerValue;
}
@end
