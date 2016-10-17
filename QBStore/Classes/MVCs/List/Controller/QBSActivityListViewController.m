//
//  QBSActivityListViewController.m
//  Pods
//
//  Created by Sean Yue on 16/7/19.
//
//

#import "QBSActivityListViewController.h"
#import "QBSActivityListCell.h"
#import "QBSCommodityDetailViewController.h"
#import "QBSActivityListHeaderView.h"
#import "QBSOrderViewController.h"

#import "QBSCommodityList.h"
#import "QBSFeaturedCommodity.h"
#import "QBSCartCommodity.h"

static NSString *const kAcitivityCellReusableIdentifier = @"AcitivityCellReusableIdentifier";
static NSString *const kAcitivityHeaderReusableIdentifier = @"AcitivityHeaderReusableIdentifier";
//static const CGFloat kSoldPercentRefreshRate = 10;

@interface QBSActivityListViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTV;
}
@property (nonatomic,retain) NSMutableArray<QBSCommodity *> *commodities;
@property (nonatomic) NSUInteger currentPage;

//@property (nonatomic,retain) NSDate *countDownBeginTime;
//@property (nonatomic,retain) NSMutableDictionary<NSNumber *, NSNumber *> *soldPercents;
//@property (nonatomic) NSUInteger lastSoldPercentRefreshDuration;
@end

@implementation QBSActivityListViewController

DefineLazyPropertyInitialization(NSMutableArray, commodities)
//DefineLazyPropertyInitialization(NSMutableDictionary, soldPercents)

//- (instancetype)initWithColumnId:(NSNumber *)columnId columnType:(QBSColumnType)columnType columnName:(NSString *)columnName {
//    self = [super init];
//    if (self) {
//        _columnId = columnId;
//        _columnType = columnType;
//        _columnName = columnName;
//    }
//    return self;
//}

- (instancetype)initWithActivityList:(NSArray<QBSFeaturedCommodityList *> *)activityList
                     currentActivity:(QBSFeaturedCommodityList *)currentActivity
                            duration:(NSUInteger)duration
{
    self = [super init];
    if (self) {
        _activityList = activityList;
        _currentActivity = currentActivity;
        _duration = duration;
//        _countDownBeginTime = [NSDate date];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.currentActivity.data.promotionName;
    
    _layoutTV = [[UITableView alloc] init];
    _layoutTV.backgroundColor = self.view.backgroundColor;
    _layoutTV.delegate = self;
    _layoutTV.dataSource = self;
    _layoutTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_layoutTV registerClass:[QBSActivityListCell class] forCellReuseIdentifier:kAcitivityCellReusableIdentifier];
    [_layoutTV registerClass:[QBSActivityListHeaderView class] forHeaderFooterViewReuseIdentifier:kAcitivityHeaderReusableIdentifier];
    [self.view addSubview:_layoutTV];
    {
        [_layoutTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutTV QBS_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadActivityCommoditiesInPage:1];
    }];
    
    [_layoutTV QBS_addPagingRefreshWithHandler:^{
        @strongify(self);
        [self loadActivityCommoditiesInPage:self.currentPage+1];
    }];
    [_layoutTV QBS_triggerPullToRefresh];
}

- (void)loadActivityCommoditiesInPage:(NSUInteger)page {
    if (!self.currentActivity.data.columnId) {
        [self.commodities removeAllObjects];
        [_layoutTV reloadData];
        return ;
    }
    
    @weakify(self);
    [[QBSRESTManager sharedManager] request_queryActivityListWithColumnId:self.currentActivity.data.columnId
                                                               columnType:self.currentActivity.data.columnType.unsignedIntegerValue
                                                                   inPage:page
                                                        completionHandler:^(id obj, NSError *error)
    {
        @strongify(self);
        if (!self) {
            return ;
        }

        [self->_layoutTV QBS_endPullToRefresh];
        
        if (obj) {
            if (page == 1) {
                [self.commodities removeAllObjects];
            }
            
            QBSCommodityListResponse *resp = obj;
            self.currentPage = resp.columnCommodityDto.pageNum.unsignedIntegerValue;
            
            if (resp.columnCommodityDto.data) {
                [self.commodities addObjectsFromArray:resp.columnCommodityDto.data];
//                [self calculateSoldPercentsWithCommodities:self.commodities];
                [self->_layoutTV reloadData];
            }
            
            if (self.currentPage == resp.columnCommodityDto.pageCount.unsignedIntegerValue) {
                [self->_layoutTV QBS_pagingRefreshNoMoreData];
            }
        } else {
            QBSHandleError(error);
        }
    }];
}

