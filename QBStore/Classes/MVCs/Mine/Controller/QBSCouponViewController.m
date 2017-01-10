//
//  QBSCouponViewController.m
//  QBStore
//
//  Created by ylz on 2016/12/12.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSCouponViewController.h"
#import "QBSCouponCell.h"
#import "QBSCouponPopView.h"
#import "QBSCouponGiftPack.h"

static NSString *const kCouponCellIdentifier = @"qbscouponcell_identifier";

@interface QBSCouponViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
}

@property (nonatomic,retain) NSArray <QBSCouponGiftInfo *>*couponInfos;

@end

@implementation QBSCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的优惠券";
    _layoutTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.rowHeight = 128.;
    [_layoutTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [_layoutTableView registerClass:[QBSCouponCell class] forCellReuseIdentifier:kCouponCellIdentifier];
    _layoutTableView.tableFooterView = [UIView new];
    [self.view addSubview:_layoutTableView];
//    [self.popView popCouponViewInView:self.view withTicketPrice:110];
    @weakify(self);
    [_layoutTableView QBS_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadCouponModel];
    }];
    [_layoutTableView QBS_triggerPullToRefresh];

}

- (void)loadCouponModel {
    @weakify(self);
    [[QBSRESTManager sharedManager] request_fetchCouponGiftPackWithCompleteHandler:^(id obj, NSError *error) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (obj) {
            QBSCouponGiftPack *couponModel = obj;
            self.couponInfos = couponModel.couponList;
            [self ->_layoutTableView reloadData];
            [self ->_layoutTableView QBS_endPullToRefresh];
        }
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.couponInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.couponInfos.count) {
        QBSCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:kCouponCellIdentifier forIndexPath:indexPath];
        QBSCouponGiftInfo *info = self.couponInfos[indexPath.row];
        cell.bottomImageType = info.sts.integerValue;
        cell.couponStatus = info.sts.integerValue;
        cell.title = info.name;
        cell.subTitle = @"全场可用";
        cell.useDeadline = [NSString stringWithFormat:@"%@-%@",info.beginDate,info.endDate];
        cell.couponPrice = [NSString stringWithFormat:@"%ld",info.amount.integerValue/100];
        cell.satisfyPrice = [NSString stringWithFormat:@"%ld",info.minimalExpense.integerValue/100];
        return cell;
    }
    
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.couponInfos.count) {
        
    }
}



@end
