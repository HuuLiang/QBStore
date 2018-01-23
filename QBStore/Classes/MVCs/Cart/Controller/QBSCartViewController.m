//
//  QBSCartViewController.m
//  Pods
//
//  Created by Sean Yue on 16/7/22.
//
//

#import "QBSCartViewController.h"
#import "QBSCartCell.h"
#import "QBSPaymentFooterView.h"
#import "QBSCommodityDetailViewController.h"
#import "QBSOrderViewController.h"
#import "QBSPlaceholderView.h"

#import "QBSCartCommodity.h"
#import "QBSUser.h"

static NSString *const kCartCellReusableIdentifier = @"CartCellReusableIdentifier";

@interface QBSCartViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTV;
    QBSPaymentFooterView *_footerView;
}
@property (nonatomic,retain) NSMutableArray<QBSCartCommodity *> *commodities;
@end

@implementation QBSCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"购物车";
    
    const CGFloat kFooterViewHeight = 44;
    
    _layoutTV = [[UITableView alloc] init];
    _layoutTV.backgroundColor = self.view.backgroundColor;
    _layoutTV.delegate = self;
    _layoutTV.dataSource = self;
    _layoutTV.rowHeight = kScreenWidth * 0.38;
    _layoutTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_layoutTV registerClass:[QBSCartCell class] forCellReuseIdentifier:kCartCellReusableIdentifier];
    [self.view addSubview:_layoutTV];
    {
        [_layoutTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, kFooterViewHeight, 0));
        }];
    }
    
    @weakify(self);
    [_layoutTV aspect_hookSelector:@selector(reloadData)
                       withOptions:AspectPositionAfter
                        usingBlock:^(id<AspectInfo> aspectInfo)
    {
        @strongify(self);
        [self onTableViewDataChanged];
    } error:nil];
    
    [_layoutTV aspect_hookSelector:@selector(deleteRowsAtIndexPaths:withRowAnimation:)
                       withOptions:AspectPositionAfter
                        usingBlock:^(id<AspectInfo> aspectInfo,
                                     NSIndexPath *indexPath,
                                     UITableViewRowAnimation animation)
    {
        @strongify(self);
        [self onTableViewDataChanged];
    } error:nil];
    
    _footerView = [[QBSPaymentFooterView alloc] initWithPaymentTitle:@"结算" allowsSelection:YES];
    _footerView.backgroundColor = [UIColor whiteColor];
    _footerView.hidden = YES;
    [self.view addSubview:_footerView];
    {
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(kFooterViewHeight);
            
            if (self.tabBarController.tabBar.hidden || !self.tabBarController.tabBar.translucent) {
                make.bottom.equalTo(self.view);
            } else {
                make.bottom.equalTo(self.view).offset(-self.tabBarController.tabBar.frame.size.height);
            }
        }];
    }
    
    _footerView.selectionChangedAction = ^(id obj){
        @strongify(self);
        [self onSelectAll:[obj selected]];
    };
    
    _footerView.deleteSelectionAction = ^(id obj) {
        @strongify(self);
        [self onDeleteSelectedCommodities];
    };
    
    _footerView.paymentAction = ^(id obj) {
        @strongify(self);
        
        QBSOrderViewController *orderVC = [[QBSOrderViewController alloc] initWithCartCommodities:[self.commodities bk_select:^BOOL(QBSCartCommodity *obj) {
            return obj.isSelected.boolValue;
        }]];
        [self.navigationController pushViewController:orderVC animated:YES];
    };
}

