//
//  QBSDebugOrderInfoViewController.m
//  Pods
//
//  Created by Sean Yue on 16/8/29.
//
//

#import "QBSDebugOrderInfoViewController.h"
#import "ActionSheetStringPicker.h"
#import "QBSSubtitledTableViewCell.h"

#import "QBSOrder.h"

typedef NS_ENUM(NSUInteger, QBSDebugOrderRow) {
    OrderIdRow,
    OrderCreateTimeRow,
    OrderStatusRow,
    QBSDebugOrderRowCount
};
static NSString *const kCellReusableIdentifier = @"CellReusableIdentifier";

@interface QBSDebugOrderInfoViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTV;
}
@property (nonatomic,retain) NSArray *statusArray;
@property (nonatomic,retain) NSArray *statusTextArray;
@end

@implementation QBSDebugOrderInfoViewController

- (instancetype)initWithOrder:(QBSOrder *)order {
    self = [super init];
    if (self) {
        _order = order;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单信息";
    
    _layoutTV = [[UITableView alloc] init];
    _layoutTV.backgroundColor = self.view.backgroundColor;
    _layoutTV.delegate = self;
    _layoutTV.dataSource = self;
    _layoutTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_layoutTV registerClass:[QBSSubtitledTableViewCell class] forCellReuseIdentifier:kCellReusableIdentifier];
    [self.view addSubview:_layoutTV];
    {
        [_layoutTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (NSArray *)statusArray {
    if (_statusArray) {
        return _statusArray;
    }
    
    _statusArray = @[kQBSOrderStatusWaitPay,
                     kQBSOrderStatusWaitDelivery,
                     kQBSOrderStatusDelivered,
                     kQBSOrderStatusWaitComment,
                     kQBSOrderStatusCommented,
                     kQBSOrderStatusClosed];
    return _statusArray;
}

- (NSArray *)statusTextArray {
    if (_statusTextArray) {
        return _statusTextArray;
    }
    
    _statusTextArray = @[@"待付款",@"待发货",@"已发货",@"交易成功(待评价)",@"交易成功(已评价)",@"交易关闭"];
    return _statusTextArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return QBSDebugOrderRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QBSSubtitledTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReusableIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.row + 1 < [self tableView:tableView numberOfRowsInSection:indexPath.section]) {
        cell.showSeparator = YES;
    } else {
        cell.showSeparator = NO;
    }
    
    if (indexPath.row == OrderIdRow) {
        cell.title = @"订单编号";
        cell.subtitle = self.order.orderNo;
    } else if (indexPath.row == OrderCreateTimeRow) {
        cell.title = @"下单时间";
        cell.subtitle = self.order.createTime;
    } else if (indexPath.row == OrderStatusRow) {
        cell.title = @"订单状态";
        
        NSInteger index = [self.statusArray indexOfObject:self.order.status];
        if (index == NSNotFound) {
            cell.subtitle = nil;
        } else {
            cell.subtitle = [self.statusTextArray objectAtIndex:index];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == OrderStatusRow) {
        NSInteger index = [self.statusArray indexOfObject:self.order.status];

        @weakify(self);
        [ActionSheetStringPicker showPickerWithTitle:@"选择目标状态" rows:self.statusTextArray initialSelection:index doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            @strongify(self);
            NSString *targetStatus = [self.statusArray objectAtIndex:selectedIndex];
            [[QBSHUDManager sharedManager] showLoading];
            [[QBSRESTManager sharedManager] request_modifyStatusOfOrder:self.order.orderNo toStatus:targetStatus withCompletionHandler:^(id obj, NSError *error) {
                QBSHandleError(error);
                
                @strongify(self);
                if (!self) {
                    return ;
                }
                
                if (obj) {
                    self.order.status = targetStatus;
                    [self->_layoutTV reloadData];
                    
                    SafelyCallBlock(self.orderUpdateAction, self);
                }
            }];
        } cancelBlock:nil origin:self.view];
    }
}
@end
