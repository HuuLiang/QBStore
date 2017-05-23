//
//  QBSMineViewController.m
//  QBStore
//
//  Created by Sean Yue on 2016/10/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSMineViewController.h"
#import "QBSMineCell.h"
#import "QBSTableHeaderFooterView.h"
#import "QBSMineAvatarView.h"

#import "QBSShippingAddressListViewController.h"
#import "QBSOrderListViewController.h"
#import "QBSCustomerServiceController.h"

#import "QBSWebViewController.h"

typedef NS_ENUM(NSUInteger, QBSMineSection) {
    QBSMineOrderSection,
//    QBSMineActivitySection,
    QBSMineOtherSection,
    QBSMineSectionCount
};

typedef NS_ENUM(NSUInteger, QBSOrderSectionRow) {
    QBSOrderRow,
    QBSShippingAddressRow,
    QBSOrderSectionRowCount
};

typedef NS_ENUM(NSUInteger, QBSOtherSectionRow) {
    QBSAgreementRow,
    QBSContactRow,
    QBSAboutRow,
    QBSOtherSectionRowCount
};

static NSString *const kMineCellReusableIdentifier = @"MineCellReusableIdentifier";
static NSString *const kHeaderViewReusableIdentifier = @"HeaderViewReusableIdentifier";

@interface QBSMineViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTV;
    QBSMineAvatarView *_avatarView;
}
@end

@implementation QBSMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _layoutTV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _layoutTV.backgroundColor = self.view.backgroundColor;
    _layoutTV.delegate = self;
    _layoutTV.dataSource = self;
    _layoutTV.rowHeight = MAX(kScreenHeight*0.075, 44);
    _layoutTV.sectionFooterHeight = 0;
    _layoutTV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_layoutTV registerClass:[QBSMineCell class] forCellReuseIdentifier:kMineCellReusableIdentifier];
    [_layoutTV registerClass:[QBSTableHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kHeaderViewReusableIdentifier];
    [self.view addSubview:_layoutTV];
    {
        [_layoutTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    _avatarView = [[QBSMineAvatarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.4)];
    _avatarView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.66];
    _layoutTV.tableHeaderView = _avatarView;
    
    @weakify(self);
    _avatarView.avatarAction = ^(id obj) {
        @strongify(self);
        if (!QBSCurrentUserIsLogin) {
            [QBSUIHelper presentLoginViewControllerIfNotLoginInViewController:self withCompletionHandler:nil];
        } else {
            [UIAlertView bk_showAlertViewWithTitle:@"您是否确认退出当前账号？"
                                           message:nil
                                 cancelButtonTitle:@"取消"
                                 otherButtonTitles:@[@"确认"]
                                           handler:^(UIAlertView *alertView, NSInteger buttonIndex)
            {
                if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确认"]) {
                    [[QBSUser currentUser] logout];
//                    [self updateAvatarView];
                }
            }];
        }
    };
    
    [self updateAvatarView];
    self.navigationItem.title = nil;
//    self.navigationController.navigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAvatarView) name:kQBSUserLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAvatarView) name:kQBSUserLogoutNotification object:nil];
}

- (BOOL)alwaysHideNavigationBar {
    return YES;
}

- (void)updateAvatarView {
    if (QBSCurrentUserIsLogin) {
        _avatarView.title = [QBSUser currentUser].nickName;
        _avatarView.placeholderImage = [UIImage imageNamed:@"avatar_placeholder"];
        _avatarView.imageURL = [NSURL URLWithString:[QBSUser currentUser].logoUrl];
    } else {
        _avatarView.placeholderImage = [UIImage imageNamed:@"avatar_placeholder"];
        _avatarView.title = @"点击登录";
    }
}

- (void)showOrderListViewController {
    self.tabBarController.selectedViewController = self.navigationController;
    
    QBSOrderListViewController *orderListVC = [[QBSOrderListViewController alloc] init];
    [self.navigationController pushViewController:orderListVC animated:YES];
}

//- (void)showTicketViewController {
//    self.tabBarController.selectedViewController = self.navigationController;
//    
//    QBSTicketsViewController *ticketVC = [[QBSTicketsViewController alloc] init];
//    [self.navigationController pushViewController:ticketVC animated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return QBSMineSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == QBSMineOrderSection) {
        return QBSOrderSectionRowCount;
    } else if (section == QBSMineOtherSection) {
        return QBSOtherSectionRowCount;
//    } else if (section == QBSMineActivitySection) {
//        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QBSMineCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineCellReusableIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == QBSMineOrderSection) {
        if (indexPath.row == QBSOrderRow) {
            cell.iconImage = [UIImage imageNamed:@"mine_order_icon"];
            cell.title = @"我的订单";
        } else if (indexPath.row == QBSShippingAddressRow) {
            cell.iconImage = [UIImage imageNamed:@"mine_address_icon"];
            cell.title = @"收货地址";
        }
//    } else if (indexPath.section == QBSMineActivitySection) {
//        cell.iconImage = [UIImage imageNamed:@"mine_activity_icon"];
//        cell.title = @"活动专区";
    } else if (indexPath.section == QBSMineOtherSection) {
        if (indexPath.row == QBSAgreementRow) {
            cell.iconImage = [UIImage imageNamed:@"mine_agreement_icon"];
            cell.title = @"用户协议";
        } else if (indexPath.row == QBSContactRow) {
            cell.iconImage = [UIImage imageNamed:@"mine_contact_icon"];
            cell.title = @"联系客服";
        } else if (indexPath.row == QBSAboutRow) {
            cell.iconImage = [UIImage imageNamed:@"mine_about_icon"];
            cell.title = @"关于我们";
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QBSTableHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderViewReusableIdentifier];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == QBSMineOrderSection) {
        if (indexPath.row == QBSOrderRow) {
            QBSOrderListViewController *orderListVC = [[QBSOrderListViewController alloc] init];
            [self.navigationController pushViewController:orderListVC animated:YES];
        } else if (indexPath.row == QBSShippingAddressRow) {
            QBSShippingAddressListViewController *addressListVC = [[QBSShippingAddressListViewController alloc] init];
            [self.navigationController pushViewController:addressListVC animated:YES];
        }
//    } else if (indexPath.section == QBSMineActivitySection) {
//        QBSTicketsViewController *ticketsVC = [[QBSTicketsViewController alloc] init];
//        [self.navigationController pushViewController:ticketsVC animated:YES];
    } else if (indexPath.section == QBSMineOtherSection) {
        if (indexPath.row == QBSAgreementRow) {
            QBSWebViewController *webVC = [[QBSWebViewController alloc] initWithURL:[NSURL URLWithString:[kQBSRESTBaseURL stringByAppendingString:kQBSUserAgreementURL]]];
            webVC.title = @"用户协议";
            [self.navigationController pushViewController:webVC animated:YES];
        } else if (indexPath.row == QBSContactRow) {
            QBSCustomerServiceController *csController = [[QBSCustomerServiceController alloc] init];
            [csController showInView:self.view.window];
        } else if (indexPath.row == QBSAboutRow) {
            QBSMineCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            NSURL *url = [NSURL URLWithString:[kQBSRESTBaseURL stringByAppendingString:kQBSAboutURL]];
            [self.navigationController pushViewController:[QBSUIHelper webViewControllerWithURL:url title:cell.title] animated:YES];
        }
    }
}
@end