- (void)onTableViewDataChanged {
    NSUInteger numberOfRows = [_layoutTV numberOfRowsInSection:0];
    if (numberOfRows == 0) {
        @weakify(self);
        if (self.navigationItem.rightBarButtonItem) {
            self.navigationItem.rightBarButtonItem = nil;
            _footerView.editingSelection = NO;
        }
        
        [QBSPlaceholderView showPlaceholderForView:self.view withImage:[UIImage imageNamed:@"cart_empty"] title:@"您的购物车空空如也~~~" buttonTitle:@"去秒杀几件" buttonAction:^(id obj)
         {
             @strongify(self);
             if (self.navigationController.viewControllers.firstObject == self) {
                 self.tabBarController.selectedIndex = 0;
             } else {
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }];
    } else {
        if (!self.navigationItem.rightBarButtonItem) {
            @weakify(self);
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"编辑" style:UIBarButtonItemStylePlain handler:^(id sender) {
                @strongify(self);
                if (!self) {
                    return ;
                }
                
                UIBarButtonItem *thisItem = sender;
                
                if ([thisItem.title isEqualToString:@"编辑"]) {
                    thisItem.title = @"退出编辑";
                    self->_footerView.editingSelection = YES;
                } else if ([thisItem.title isEqualToString:@"退出编辑"]) {
                    thisItem.title = @"编辑";
                    self->_footerView.editingSelection = NO;
                }
            }];
        }
        [[QBSPlaceholderView placeholderForView:self.view] hide];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [QBSCartCommodity objectsFromPersistenceAsync:^(NSArray *objects) {
        self.commodities = objects.mutableCopy;
        [_layoutTV reloadData];
        [self updateFooterView];
    }];
}

- (void)onSelectAll:(BOOL)isSelectedAll {
    [self.commodities bk_each:^(QBSCartCommodity *obj) {
        obj.isSelected = @(isSelectedAll);
    }];
    [_layoutTV reloadData];
    [self updateFooterView];
    
    [QBSCartCommodity saveObjects:self.commodities];
}

- (void)onDeleteSelectedCommodities {
    
    @weakify(self);
    [UIAlertView bk_showAlertViewWithTitle:[NSString stringWithFormat:@"是否删除所选的全部商品？"]
                                   message:nil
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@[@"确定"]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex)
    {
        @strongify(self);
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"]) {
            NSArray *selectedCommodities = [self.commodities bk_select:^BOOL(QBSCartCommodity *obj) {
                return obj.isSelected.boolValue;
            }];
            
            [self.commodities removeObjectsInArray:selectedCommodities];
            [QBSCartCommodity removeFromPersistenceWithObjects:selectedCommodities];
            [self->_layoutTV reloadData];
            [self updateFooterView];
        }
    }];
    
}

- (void)updateFooterView {
    BOOL selectedAll = [self.commodities bk_all:^BOOL(QBSCartCommodity *obj) {
        return obj.isSelected.boolValue;
    }];
    
    _footerView.selected = self.commodities.count > 0 ? selectedAll : NO;
    _footerView.hidden = self.commodities.count == 0;

    [self footerViewRecountPrice];
}

- (void)footerViewRecountPrice {
    [_footerView setPrice:[self.commodities QBS_sumInteger:^NSInteger(QBSCartCommodity *obj) {
        if (!obj.isSelected.boolValue) {
            return 0;
        }
        
        return [obj currentPrice].integerValue * obj.amount.unsignedIntegerValue;
    }]/100. withOriginalPrice:[self.commodities QBS_sumInteger:^NSInteger(QBSCartCommodity *obj) {
        if (!obj.isSelected.boolValue) {
            return 0;
        }
        
        return [obj originalPrice].integerValue * obj.amount.unsignedIntegerValue;
    }]/100. andAmount:[self.commodities QBS_sumInteger:^NSInteger(QBSCartCommodity *obj) {
        if (!obj.isSelected.boolValue) {
            return 0;
        }
        
        return obj.amount.unsignedIntegerValue;
    }]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commodities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QBSCartCell *cell = [tableView dequeueReusableCellWithIdentifier:kCartCellReusableIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row < self.commodities.count) {
        QBSCartCommodity *commodity = self.commodities[indexPath.row];
        cell.imageURL = [NSURL URLWithString:commodity.imgUrl];
        cell.title = commodity.commodityName;
        cell.amount = commodity.amount.unsignedIntegerValue;
        cell.itemSelected = commodity.isSelected.boolValue;
        
        [cell setPrice:commodity.currentPrice.floatValue/100 withOriginalPrice:commodity.originalPrice.floatValue/100];
        
        @weakify(self);
        cell.selectionChangedAction = ^(id obj) {
            commodity.isSelected = @([obj itemSelected]);
            [commodity save];
            
            @strongify(self);
            [self updateFooterView];
        };
        
        cell.deleteAction = ^(id obj) {
            
            [UIAlertView bk_showAlertViewWithTitle:@"是否确认删除该商品？"
                                           message:nil
                                 cancelButtonTitle:@"取消"
                                 otherButtonTitles:@[@"确定"]
                                           handler:^(UIAlertView *alertView, NSInteger buttonIndex)
            {
                @strongify(self);
                if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"]) {
                    [commodity removeFromPersistence];
                    [self.commodities removeObject:commodity];
                    [self->_layoutTV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                    
                    [self updateFooterView];
                }
            }];
        };
        
        cell.amountChangedAction = ^(id obj) {
            QBSCartCell *thisCell = obj;
            commodity.amount = @(thisCell.amount);
            [commodity save];
            
            if (commodity.isSelected.boolValue) {
                @strongify(self);
                [self updateFooterView];
            }
        };
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.commodities.count) {
        QBSCartCommodity *commodity = self.commodities[indexPath.row];
        QBSCommodityDetailViewController *detailVC = [[QBSCommodityDetailViewController alloc] initWithCommodityId:commodity.commodityId columnId:commodity.columnId];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
@end
