//
//  QBSSnatchTreasureListViewController.m
//  QBStore
//
//  Created by Liang on 2016/12/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSSnatchTreasureListViewController.h"
#import "QBSSnatchTreasureCell.h"
#import "QBSSnatchTreasureHeaderView.h"
#import "QBSTreasureCommodity.h"

static NSString *const kSnatchTreasureCellReusableIdentifier = @"SnatchTreasureCellReusableIdentifier";
static NSString *const kSnatchTreasureHeaderReusableIdentifier = @"SnatchTreasureHeaderReusableIdentifier";
static NSString *const kSnatchTreasureFooterReusableIdentifier = @"SnatchTreasureFooterReusableIdentifier";


@interface QBSSnatchTreasureListViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTV;
}
@property (nonatomic,retain) NSArray<QBSTreasureCommodityList *> *commodityLists;
@end

@implementation QBSSnatchTreasureListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"抢购";
    
    _layoutTV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _layoutTV.backgroundColor = self.view.backgroundColor;
    _layoutTV.delegate = self;
    _layoutTV.dataSource = self;
    _layoutTV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _layoutTV.separatorInset = UIEdgeInsetsZero;
//    _layoutTV.sectionHeaderHeight = 44;
    _layoutTV.sectionFooterHeight = 10;
    [_layoutTV registerClass:[QBSSnatchTreasureCell class] forCellReuseIdentifier:kSnatchTreasureCellReusableIdentifier];
    [_layoutTV registerClass:[QBSSnatchTreasureHeaderView class] forHeaderFooterViewReuseIdentifier:kSnatchTreasureHeaderReusableIdentifier];
    [self.view addSubview:_layoutTV];
    {
        [_layoutTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutTV QBS_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self reloadCommodities];
    }];
    [_layoutTV QBS_triggerPullToRefresh];
}

- (void)reloadCommodities {
    @weakify(self);
    [[QBSRESTManager sharedManager] request_fetchSnatchTreasureCommoditiesWithCompletionHandler:^(id obj, NSError *error) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutTV QBS_endPullToRefresh];
        
        if (obj) {
            self.commodityLists = ((QBSTreasureCommodityListResponse *)obj).indianaList;
            [self->_layoutTV reloadData];
        } else {
            QBSHandleError(error);
        }
        
    }];
}

- (QBSTreasureCommodity *)commodityAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.commodityLists.count) {
        QBSTreasureCommodityList *list = self.commodityLists[indexPath.section];
        if (indexPath.row < list.commodityList.count) {
            QBSTreasureCommodity *commodity = list.commodityList[indexPath.row];
            return commodity;
        }
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.commodityLists.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.commodityLists.count) {
        QBSTreasureCommodityList *list = self.commodityLists[section];
        return list.commodityList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QBSSnatchTreasureCell *cell = [tableView dequeueReusableCellWithIdentifier:kSnatchTreasureCellReusableIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    QBSTreasureCommodity *commodity = [self commodityAtIndexPath:indexPath];
    cell.title = commodity.commodityName;
    cell.imageURL = [NSURL URLWithString:commodity.imgUrl];
    cell.popularity = commodity.numParticipants.unsignedIntegerValue;
    cell.buttonTitle = @"立即申请";
    cell.buttonBackgroundColor = [UIColor colorWithHexString:@"#FF206F"];
    [cell setPrice:commodity.currentPrice.floatValue/100. withOriginalPrice:commodity.originalPrice.floatValue/100.];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QBSSnatchTreasureHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSnatchTreasureHeaderReusableIdentifier];
    headerView.backgroundView.backgroundColor = [UIColor whiteColor];
    
    if (section < self.commodityLists.count) {
        QBSTreasureCommodityList *list = self.commodityLists[section];
        headerView.title = list.name;
        
        NSString *subtitle = [NSString stringWithFormat:@"第%@期 开奖日期:%@", list.phase, list.lotteryTS];
        headerView.subtitle = subtitle;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
