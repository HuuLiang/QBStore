//
//  QBSAppDelegate.m
//  QBStore
//
//  Created by Sean Yue on 2016/10/17.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSAppDelegate.h"
#import "QBSTabBarController.h"
#import "QBSWeChatHelper.h"
#import <UMMobClick/MobClick.h>

@interface QBSAppDelegate ()
@end

@implementation QBSAppDelegate

- (UIWindow *)window {
    if (_window) {
        return _window;
    }
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    _window.rootViewController = [QBSTabBarController sharedTabBarController];
    return _window;
}

- (void)setupMobStatisticsWithChannelNo:(NSString *)channelNo {
    
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    NSString *bundleVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    if (bundleVersion) {
        [MobClick setAppVersion:bundleVersion];
    }
    
    UMConfigInstance.appKey = @"57ff8ee167e58e8faa002b50";
    UMConfigInstance.secret = nil;
    UMConfigInstance.channelId = channelNo;
    [MobClick startWithConfigure:UMConfigInstance];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setupMobStatisticsWithChannelNo:[QBSConfiguration defaultConfiguration].channelNo];
    
    [QBSConfiguration defaultConfiguration].baseURL = kQBSRESTBaseURL;
//    [QBSConfiguration defaultConfiguration].paymentBaseURL = kQBSPaymentBaseURL;
    [QBSConfiguration defaultConfiguration].RESTAppId = kQBSRESTAppId;
//    [QBSConfiguration defaultConfiguration].paymentRESTVersion = @(kQBSPaymentPv.integerValue);
    
    [[QBSWeChatHelper sharedHelper] registerAppId:kQBSWeChatAppId secrect:kQBSWeChatSecret];
    [[QBSRESTManager sharedManager] request_queryCustomerServiceWithCompletionHandler:^(id obj, NSError *error) {
        if (obj) {
            [obj saveAsSharedList];
        }
    }];
    
    [[QBSPaymentManager sharedManager] setup];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    if ([[QBSTabBarController sharedTabBarController] processShortcutItemWithType:shortcutItem.type]) {
        completionHandler(YES);
    } else {
        completionHandler(NO);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [[QBSWeChatHelper sharedHelper] handleOpenURL:url];
    [[QBSPaymentManager sharedManager] handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [[QBSWeChatHelper sharedHelper] handleOpenURL:url];
    [[QBSPaymentManager sharedManager] handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[QBSWeChatHelper sharedHelper] handleOpenURL:url];
    [[QBSPaymentManager sharedManager] handleOpenURL:url];
    return YES;
}
@end
