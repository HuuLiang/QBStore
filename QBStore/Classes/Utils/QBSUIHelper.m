//
//  QBSUIHelper.m
//  Pods
//
//  Created by Sean Yue on 16/7/27.
//
//

#import "QBSUIHelper.h"
#import "QBSUserNavigationController.h"
#import "QBSUserLoginViewController.h"
#import "QBSUserProfileViewController.h"
#import "QBSDebugOrderInfoViewController.h"
#import "QBSPaymentSheet.h"
#import "QBSUser.h"


@implementation QBSUIHelper

+ (void)presentLoginViewControllerIfNotLoginInViewController:(UIViewController *)viewController
                                       withCompletionHandler:(void (^)(BOOL success))completionHandler
{
    if (QBSCurrentUserIsLogin) {
        SafelyCallBlock(completionHandler, YES);
        return ;
    }
    
    QBSUserLoginViewController *loginVC = [[QBSUserLoginViewController alloc] init];
    loginVC.completionHandler = completionHandler;
    
    QBSUserNavigationController *nav = [[QBSUserNavigationController alloc] initWithRootViewController:loginVC];
    [viewController presentViewController:nav animated:YES completion:nil];
}

+ (void)presentUserProfileViewControllerInViewController:(UIViewController *)viewController {
    if (!QBSCurrentUserIsLogin) {
        return ;
    }
    
    @weakify(viewController);
    QBSUserProfileViewController *profileVC = [[QBSUserProfileViewController alloc] initWithLogoutAction:^(id obj) {
        @strongify(viewController);
        [self logoutInNavigationController:viewController.navigationController];
    }];
    
    QBSUserNavigationController *nav = [[QBSUserNavigationController alloc] initWithRootViewController:profileVC];
    [viewController presentViewController:nav animated:YES completion:nil];
}

+ (BOOL)viewControllerIsDependsOnUserLogin:(UIViewController *)viewController {
    if ([viewController respondsToSelector:@selector(isViewControllerDependsOnUserLogin)]
        && [viewController performSelector:@selector(isViewControllerDependsOnUserLogin)]) {
        return YES;
    }
    return NO;
}

//+ (void)logoutInViewController:(UIViewController *)viewController {
//    [[QBSUser currentUser] logout];
//    
//    if (![self viewControllerIsDependsOnUserLogin:viewController]) {
//        return ;
//    }
//    
//    __block NSUInteger firstVCIndexWhichDependsOnLogin = 0;
//    [viewController.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([self viewControllerIsDependsOnUserLogin:obj]) {
//            *stop = YES;
//            firstVCIndexWhichDependsOnLogin = idx > 0 ? idx-1:0;
//        }
//    }];
//    
//    if (firstVCIndexWhichDependsOnLogin > 0) {
//        [viewController.navigationController popToViewController:viewController.navigationController.viewControllers[firstVCIndexWhichDependsOnLogin] animated:YES];
//    } else {
//        [viewController.navigationController popToRootViewControllerAnimated:YES];
//    }
//}

+ (void)logoutInNavigationController:(UINavigationController *)navController {
    [[QBSUser currentUser] logout];
    
    __block NSUInteger popToViewControllerIndex = 0;
    [navController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self viewControllerIsDependsOnUserLogin:obj]) {
            *stop = YES;
        } else {
            popToViewControllerIndex = idx;
        }
    }];
    
    if (popToViewControllerIndex >= navController.viewControllers.count - 1) {
        return ;
    }
    
    [navController popToViewController:navController.viewControllers[popToViewControllerIndex] animated:YES];
}

+ (void)showPaymentSheetWithAction:(QBSAction)action {
    QBSPaymentSheet *paymentSheet = [[QBSPaymentSheet alloc] init];
    paymentSheet.paymentAction = action;
    [paymentSheet showInWindow];
}

+ (UIViewController *)webViewControllerWithURL:(NSURL *)url title:(NSString *)title {
    UIViewController *webVC = [[UIViewController alloc] init];
    webVC.title = title;
    webVC.hidesBottomBarWhenPushed = YES;
    
    UIWebView *webView = [[UIWebView alloc] init];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[kQBSRESTBaseURL stringByAppendingString:kQBSAboutURL]]]];
    webVC.view = webView;
    return webVC;
}

#ifdef DEBUG_TOOL_ENABLED
+ (void)showOrderDebugPanelInViewController:(UIViewController *)viewController
                                  withOrder:(QBSOrder *)order
                               updateAction:(QBSAction)updateAction
{
    QBSDebugOrderInfoViewController *debugVC = [[QBSDebugOrderInfoViewController alloc] initWithOrder:order];
    debugVC.orderUpdateAction = updateAction;
    [viewController.navigationController pushViewController:debugVC animated:YES];
}
#endif
@end
