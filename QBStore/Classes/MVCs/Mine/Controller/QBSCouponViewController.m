//
//  QBSCouponViewController.m
//  QBStore
//
//  Created by ylz on 2016/12/12.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSCouponViewController.h"
#import "QBSCouponCell.h"

static NSString *const kCouponCellIdentifier = @"qbscouponcell_identifier";

@interface QBSCouponViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
}

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QBSCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:kCouponCellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.bottomImageType = 0;
        cell.couponStatus = 0;
        cell.title = @"棒棒糖新人大礼包";
        cell.subTitle = @"全场可用";
        cell.useDeadline = @"2016-12-12--2016-12-30";
        cell.couponPrice = @"110";
        cell.satisfyPrice = @"400";
    }else if(indexPath.row == 1){
        cell.bottomImageType = 1;
        cell.couponStatus = 1;
        cell.title = @"棒棒糖新人大礼包";
        cell.subTitle = @"全场可用";
        cell.useDeadline = @"2016-12-12--2016-12-30";
        cell.couponPrice = @"110";
        cell.satisfyPrice = @"400";
    }else {
        cell.bottomImageType = 2;
        cell.couponStatus = 2;
        cell.title = @"棒棒糖新人大礼包";
        cell.subTitle = @"全场可用";
        cell.useDeadline = @"2016-12-12--2016-12-30";
        cell.couponPrice = @"110";
        cell.satisfyPrice = @"400";
    }
    return cell;
}


@end
