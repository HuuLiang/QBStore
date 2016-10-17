//
//  QBSCommodityListViewController.m
//  Pods
//
//  Created by Sean Yue on 16/7/6.
//
//

#import "QBSCommodityListViewController.h"
#import "QBSSortBar.h"
#import "QBSCommodityCell.h"
#import "QBSCommodityDetailViewController.h"
#import "QBSCommodityList.h"

typedef NS_ENUM(NSUInteger, QBSSortItem) {
    QBSSortByGeneral,
    QBSSortBySales,
    QBSSortByPrice
};

static NSString *const kCommodityCellReusableIdentifier = @"CommodityCellReusableIdentifier";
static const CGFloat kBarHeight = 44;

@interface QBSCommodityListViewController () <QBSSortBarDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    QBSSortBar *_sortBar;
    UICollectionView *_layoutCV;
}
@property (nonatomic) QBSSortType currentSortType;
@property (nonatomic) QBSSortMode currentSortMode;

@property (nonatomic) NSUInteger currentPage;
@property (nonatomic,retain) NSMutableArray<QBSCommodity *> *commodities;

@property (nonatomic) CGPoint lastContentOffset;
@property (nonatomic) BOOL sortBarInAnimating;
@end

@implementation QBSCommodityListViewController

DefineLazyPropertyInitialization(NSMutableArray, commodities)

- (instancetype)initWithColumnId:(NSNumber *)columnId columnType:(QBSColumnType)columnType columnName:(NSString *)columnName {
    self = [super init];
    if (self) {
        _columnId = columnId;
        _columnType = columnType;
        _columnName = columnName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.columnName ?: @"商品列表";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = layout.minimumInteritemSpacing;
    
    _layoutCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCV.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    _layoutCV.backgroundColor = self.view.backgroundColor;
    _layoutCV.delegate = self;
    _layoutCV.dataSource = self;
    [_layoutCV registerClass:[QBSCommodityCell class] forCellWithReuseIdentifier:kCommodityCellReusableIdentifier];
    [self.view addSubview:_layoutCV];
    {
        [_layoutCV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutCV QBS_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadCommodityWithRefresh:YES];
    }];
    
    [_layoutCV QBS_addPagingRefreshWithHandler:^{
        @strongify(self);
        [self loadCommodityWithRefresh:NO];
    }];
    
    _sortBar = [[QBSSortBar alloc] initWithItems:@[[QBSSortBarItem itemWithName:@"综合" hasSortMode:NO],
                                                   [QBSSortBarItem itemWithName:@"销量" hasSortMode:YES],
                                                   [QBSSortBarItem itemWithName:@"价格" hasSortMode:YES]]
                                        delegate:self];
    _sortBar.backgroundColor = self.view.backgroundColor;
    _sortBar.layer.shadowOffset = CGSizeMake(0, 3);
    _sortBar.layer.shadowOpacity = 0.5;
    _sortBar.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:_sortBar];
    {
        [_sortBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.mas_equalTo(kBarHeight);
        }];
    }
    _sortBar.selectedIndex = 0;
}

- (void)loadCommodityWithRefresh:(BOOL)isRefresh {
    @weakify(self);
    [[QBSRESTManager sharedManager] request_queryCommodityListWithColumnId:self.columnId
                                                                columnType:self.columnType
                                                            bySortWithType:self.currentSortType
                                                                      mode:self.currentSortMode
                                                                    inPage:isRefresh?1:self.currentPage+1
                                                         completionHandler:^(id obj, NSError *error)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutCV QBS_endPullToRefresh];
        
        if (obj) {
            if (isRefresh) {
                [self.commodities removeAllObjects];
            }
            
            QBSCommodityListResponse *resp = obj;
            self.currentPage = resp.columnCommodityDto.pageNum.unsignedIntegerValue;

            if (resp.columnCommodityDto.data) {
                [self.commodities addObjectsFromArray:resp.columnCommodityDto.data];
                [self->_layoutCV reloadData];
            }
            
            if (resp.columnCommodityDto.pageNum.unsignedIntegerValue == resp.columnCommodityDto.pageCount.unsignedIntegerValue) {
                [self->_layoutCV QBS_pagingRefreshNoMoreData];
            }
        } else {
            QBSHandleError(error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (fabs(self.lastContentOffset.y - scrollView.contentOffset.y) > kBarHeight && !self.sortBarInAnimating) {
        BOOL shouldHideSortBar = self.lastContentOffset.y - scrollView.contentOffset.y < 0;
        if (shouldHideSortBar) {
            if (!_sortBar.hidden && self.lastContentOffset.y > kBarHeight) {
                self.sortBarInAnimating = YES;
                
                [_sortBar mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view).offset(-kBarHeight);
                }];
                
                [UIView animateWithDuration:0.25 animations:^{
                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    _sortBar.hidden = YES;
                    self.sortBarInAnimating = NO;
                }];
            }
            
            
        } else {
            if (_sortBar.hidden) {
                self.sortBarInAnimating = YES;
                _sortBar.hidden = NO;
                
                [_sortBar mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view);
                }];
                
                [UIView animateWithDuration:0.25 animations:^{
                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    self.sortBarInAnimating = NO;
                }];
            }
        }
        
        self.lastContentOffset = scrollView.contentOffset;
    }
}

#pragma mark - QBSSortBarDelegate

- (void)sortBar:(QBSSortBar *)sortBar didChangeSortMode:(QBSSortMode)sortMode atItemIndex:(NSUInteger)itemIndex {
    self.currentSortMode = sortMode;
    self.currentSortType = itemIndex;
    [_layoutCV QBS_triggerPullToRefresh];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.commodities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QBSCommodityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommodityCellReusableIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.item < self.commodities.count) {
        QBSCommodity *commodity = self.commodities[indexPath.item];
        
        cell.title = commodity.commodityName;
        cell.imageURL = [NSURL URLWithString:commodity.imgUrl];
        cell.sold = commodity.numSold.unsignedIntegerValue;
        [cell setPrice:commodity.currentPrice.floatValue/100 withOriginalPrice:commodity.originalPrice.floatValue/100];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    const CGFloat interItemSpacing = ((UICollectionViewFlowLayout *)collectionViewLayout).minimumInteritemSpacing;
    const CGFloat itemWidth = (CGRectGetWidth(collectionView.bounds) - interItemSpacing)/2;
    const CGFloat itemHeight = MAX(225,itemWidth / [QBSCommodityCell cellAspects]);
    return CGSizeMake(itemWidth, itemHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.commodities.count) {
        QBSCommodity *commodity = self.commodities[indexPath.item];
        
        QBSCommodityDetailViewController *detailVC = [[QBSCommodityDetailViewController alloc] initWithCommodityId:commodity.commodityId columnId:self.columnId];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
@end
