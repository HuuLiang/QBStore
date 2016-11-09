//
//  QBSNavigationController.m
//  Pods
//
//  Created by Sean Yue on 16/8/4.
//
//

#import "QBSNavigationController.h"
#import "QBSUser.h"
#import "QBSBaseViewController.h"
#import "QBSTabBarController.h"

@interface QBSNavigationController () <UINavigationControllerDelegate>

@end

@implementation QBSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.]};
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    self.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserShouldReLogin:) name:kQBSUserShouldReLoginNotification object:nil];
}

- (void)onUserShouldReLogin:(NSNotification *)notification {
    @weakify(self);
    NSError *error = notification.object;
    
    if ([QBSTabBarController sharedTabBarController].selectedViewController == self) {
        [UIAlertView bk_showAlertViewWithTitle:error.qbsErrorMessage//@"登录异常或登录过期，您需要重新登录！"
                                       message:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil
                                       handler:^(UIAlertView *alertView,
                                                 NSInteger buttonIndex)
         {
             @strongify(self);
             [QBSUIHelper logoutInNavigationController:self];
         }];
    } else {
        [QBSUIHelper logoutInNavigationController:self];
    }
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([QBSUIHelper viewControllerIsDependsOnUserLogin:viewController] && !QBSCurrentUserIsLogin) {
        [QBSUIHelper presentLoginViewControllerIfNotLoginInViewController:self withCompletionHandler:^(BOOL success) {
            if (success) {
                [super pushViewController:viewController animated:animated];
            }
        }];
    } else {
        [super pushViewController:viewController animated:animated];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL alwaysHideNavigationBar = NO;
    if ([viewController isKindOfClass:[QBSBaseViewController class]]) {
        alwaysHideNavigationBar = ((QBSBaseViewController *)viewController).alwaysHideNavigationBar;
    }
    if (self.navigationBarHidden != alwaysHideNavigationBar) {
        [self setNavigationBarHidden:alwaysHideNavigationBar animated:animated];
    }
}
@end
