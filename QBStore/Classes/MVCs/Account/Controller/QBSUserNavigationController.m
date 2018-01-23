//
//  QBSUserNavigationController.m
//  Pods
//
//  Created by Sean Yue on 16/7/27.
//
//

#import "QBSUserNavigationController.h"

@interface QBSUserNavigationController ()

@end

@implementation QBSUserNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                               NSFontAttributeName:kBigFont};
    self.navigationBar.tintColor = [UIColor whiteColor];
    
}

- (void)dealloc {
    NSLog(@"%@ dealloc", [self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
