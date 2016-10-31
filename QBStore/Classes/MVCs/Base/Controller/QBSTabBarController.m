//
//  QBSTabBarController.m
//  QBStore
//
//  Created by Sean Yue on 2016/10/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSTabBarController.h"
#import "QBSNavigationController.h"
#import "QBSHomeViewController.h"
#import "QBSCategoryViewController.h"
#import "QBSCartViewController.h"
#import "QBSMineViewController.h"

@interface QBSTabBarController ()

@end

@implementation QBSTabBarController

+ (instancetype)sharedTabBarController {
    static QBSTabBarController *_sharedTabBarController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        QBSHomeViewController *homeVC = [[QBSHomeViewController alloc] init];
        homeVC.title = @"首页";
        homeVC.showCartButton = NO;
        homeVC.showOrderListButton = NO;
        homeVC.showCategoryButton = NO;
        
        QBSNavigationController *homeNav = [[QBSNavigationController alloc] initWithRootViewController:homeVC];
        homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:homeVC.title
                                                           image:[UIImage imageNamed:@"tabbar_home_normal"]
                                                   selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
        
        QBSCategoryViewController *categoryVC = [[QBSCategoryViewController alloc] init];
        categoryVC.title = @"分类";
        
        QBSNavigationController *categoryNav = [[QBSNavigationController alloc] initWithRootViewController:categoryVC];
        categoryNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:categoryVC.title
                                                               image:[[UIImage imageNamed:@"tabbar_category_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                       selectedImage:[UIImage imageNamed:@"tabbar_category_selected"]];
        
        QBSCartViewController *cartVC = [[QBSCartViewController alloc] init];
        cartVC.title = @"购物车";
        
        QBSNavigationController *cartNav = [[QBSNavigationController alloc] initWithRootViewController:cartVC];
        cartNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:cartVC.title
                                                           image:[[UIImage imageNamed:@"tabbar_cart_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                   selectedImage:[UIImage imageNamed:@"tabbar_cart_selected"]];
        
        QBSMineViewController *mineVC = [[QBSMineViewController alloc] init];
        mineVC.title = @"我的";
        
        QBSNavigationController *mineNav = [[QBSNavigationController alloc] initWithRootViewController:mineVC];
        mineNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:mineVC.title
                                                           image:[[UIImage imageNamed:@"tabbar_mine_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                   selectedImage:[UIImage imageNamed:@"tabbar_mine_selected"]];
        
        _sharedTabBarController = [[self alloc] init];
        _sharedTabBarController.viewControllers = @[homeNav,categoryNav,cartNav,mineNav];
        _sharedTabBarController.tabBar.tintColor = kQBSThemeColor;
        _sharedTabBarController.tabBar.translucent = NO;
    });
    return _sharedTabBarController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