- (void)onActivitySwitchToNext {
    __block NSUInteger nextActivityIndex = NSNotFound;
    [self.activityList enumerateObjectsUsingBlock:^(QBSFeaturedCommodityList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.data.promotionId && [obj.data.promotionId isEqualToNumber:self.currentActivity.data.promotionId]) {
            *stop = YES;
            nextActivityIndex = idx + 1;
            
            if (nextActivityIndex >= self.activityList.count) {
                nextActivityIndex = 0;
            }
        }
    }];
    
    if (nextActivityIndex == NSNotFound) {
        _currentActivity = nil;
    } else {
        _currentActivity = self.activityList[nextActivityIndex];
    }
    
    self.duration = 0;
    
//    self.lastSoldPercentRefreshDuration = 0;
//    self.countDownBeginTime = nil;
//    [self.soldPercents removeAllObjects];
    [self.commodities removeAllObjects];
    [_layoutTV reloadData];
    
    self.duration = _currentActivity.data.duration.unsignedIntegerValue;
    [_layoutTV QBS_triggerPullToRefresh];
}

//- (void)calculateSoldPercentsWithCommodities:(NSArray<QBSCommodity *> *)commodities {
//    NSInteger currentDuration = [[NSDate date] timeIntervalSinceDate:self.countDownBeginTime];
//    if (self.duration == 0 || (self.lastSoldPercentRefreshDuration > 0 && currentDuration - self.lastSoldPercentRefreshDuration < kSoldPercentRefreshRate)) {
//        return ;
//    }
//    
//    const NSInteger refreshDuration = currentDuration - self.lastSoldPercentRefreshDuration;
//    [commodities enumerateObjectsUsingBlock:^(QBSCommodity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (!obj.commodityId) {
//            return ;
//        }
//        
//        const NSUInteger totalRemainPercents = 100 - (obj.soldBase ? obj.soldBase.unsignedIntegerValue : 0);
//        const CGFloat refreshRatio = (CGFloat)refreshDuration / self.duration;
//        const NSUInteger stepsPerRefresh = ceilf(totalRemainPercents * refreshRatio);
//        NSNumber *currentPercent = self.soldPercents[obj.commodityId];
//        if (!currentPercent) {
//            currentPercent = obj.soldBase ?: @0;
//        } else {
//            currentPercent = @(currentPercent.unsignedIntegerValue + arc4random_uniform((uint32_t)stepsPerRefresh+1));
//        }
//        
//        if (currentPercent.unsignedIntegerValue >= 100) {
//            currentPercent = @99;
//        }
//        
//        [self.soldPercents setObject:currentPercent forKey:obj.commodityId];
//    }];
//    
//    self.lastSoldPercentRefreshDuration = currentDuration;
//}

//- (void)setDuration:(NSUInteger)duration {
//    _duration = duration;
//    
//    self.countDownBeginTime = [NSDate date];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commodities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QBSActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:kAcitivityCellReusableIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.showSeparator = YES;
    
    if (indexPath.row == self.commodities.count-1) {
        cell.separatorInsets = UIEdgeInsetsZero;
    } else {
        cell.separatorInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    }
    
    if (indexPath.row < self.commodities.count) {
        QBSCommodity *commodity = self.commodities[indexPath.row];
//        NSNumber *soldPercent;
//        if (commodity.commodityId) {
//            soldPercent = self.soldPercents[commodity.commodityId] ?: commodity.soldBase;
//        } else {
//            soldPercent = commodity.soldBase;
//        }
//        
        cell.imageURL = [NSURL URLWithString:commodity.imgUrl];
        cell.title = commodity.commodityName;
        cell.currentPrice = commodity.currentPrice.floatValue / 100;
        cell.originalPrice = commodity.originalPrice.floatValue / 100;
        cell.soldPercent = commodity.soldBase.unsignedIntegerValue;
        cell.tagURL = [NSURL URLWithString:commodity.tagsImgUrl];
        
        @weakify(self);
        cell.buyAction = ^(id obj) {
            @strongify(self);
            QBSCartCommodity *cartCommodity = [[QBSCartCommodity alloc] initFromCommodity:commodity withAmount:1 columnId:self.currentActivity.data.columnId];
            QBSOrderViewController *orderVC = [[QBSOrderViewController alloc] initWithCartCommodities:@[cartCommodity]];
            [self.navigationController pushViewController:orderVC animated:YES];
        };
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QBSActivityListHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kAcitivityHeaderReusableIdentifier];
    headerView.countDownBackgroundColor = [UIColor colorWithHexString:@"#FF206F"];
    headerView.nextTimeBackgroundColor = tableView.backgroundColor;
    
    if (self.duration > 0) {
        @weakify(self);
        [headerView setCountDownTime:self.duration nextBeginTime:self.currentActivity.data.nextBeginTime withFinishedBlock:^(id obj) {
            @strongify(self);
            [self onActivitySwitchToNext];
        }];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetWidth(tableView.bounds) /2.9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.commodities.count) {
        QBSCommodity *commodity = self.commodities[indexPath.row];
        
        QBSCommodityDetailViewController *detailVC = [[QBSCommodityDetailViewController alloc] initWithCommodityId:commodity.commodityId
                                                                                                  columnId:self.currentActivity.data.columnId];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
@end
