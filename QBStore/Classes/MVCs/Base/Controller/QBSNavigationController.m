//
//  QBSNavigationController.m
//  Pods
//
//  Created by Sean Yue on 16/8/4.
//
//

#import "QBSNavigationController.h"
#import "QBSUser.h"

@interface QBSNavigationController ()

@end

@implementation QBSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.]};
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserShouldReLogin:) name:kQBSUserShouldReLoginNotification object:nil];
}

- (void)onUserShouldReLogin:(NSNotification *)notification {
    @weakify(self);
    NSError *error = notification.object;
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
                [super pushViewController:viewController animated:YES];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
