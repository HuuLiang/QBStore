//
//  QBSTabBarController.h
//  QBStore
//
//  Created by Sean Yue on 2016/10/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBSTabBarController : UITabBarController

+ (instancetype)sharedTabBarController;
- (BOOL)processShortcutItemWithType:(NSString *)shortcutItemType;

@end
