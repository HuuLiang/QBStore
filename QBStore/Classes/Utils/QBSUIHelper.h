//
//  QBSUIHelper.h
//  Pods
//
//  Created by Sean Yue on 16/7/27.
//
//

#import <Foundation/Foundation.h>

@class QBSOrder;

@interface QBSUIHelper : NSObject

+ (void)presentLoginViewControllerIfNotLoginInViewController:(UIViewController *)viewController
                                       withCompletionHandler:(void (^)(BOOL success))completionHandler;

+ (void)presentUserProfileViewControllerInViewController:(UIViewController *)viewController;

+ (BOOL)viewControllerIsDependsOnUserLogin:(UIViewController *)viewController;
//+ (void)logoutInViewController:(UIViewController *)viewController;
+ (void)logoutInNavigationController:(UINavigationController *)navController;

+ (void)showPaymentSheetWithAction:(QBSAction)action;

+ (UIViewController *)webViewControllerWithURL:(NSURL *)url title:(NSString *)title;

#ifdef DEBUG_TOOL_ENABLED
+ (void)showOrderDebugPanelInViewController:(UIViewController *)viewController
                                  withOrder:(QBSOrder *)order
                               updateAction:(QBSAction)updateAction;
#endif

@end
