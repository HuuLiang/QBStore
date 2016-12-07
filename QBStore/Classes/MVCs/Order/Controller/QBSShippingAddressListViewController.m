//
//  QBSShippingAddressListViewController.m
//  Pods
//
//  Created by Sean Yue on 16/8/2.
//
//

#import "QBSShippingAddressListViewController.h"
#import "QBSTableHeaderFooterView.h"
#import "QBSAddressListCell.h"
#import "QBSNewShippingAddressViewController.h"

#import "QBSShippingAddress.h"

static NSString *const kAddressCellReusableIdentifier = @"AddressCellReusableIdentifier";
static NSString *const kHeaderViewReusableIdentifier = @"HeaderViewReusableIdentifier";

@interface QBSShippingAddressListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_layoutTV;
}
@property (nonatomic,retain) NSMutableArray<QBSShippingAddress *> *addresses;
@end

@implementation QBSShippingAddressListViewController

DefineLazyPropertyInitialization(NSMutableArray, addresses);

- (instancetype)initWithDelegate:(id<QBSShippingAddressListViewControllerDelegate>)delegate {
    self = [self init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收货地址";
    
    _layoutTV = [[UITableView alloc] init];//WithFrame:CGRectZero style:UITableViewStylePlain];
    _layoutTV.backgroundColor = self.view.backgroundColor;
    _layoutTV.delegate = self;
    _layoutTV.dataSource = self;
    _layoutTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_layoutTV.sectionFooterHeight = 0;
    //_layoutTV.tableFooterView = [[UIView alloc] init];
    [_layoutTV registerClass:[QBSTableHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kHeaderViewReusableIdentifier];
    [_layoutTV registerClass:[QBSAddressListCell class] forCellReuseIdentifier:kAddressCellReusableIdentifier];
    [self.view addSubview:_layoutTV];
    
    UIButton *newAddressButton = [[UIButton alloc] init];
    newAddressButton.layer.cornerRadius = 5;
    newAddressButton.layer.masksToBounds = YES;
    [newAddressButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FF206F"]] forState:UIControlStateNormal];
    [newAddressButton setImage:[UIImage QBS_imageWithResourcePath:@"new_address"] forState:UIControlStateNormal];
    [newAddressButton setTitle:@"新增收获地址" forState:UIControlStateNormal];
    [newAddressButton aspect_hookSelector:@selector(titleRectForContentRect:)
                              withOptions:AspectPositionInstead
                               usingBlock:^(id<AspectInfo> aspectInfo, CGRect contentRect)
    {
        CGRect titleRect;
        [[aspectInfo originalInvocation] invoke];
        [[aspectInfo originalInvocation] getReturnValue:&titleRect];
        
        titleRect = CGRectOffset(titleRect, kLeftRightContentMarginSpacing, 0);
        [[aspectInfo originalInvocation] setReturnValue:&titleRect];
    } error:nil];
    [self.view addSubview:newAddressButton];
    {
        [newAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-kTopBottomContentMarginSpacing);
            make.width.equalTo(self.view).multipliedBy(0.8);
            make.height.mas_equalTo(44);
            make.centerX.equalTo(self.view);
        }];
    }
    
    {
        [_layoutTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.bottom.equalTo(newAddressButton.mas_top).offset(-kTopBottomContentMarginSpacing);
        }];
    }
    
    @weakify(self);
    [newAddressButton bk_addEventHandler:^(id sender) {
        
        QBSNewShippingAddressViewController *addressVC = [[QBSNewShippingAddressViewController alloc] initWithCompletionAction:^(id obj) {
            @strongify(self);
            if (obj) {
                QBSShippingAddress *newAddress = obj;
                if (self.addresses.count == 0) {
                    newAddress.isDefault = @1;
                }
                
                [self.addresses addObject:newAddress];
                [self->_layoutTV insertSections:[NSIndexSet indexSetWithIndex:self.addresses.count-1] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
        [self.navigationController pushViewController:addressVC animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    [_layoutTV QBS_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self reloadAddressList];
    }];
    [_layoutTV QBS_triggerPullToRefresh];
    
}

- (void)reloadAddressList {
    @weakify(self);
    [[QBSRESTManager sharedManager] request_queryShippingAddressesWithCompletionHandler:^(id obj, NSError *error) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutTV QBS_endPullToRefresh];
        
        if (obj) {
            QBSShippingAddressList *list = obj;
            self.addresses = list.data.mutableCopy;
            [self->_layoutTV reloadData];
        } else {
            QBSHandleError(error);
        }
    }];
}

- (void)onSetDefaultAddress:(QBSShippingAddress *)address {
    if (address.isDefault.boolValue) {
        return ;
    }
    
    @weakify(self);
    [[QBSHUDManager sharedManager] showLoading];
    [[QBSRESTManager sharedManager] request_setDefaultShippingAddress:address withCompletionHandler:^(id obj, NSError *error) {
        QBSHandleError(error);
        
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if ([obj success]) {
            QBSShippingAddress *prevDefaultAddress = [self.addresses bk_match:^BOOL(QBSShippingAddress *obj) {
                return obj.isDefault.boolValue;
            }];
            prevDefaultAddress.isDefault = @(0);
            address.isDefault = @(1);
            
            [self->_layoutTV reloadData];
        }
    }];
}

- (void)onEditAddress:(QBSShippingAddress *)address {
    @weakify(self);
    QBSNewShippingAddressViewController *addressVC = [[QBSNewShippingAddressViewController alloc] initWithAddress:address
                                                                                                 completionAction:^(id obj)
    {
        @strongify(self);
        if (obj) {
            QBSShippingAddress *newAddress = obj;
            NSUInteger oldAddressIndex = [self.addresses indexOfObjectPassingTest:^BOOL(QBSShippingAddress * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return [obj.id isEqualToNumber:newAddress.id];
            }];
            
            if (oldAddressIndex != NSNotFound) {
                [self.addresses replaceObjectAtIndex:oldAddressIndex withObject:newAddress];
                [self->_layoutTV reloadSections:[NSIndexSet indexSetWithIndex:oldAddressIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }];
    [self.navigationController pushViewController:addressVC animated:YES];
}

- (void)onDeleteAddress:(QBSShippingAddress *)address {
    @weakify(self);
    [UIAlertView bk_showAlertViewWithTitle:@"是否确认删除该地址？"
                                   message:nil
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@[@"确认"]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         @strongify(self);
         if (!self) {
             return ;
         }
         
         if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确认"]) {
             [[QBSHUDManager sharedManager] showLoading];
             [[QBSRESTManager sharedManager] request_deleteShippingAddress:address withCompletionHandler:^(id obj, NSError *error) {
                 QBSHandleError(error);
                 
                 if ([obj success]) {
                     [self reloadAddressList];
                 }
             }];
         }
     }];
}

- (BOOL)isViewControllerDependsOnUserLogin {
    return YES;
}

- (void)notifyDelegateDidSelectShippingAddress:(QBSShippingAddress *)shippingAddress {
    if ([self.delegate respondsToSelector:@selector(shippingAddressListViewController:didSelectShippingAddress:)]) {
        [self.delegate shippingAddressListViewController:self didSelectShippingAddress:shippingAddress];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.addresses.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QBSAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressCellReusableIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section < self.addresses.count) {
        QBSShippingAddress *address = self.addresses[indexPath.section];
        cell.name = address.name;
        cell.phone = address.mobile;
        cell.address = address.fullAddress;
        cell.isDefault = address.isDefault.boolValue;
        
        @weakify(self);
        cell.setDefaultAction = ^(id obj) {
            @strongify(self);
            [self onSetDefaultAddress:address];
        };
        
        cell.deleteAction = ^(id obj) {
            @strongify(self);
            [self onDeleteAddress:address];
        };
        
        cell.editAction = ^(id obj) {
            @strongify(self);
            [self onEditAddress:address];
        };
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QBSTableHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderViewReusableIdentifier];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetWidth(tableView.bounds)/3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.addresses.count) {
        QBSShippingAddress *address = self.addresses[indexPath.section];
        [self notifyDelegateDidSelectShippingAddress:address];
    }
}
@end
