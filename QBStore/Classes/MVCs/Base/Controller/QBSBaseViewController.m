//
//  QBSBaseViewController.m
//  Pods
//
//  Created by Sean Yue on 16/6/23.
//
//

#import "QBSBaseViewController.h"
#import "QBSCategoryViewController.h"
#import "QBSCommodityDetailViewController.h"
#import "QBSCommodityListViewController.h"
#import "QBSUser.h"

@interface QBSBaseViewController ()

@end

@implementation QBSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    if (self.navigationController) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"返回" style:UIBarButtonItemStylePlain handler:nil];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    
    @weakify(self);
    if ([self isViewControllerDependsOnUserLogin]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage QBS_imageWithResourcePath:@"account_icon"]
                                                                                     style:UIBarButtonItemStylePlain
                                                                                   handler:^(id sender)
        {
            @strongify(self);
            [QBSUIHelper presentUserProfileViewControllerInViewController:self];
        }];
    }
}

- (BOOL)isViewControllerDependsOnUserLogin {
    return NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc", [self class]);
}

- (void)pushViewControllerWithRecommendType:(QBSRecommendType)recmType
                                 columnType:(QBSColumnType)columnType
                                     isLeaf:(BOOL)isLeaf
                                      relId:(NSNumber *)relId
{
    if (recmType == QBSRecommendTypeCommodity) {
        QBSCommodityDetailViewController *detailVC = [[QBSCommodityDetailViewController alloc] initWithCommodityId:relId columnId:nil];
        [self.navigationController pushViewController:detailVC animated:YES];
    } else if (recmType == QBSRecommendTypeColumn) {
        if (isLeaf) {
            QBSCommodityListViewController *listVC = [[QBSCommodityListViewController alloc] initWithColumnId:relId columnType:columnType columnName:nil];
            [self.navigationController pushViewController:listVC animated:YES];
        } else {
            QBSCategoryViewController *catVC = [[QBSCategoryViewController alloc] initWithPresetColumnId:relId];
            [self.navigationController pushViewController:catVC animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
