//
//  QBStoreSystem.h
//  QBStore
//
//  Created by Sean Yue on 2016/12/21.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBStoreSystem : NSObject

+ (instancetype)sharedSystem;

- (void)applicationDidFinishLaunch;
- (NSUInteger)launchSequence;

@end
