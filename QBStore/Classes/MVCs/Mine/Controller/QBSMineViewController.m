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
#import "QBSSnatchCell.h"
#import "QBSOrderCell.h"
#import "QBSOrderStatusCell.h"

#import "QBSShippingAddressListViewController.h"
#import "QBSOrderListViewController.h"
#import "QBSCustomerServiceController.h"
#import "QBSSnatchTreasureListViewController.h"
#import "QBSCouponViewController.h"

#import "QBSWebViewController.h"

typedef NS_ENUM(NSUInteger, QBSMineSection) {
    QBSSnatchTreasureSection,//夺宝
    QBSMineOrderSection,
//    QBSMineActivitySection,
    QBSMineOtherSection,
    QBSLastSection = QBSMineOtherSection,
    QBSMineSectionCount
};

typedef NS_ENUM(NSUInteger, QBSOrderSectionRow) {
    QBSOrderRow,
    QBOrderStatusRow,
    QBSOrderSectionRowCount
};

typedef NS_ENUM(NSUInteger, QBSActivateSectionRow) {
    QBSDeliveryRow,//收货地址
    QBSActivateRow,//活动专区
    QBSActivateSetionCount
};

typedef NS_ENUM(NSUInteger, QBSOtherSectionRow) {
    QBSAgreementRow,
    QBSContactRow,
    QBUpdateRow,
    QBSAboutRow,
    QBSOtherSectionRowCount
};

static NSString *const kMineCellReusableIdentifier = @"MineCellReusableIdentifier";
static NSString *const kHeaderViewReusableIdentifier = @"HeaderViewReusableIdentifier";
static NSString *const kSnatchCellIdentifier = @"QBSSnatchCellIdentifier";//夺宝
static NSString *const kOrderCellIdentifier = @"QBSOrderCellIdentifier";//订单
static NSString *const kOrderStatusCellIdentifier = @"QBSOrderStatusCellIdentifier";//订单状态


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
    _layoutTV.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    [_layoutTV registerClass:[QBSMineCell class] forCellReuseIdentifier:kMineCellReusableIdentifier];
    [_layoutTV registerClass:[QBSTableHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kHeaderViewReusableIdentifier];
    [_layoutTV registerClass:[QBSSnatchCell class] forCellReuseIdentifier:kSnatchCellIdentifier];
    [_layoutTV registerClass:[QBSOrderCell class] forCellReuseIdentifier:kOrderCellIdentifier];
    [_layoutTV registerClass:[QBSOrderStatusCell class] forCellReuseIdentifier:kOrderStatusCellIdentifier];
    [self.view addSubview:_layoutTV];
    {
        [_layoutTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    _avatarView = [[QBSMineAvatarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.46)];
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
        _avatarView.showTitleAsButtonStyle = NO;
    } else {
        _avatarView.placeholderImage = [UIImage imageNamed:@"avatar_placeholder"];
        _avatarView.title = @"点击登录";
        _avatarView.showTitleAsButtonStyle = YES;
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
    if (section == QBSSnatchTreasureSection){
        return 1;
    }else if (section == QBSMineOrderSection) {
        return QBSOrderSectionRowCount;
    } else if (section == QBSMineOtherSection) {
        return QBSOtherSectionRowCount;
//    } else if (section == QBSMineActivitySection) {
//        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QBSMineCell *cell;
    if (indexPath.section != QBSSnatchTreasureSection && indexPath.section != QBSMineOrderSection) {
       cell = [tableView dequeueReusableCellWithIdentifier:kMineCellReusableIdentifier forIndexPath:indexPath];
       cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
//    @weakify(self);
    if (indexPath.section == QBSSnatchTreasureSection) {//夺宝
        QBSSnatchCell *snatchCell = [tableView dequeueReusableCellWithIdentifier:kSnatchCellIdentifier forIndexPath:indexPath];
        snatchCell.selectionStyle = UITableViewCellSelectionStyleNone;
        snatchCell.snatchAction = ^(id sender){
//            @strongify(self);//点击夺宝
            QBSSnatchTreasureListViewController *snatchVC = [[QBSSnatchTreasureListViewController alloc] init];
            [self.navigationController pushViewController:snatchVC animated:YES];
            
        };
        snatchCell.couponAction = ^ (id sender){
        //            @strongify(self);//点击优惠券
            QBSCouponViewController *couponVC = [[QBSCouponViewController alloc] init];
            [self.navigationController pushViewController:couponVC animated:YES];
        
        };
        return snatchCell;
    }else if (indexPath.section == QBSMineOrderSection) {
        if (indexPath.row == QBSOrderRow) {
            QBSOrderCell *orderCell = [tableView dequeueReusableCellWithIdentifier:kOrderCellIdentifier forIndexPath:indexPath];
            orderCell.title = @"我的订单";
            orderCell.subTitle = @"全部订单";
        return orderCell;
        }else if (indexPath.row == QBOrderStatusRow){
            QBSOrderStatusCell *statusCell = [tableView dequeueReusableCellWithIdentifier:kOrderStatusCellIdentifier forIndexPath:indexPath];
            
            statusCell.models = @[[QBSorderStatusModel creatOrderStatusModelWithTitle:@"待付款" image:@"mine_ obligation_icon"],
                                [QBSorderStatusModel creatOrderStatusModelWithTitle:@"待发货" image:@"mine_wait_ shipments_icon"],
                                [QBSorderStatusModel creatOrderStatusModelWithTitle:@"待收货" image:@"mine_ wait_ receive_icon"],
                                [QBSorderStatusModel creatOrderStatusModelWithTitle:@"待评价" image:@"mine_wait_ appraise_icon"]];
            statusCell.orderStatusAction = ^(UIButton *button){
//                @strongify(self); //点击发货状态
                
            };
            
            return statusCell;
        }
        
    } else if (indexPath.section == QBSMineActivitySection) {
        if (indexPath.row == QBSDeliveryRow) {
            cell.iconImage = [UIImage imageNamed:@"mine_address_icon"];
            cell.title  = @"收货地址";
 //       }else if(indexPath.row == QBSActivateRow){
 //       cell.iconImage = [UIImage imageNamed:@"mine_activity_icon"];
 //           cell.title = @"活动专区";
        }
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
        }else if (indexPath.row == QBUpdateRow) {
            cell.iconImage = [UIImage imageNamed:@"mine_update_icon"];
            cell.title = @"检查更新";
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == QBSLastSection) {
        return 10;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == QBSSnatchTreasureSection) {
        return MAX(kScreenHeight*0.078, 44);
    } else if (indexPath.section == QBSMineOrderSection){
        if (indexPath.row == QBSOrderRow) {
            return 44;
        } else if (indexPath.row == QBOrderStatusRow) {
            return MIN(kScreenHeight*0.146, 88);
        }
    }
    
    return MAX(kScreenHeight*0.07, 44);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == QBSMineOrderSection) {
        if (indexPath.row == QBSOrderRow) {
            QBSOrderListViewController *orderListVC = [[QBSOrderListViewController alloc] init];
            [self.navigationController pushViewController:orderListVC animated:YES];
        }
        
    } else if (indexPath.section == QBSMineActivitySection) {
        if (indexPath.row == QBSDeliveryRow) {
            QBSShippingAddressListViewController *addressListVC = [[QBSShippingAddressListViewController alloc] init];
            [self.navigationController pushViewController:addressListVC animated:YES];
        }else if (indexPath.row == QBSActivateRow){
            QBSTicketsViewController *ticketsVC = [[QBSTicketsViewController alloc] init];
            [self.navigationController pushViewController:ticketsVC animated:YES];
        }
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
