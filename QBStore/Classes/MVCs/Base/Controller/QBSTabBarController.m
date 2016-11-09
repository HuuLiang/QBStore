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
#import "QBSCartCommodity.h"

@interface QBSTabBarController () <DBPersistentObserver>
@property (nonatomic,retain) UITabBarItem *cartTabBarItem;
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
                                                           image:[[UIImage imageNamed:@"tabbar_home_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                   selectedImage:[[UIImage imageNamed:@"tabbar_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        QBSCategoryViewController *categoryVC = [[QBSCategoryViewController alloc] init];
        categoryVC.title = @"分类";
        
        QBSNavigationController *categoryNav = [[QBSNavigationController alloc] initWithRootViewController:categoryVC];
        categoryNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:categoryVC.title
                                                               image:[[UIImage imageNamed:@"tabbar_category_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                       selectedImage:[[UIImage imageNamed:@"tabbar_category_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        QBSCartViewController *cartVC = [[QBSCartViewController alloc] init];
        cartVC.title = @"购物车";
        
        QBSNavigationController *cartNav = [[QBSNavigationController alloc] initWithRootViewController:cartVC];
        cartNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:cartVC.title
                                                           image:[[UIImage imageNamed:@"tabbar_cart_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                   selectedImage:[[UIImage imageNamed:@"tabbar_cart_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        QBSMineViewController *mineVC = [[QBSMineViewController alloc] init];
        mineVC.title = @"我的";
        
        QBSNavigationController *mineNav = [[QBSNavigationController alloc] initWithRootViewController:mineVC];
        mineNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:mineVC.title
                                                           image:[[UIImage imageNamed:@"tabbar_mine_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                   selectedImage:[[UIImage imageNamed:@"tabbar_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        _sharedTabBarController = [[self alloc] init];
        _sharedTabBarController.viewControllers = @[homeNav,categoryNav,cartNav,mineNav];
        _sharedTabBarController.tabBar.tintColor = kQBSThemeColor;
//        _sharedTabBarController.tabBar.barTintColor = [UIColor colorWithHexString:@"#970669"];
        _sharedTabBarController.tabBar.translucent = NO;
        _sharedTabBarController.cartTabBarItem = cartNav.tabBarItem;

        [_sharedTabBarController updateBadgeValue];
        
        [QBSCartCommodity registerObserver:_sharedTabBarController];
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

- (void)updateBadgeValue {
    [QBSCartCommodity totalAmountAsync:^(NSUInteger amount) {
        self.cartTabBarItem.badgeValue = amount == 0 ? nil : amount > 100 ? @"100+" : @(amount).stringValue;
    }];
}

#pragma mark - DBPersistentObserver

- (void)DBPersistentClass:(Class)class didFinishOperation:(DBPersistenceOperation)operation {
    if (class == [QBSCartCommodity class]) {
        [self updateBadgeValue];
    }
}

@end
