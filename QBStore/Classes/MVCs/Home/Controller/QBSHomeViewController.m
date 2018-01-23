//
//  QBSHomeViewController.m
//  Pods
//
//  Created by Sean Yue on 16/6/23.
//
//

#import "QBSHomeViewController.h"
#import "QBSBannerCell.h"
#import "QBSFeaturedTypeCell.h"
#import "QBSActivityHeaderView.h"
#import "QBSHomeActivityRowCell.h"
#import "QBSHomeCommodityCell.h"
#import "QBSCategoryViewController.h"
#import "QBSCommodityDetailViewController.h"
#import "QBSCommodityListViewController.h"
#import "QBSActivityListViewController.h"

#import "QBSCartViewController.h"
#import "QBSCartButton.h"
#import "QBSOrderListViewController.h"
#import "QBSOrderViewController.h"

// Models
#import "QBSCommodity.h"
#import "QBSHomeGroup.h"
#import "QBSBanner.h"
#import "QBSHomeFavourites.h"
#import "QBSFeaturedCommodity.h"
#import "QBSCartCommodity.h"
#import "QBSCommodityTag.h"

typedef NS_ENUM(NSUInteger, QBSHomeSection) {
    QBSBannerSection,
    QBSFeaturedTypeSection,
    QBSActivitySection,
    QBSFeaturedCommoditySection,
    QBSLastSection = QBSFeaturedCommoditySection,
    
    QBSUnknownSection = NSUIntegerMax
};

static NSString *const kBannerCellReusableIdentifier = @"BannerCellReusableIdentifier";
static NSString *const kFeaturedTypeCellReusableIdentifier = @"FeaturedTypeCellReusableIdentifier";
static NSString *const kActivityHeaderReusableIdentifier = @"ActivityHeaderReusableIdentifier";
static NSString *const kActivityCellReusableIdentifier = @"ActivityCellReusableIdentifier";
static NSString *const kFeaturedCommodityCellReusableIdentifier = @"FeaturedCommodityCellReusableIdentifier";
static NSString *const kFeaturedCategoryCellReusableIdentifier = @"FeaturedCategoryCellReusableIdentifier";

static CGFloat kBannerImageScale = 7./3.;

#define IsHomeSectionIndexEqualsToSectionType(sectionIndex, sectionType) ([self sectionTypeWithSectionIndex:sectionIndex] == sectionType)

@interface QBSHomeViewController () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,SDCycleScrollViewDelegate>
{
    UICollectionView *_layoutCV;
}

@property (nonatomic,retain) NSArray<QBSBanner *> *banners;

//@property (nonatomic,retain) NSMutableArray<QBSCommodity *> *favourites;
//@property (nonatomic) NSNumber *favouritesColumnId;


@property (nonatomic,retain) NSMutableArray<QBSHomeGroup *> *featuredTypes;
@property (nonatomic,retain) NSMutableArray<QBSFeaturedCommodityList *> *activities;
@property (nonatomic,retain) NSMutableArray<QBSFeaturedCommodityList *> *featuredCommodity;
@property (nonatomic) NSUInteger currentFeaturedCommodityPage;
@property (nonatomic) NSUInteger totalFeaturedCommodityPages;

@property (nonatomic,retain) dispatch_group_t dataDispatchGroup;
@property (nonatomic) BOOL dataChanged;
@property (nonatomic,retain) NSMutableArray *sections;
@property (nonatomic,retain) QBSFeaturedCommodityList *currentActivity;

@property (nonatomic,retain) NSMutableDictionary<NSNumber *,NSDate *> *featuredCommodityEndDates;
@end

@implementation QBSHomeViewController

DefineLazyPropertyInitialization(NSMutableArray, featuredTypes)
DefineLazyPropertyInitialization(NSMutableArray, activities)
DefineLazyPropertyInitialization(NSMutableArray, featuredCommodity)
DefineLazyPropertyInitialization(NSMutableArray, sections)
DefineLazyPropertyInitialization(NSMutableDictionary, featuredCommodityEndDates)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    _layoutCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCV.backgroundColor = self.view.backgroundColor;
    _layoutCV.delegate = self;
    _layoutCV.dataSource = self;
    [_layoutCV registerClass:[QBSBannerCell class] forCellWithReuseIdentifier:kBannerCellReusableIdentifier];
    [_layoutCV registerClass:[QBSFeaturedTypeCell class] forCellWithReuseIdentifier:kFeaturedTypeCellReusableIdentifier];
    [_layoutCV registerClass:[QBSActivityHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kActivityHeaderReusableIdentifier];
    [_layoutCV registerClass:[QBSHomeActivityRowCell class] forCellWithReuseIdentifier:kActivityCellReusableIdentifier];
    [_layoutCV registerClass:[QBSHomeCommodityCell class] forCellWithReuseIdentifier:kFeaturedCommodityCellReusableIdentifier];
    [_layoutCV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kFeaturedCategoryCellReusableIdentifier];
    [self.view addSubview:_layoutCV];
    {
        [_layoutCV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    @weakify(self);
    [_layoutCV QBS_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self reloadData];
    }];
    [_layoutCV QBS_triggerPullToRefresh];
    
    [self.navigationController.navigationBar bk_whenTouches:1 tapped:5 handler:^{
        [[QBSHUDManager sharedManager] showInfo:[NSString stringWithFormat:@"ChannelNo:%@\nPaymentPv:%@", [QBSConfiguration defaultConfiguration].channelNo, kQBSPaymentPv]];
    }];
}

#pragma mark - Data Loading

- (void)loadBanners {
    @weakify(self);
    [[QBSRESTManager sharedManager] request_queryHomeBannerWithCompletionHandler:^(id obj, NSError *error) {
        QBSHandleError(error);
        
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (obj) {
            self.banners = ((QBSBannerResponse *)obj).bannerList;
            self.dataChanged = YES;
        }
        
        dispatch_group_leave(self.dataDispatchGroup);
    }];
}

//- (void)loadFavouritesForRefresh:(BOOL)isRefresh {
//    @weakify(self);
//    [[QBSRESTManager sharedManager] request_queryFavouritesInPage:isRefresh ? 1 : self.currentFavouritesPage+1
//                                            withCompletionHandler:^(id obj, NSError *error)
//    {
//        QBSHandleError(error);
//        
//        @strongify(self);
//        if (!self) {
//            return ;
//        }
//        
//        if (!isRefresh) {
//            [self->_layoutCV QBS_endPullToRefresh];
//        }
//        
//        if (obj) {
//            [self->_layoutCV QBS_addPagingRefreshWithHandler:^{
//                @strongify(self);
//                [self loadFavouritesForRefresh:NO];
//            }];
//            
//            self.dataChanged = YES;
//            if (isRefresh) {
//                [self.favourites removeAllObjects];
//            }
//            
//            QBSHomeFavourites *fav = obj;
//            self.currentFavouritesPage = fav.guessYouLikeInfo.pageNum.unsignedIntegerValue;
//            self.totalFavouritesPages = fav.guessYouLikeInfo.pageCount.unsignedIntegerValue;
//            self.favouritesColumnId = fav.guessYouLikeInfo.columnId;
//            
//            if (fav.guessYouLikeInfo.commodityList.count > 0) {
//                const NSUInteger previousNum = self.favourites.count;
//                [self.favourites addObjectsFromArray:fav.guessYouLikeInfo.commodityList];
//                
//                const NSUInteger numberOfSections = [self->_layoutCV numberOfSections];
//                if (!isRefresh && numberOfSections > 0) {
//                    NSMutableArray *indexPaths = [NSMutableArray array];
//                    for (NSUInteger item = previousNum; item < self.favourites.count; ++item) {
//                        [indexPaths addObject:[NSIndexPath indexPathForItem:item inSection:numberOfSections-1]];
//                    }
//                    
//                    [self->_layoutCV insertItemsAtIndexPaths:indexPaths];
//                }
//            }
//
//            if (!isRefresh && (fav.guessYouLikeInfo.pageNum.unsignedIntegerValue == fav.guessYouLikeInfo.pageCount.unsignedIntegerValue)) {
//                [self->_layoutCV QBS_pagingRefreshNoMoreData];
//            }
//        }
//        
//        if (isRefresh) {
//            dispatch_group_leave(self.dataDispatchGroup);
//        }
//    }];
//}

- (void)loadFeaturedTypesAndActivities {
    @weakify(self);
    [[QBSRESTManager sharedManager] request_queryHomeFeaturedTypesAndActivitiesWithCompletionHandler:^(id obj, NSError *error) {
        QBSHandleError(error);
        
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (obj) {
            self.dataChanged = YES;
            [self.featuredTypes removeAllObjects];
            [self.activities removeAllObjects];
            
            QBSFeaturedCommodityListResponse *resp = obj;
            [resp.channelRecommendationList enumerateObjectsUsingBlock:^(QBSFeaturedCommodityList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.rmdType.unsignedIntegerValue == QBSFeaturedTypeGroup) {
                    if (obj.data.groupItemList) {
                        [self.featuredTypes addObjectsFromArray:obj.data.groupItemList];
                    }
                } else if (obj.rmdType.unsignedIntegerValue == QBSFeaturedTypePromotion) {
                    [self.activities addObject:obj];
                }
            }];
            
            if (!self.currentActivity) {
                self.currentActivity = self.activities.firstObject;
            }
        }
        
        dispatch_group_leave(self.dataDispatchGroup);
    }];
}

- (void)loadFeaturedCommoditiesForRefresh:(BOOL)isRefresh {
    @weakify(self);
    [[QBSRESTManager sharedManager] request_queryHomeFeaturedCommoditiesInPage:isRefresh?1:self.currentFeaturedCommodityPage+1 withCompletionHandler:^(id obj, NSError *error) {
        QBSHandleError(error);
        
        @strongify(self);
        if (!self) {
            return ;
        }

        if (obj) {
            
            [self->_layoutCV QBS_addPagingRefreshWithHandler:^{
                @strongify(self);
                [self loadFeaturedCommoditiesForRefresh:NO];
            }];
            
            self.dataChanged = YES;
            if (isRefresh) {
                [self.featuredCommodity removeAllObjects];
                [self.featuredCommodityEndDates removeAllObjects];
            }
            
            QBSFeaturedCommodityResponse *resp = obj;
            if (isRefresh) {
                self.currentFeaturedCommodityPage = 1;
            } else {
                ++self.currentFeaturedCommodityPage;
            }
            self.totalFeaturedCommodityPages = resp.homeColumnCommodityRmdDto.pageCount.unsignedIntegerValue;
            
            if (resp.homeColumnCommodityRmdDto.channelRecommendationList.count > 0) {
                [self.featuredCommodity addObjectsFromArray:resp.homeColumnCommodityRmdDto.channelRecommendationList];
                
                [resp.homeColumnCommodityRmdDto.channelRecommendationList enumerateObjectsUsingBlock:^(QBSFeaturedCommodityList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.rmdType.unsignedIntegerValue == QBSFeaturedTypeRecommendationCommodity && obj.data.leftTime) {
                        [self.featuredCommodityEndDates setObject:[NSDate dateWithTimeIntervalSinceNow:obj.data.leftTime.unsignedIntegerValue] forKey:obj.data.commodityId];
                    }
                }];
                
                if (!isRefresh) {
                    NSUInteger featuredSection = [self.sections indexOfObject:@(QBSFeaturedCommoditySection)];
                    if (featuredSection != NSNotFound) {
                        [self->_layoutCV reloadSections:[NSIndexSet indexSetWithIndex:featuredSection]];
                    }
                    
                    if (self.currentFeaturedCommodityPage == self.totalFeaturedCommodityPages) {
                        [self->_layoutCV QBS_pagingRefreshNoMoreData];
                    }
                }
            }
        }
        
        if (isRefresh) {
            dispatch_group_leave(self.dataDispatchGroup);
        }
    }];
}

- (void)reloadData {
    if (!self.dataDispatchGroup) {
        self.dataDispatchGroup = dispatch_group_create();
    }

    const NSUInteger dataRequestCount = 3;
    for (NSUInteger i = 0; i < dataRequestCount ; ++i) {
        dispatch_group_enter(self.dataDispatchGroup);
    }

    self.dataChanged = NO;
    [self loadBanners];
    [self loadFeaturedTypesAndActivities];
    [self loadFeaturedCommoditiesForRefresh:YES];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_group_wait(self.dataDispatchGroup, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_layoutCV QBS_endPullToRefresh];
            
            if (self.dataChanged) {
                [self decideSectionTypes];
                [_layoutCV reloadData];
                self.dataChanged = NO;
                
                if (self.totalFeaturedCommodityPages == self.currentFeaturedCommodityPage) {
                    [_layoutCV QBS_pagingRefreshNoMoreData];
                }
            }
            
        });
    });
}

- (void)decideSectionTypes {
    [self.sections removeAllObjects];
    
    if (self.banners.count > 0) {
        [self.sections addObject:@(QBSBannerSection)];
    }
    
    if (self.featuredTypes.count > 0) {
        [self.sections addObject:@(QBSFeaturedTypeSection)];
    }
    
    if (self.currentActivity) {
        [self.sections addObject:@(QBSActivitySection)];
    }
    
    if (self.featuredCommodity.count > 0) {
        [self.sections addObject:@(QBSFeaturedCommoditySection)];
    }
}

- (QBSHomeSection)sectionTypeWithSectionIndex:(NSUInteger)section {
    if (section < self.sections.count) {
        return [self.sections[section] unsignedIntegerValue];
    }
    return QBSUnknownSection;
}

- (QBSFeaturedCommodityList *)featuredCommodityCommodityListWithSectionIndex:(NSUInteger)sectionIndex {
    NSUInteger firstIndex = [self.sections indexOfObject:@(QBSFeaturedCommoditySection)];
    if (firstIndex == NSNotFound) {
        return nil;
    }
    
    NSUInteger featuredCommodityIndex = sectionIndex - firstIndex;
    if (featuredCommodityIndex < self.featuredCommodity.count) {
        return self.featuredCommodity[featuredCommodityIndex];
    } else {
        return nil;
    }
}

- (void)showDetailOfCommodity:(QBSCommodity *)commodity withColumnId:(NSNumber *)columnId {
    QBSCommodityDetailViewController *detailVC = [[QBSCommodityDetailViewController alloc] initWithCommodityId:commodity.commodityId columnId:columnId];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)onAcitivitySwitchToNext {
    __block NSUInteger nextActivityIndex = NSNotFound;
    [self.activities enumerateObjectsUsingBlock:^(QBSFeaturedCommodityList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.data.promotionId && self.currentActivity.data.promotionId && [obj.data.promotionId isEqualToNumber:self.currentActivity.data.promotionId]) {
            *stop = YES;
            nextActivityIndex = idx + 1;
            
            if (nextActivityIndex >= self.activities.count) {
                nextActivityIndex = 0;
            }
        }
    }];
    
    NSUInteger sectionIndex = [self.sections indexOfObject:@(QBSActivitySection)];
    if (nextActivityIndex == NSNotFound) {
        self.currentActivity = nil;
    } else {
        self.currentActivity = [self.activities objectAtIndex:nextActivityIndex];
    }
    
    if (self.currentActivity) {
        if (sectionIndex != NSNotFound) {
            [_layoutCV reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
        }
    } else {
        [self decideSectionTypes];
        [_layoutCV deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
    }
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (IsHomeSectionIndexEqualsToSectionType(section, QBSBannerSection)) {
        return 1;
    } else if (IsHomeSectionIndexEqualsToSectionType(section, QBSFeaturedTypeSection)) {
        return self.featuredTypes.count;
    } else if (IsHomeSectionIndexEqualsToSectionType(section, QBSActivitySection)) {
        return 1;
    } else if (IsHomeSectionIndexEqualsToSectionType(section, QBSFeaturedCommoditySection)) {
        return self.featuredCommodity.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (IsHomeSectionIndexEqualsToSectionType(indexPath.section, QBSBannerSection)) {
        QBSBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannerCellReusableIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        NSMutableArray<NSString *> *urlStrings = [NSMutableArray array];
        [self.banners enumerateObjectsUsingBlock:^(QBSBanner * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.bannerImgUrl.length > 0) {
                [urlStrings addObject:obj.bannerImgUrl];
            }
        }];
        
        @weakify(self);
        cell.selectionAction = ^(NSUInteger index, id obj) {
            @strongify(self);
            if (index >= self.banners.count) {
                return ;
            }
            
            QBSBanner *banner = self.banners[index];
            [self pushViewControllerWithRecommendType:banner.bannerType.unsignedIntegerValue
                                           columnType:banner.columnType.unsignedIntegerValue
                                               isLeaf:banner.isLeaf.boolValue
                                                relId:banner.relId
                                              relName:nil
                                               relUrl:nil];
        };
        cell.imageURLStrings = urlStrings;
        return cell;
    } else if (IsHomeSectionIndexEqualsToSectionType(indexPath.section, QBSFeaturedTypeSection)) {
        QBSFeaturedTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFeaturedTypeCellReusableIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        if (indexPath.item < self.featuredTypes.count) {
            QBSHomeGroup *group = self.featuredTypes[indexPath.item];
            cell.title = group.name;
            cell.subtitle = group.viceName;
            cell.imageURL = [NSURL URLWithString:group.rmdImgUrl];
            cell.titleColor = [UIColor featuredColorWithIndex:indexPath.item];
        }
        return cell;
    } else if (IsHomeSectionIndexEqualsToSectionType(indexPath.section, QBSActivitySection)) {
        QBSHomeActivityRowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kActivityCellReusableIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        QBSFeaturedCommodityList *commodityList = self.currentActivity;
        
        NSMutableArray<QBSHomeActivityItem *> *items = [NSMutableArray array];
        [commodityList.data.commodityList enumerateObjectsUsingBlock:^(QBSCommodity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [items addObject:[QBSHomeActivityItem itemWithImageURL:[NSURL URLWithString:obj.imgUrl]
                                                             price:obj.currentPrice.floatValue/100
                                                     originalPrice:obj.originalPrice.floatValue/100
                                                            tagURL:[NSURL URLWithString:obj.tagsImgUrl]]];
        }];
        cell.items = items;
        
        @weakify(self);
        cell.selectionAction = ^(NSUInteger index, id obj) {
            @strongify(self);
            if (index >= commodityList.data.commodityList.count) {
                return ;
            }
            
            QBSCommodity *commodity = commodityList.data.commodityList[index];
            [self showDetailOfCommodity:commodity withColumnId:commodityList.data.columnId];
        };
        return cell;
    } else if (IsHomeSectionIndexEqualsToSectionType(indexPath.section, QBSFeaturedCommoditySection)) {
        if (indexPath.item < self.featuredCommodity.count) {
            QBSFeaturedCommodityList *commodity = self.featuredCommodity[indexPath.item];
            if (commodity.rmdType.unsignedIntegerValue == QBSFeaturedTypeRecommendationCommodity) {
                QBSHomeCommodityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFeaturedCommodityCellReusableIdentifier forIndexPath:indexPath];
                cell.backgroundColor = [UIColor whiteColor];
                cell.title = commodity.data.commodityName;
                cell.thumbImageURL = [NSURL URLWithString:commodity.data.imgUrl];
                cell.sold = commodity.data.numSold.unsignedIntegerValue;
                
                NSArray *strLines = [commodity.data.commodityViceName componentsSeparatedByString:@"|"];
                NSMutableString *details = [NSMutableString string];
                [strLines enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [details appendFormat:@"☞ %@\n", obj];
                }];
                cell.details = details;
                
                BOOL isActivityStyle = commodity.data.activityPrice != nil;
                NSTimeInterval countingTimeInterval = 0;
                if (isActivityStyle) {
                    NSDate *endDate = self.featuredCommodityEndDates[commodity.data.commodityId];
                    if (!endDate) {
                        isActivityStyle = NO;
                    } else {
                        countingTimeInterval = [endDate timeIntervalSinceNow];
                        
                        if (countingTimeInterval <= 0) {
                            isActivityStyle = NO;
                        }
                    }
                }
                cell.style = isActivityStyle ? QBSHomeCommodityCellActivityStyle : QBSHomeCommodityCellNormalStyle;
                
                NSMutableArray<NSString *> *tags = [NSMutableArray array];
                [commodity.data.tagsInfo enumerateObjectsUsingBlock:^(QBSCommodityTag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.tagsName) {
                        [tags addObject:obj.tagsName];
                    }
                }];
                cell.tags = tags;
                
                const CGFloat price = isActivityStyle ? commodity.data.activityPrice.floatValue/100. : commodity.data.currentPrice.floatValue/100.;
                [cell setPrice:price withOriginalPrice:commodity.data.originalPrice.floatValue/100.];
                
                if (isActivityStyle) {
                    [cell setCountDownTime:countingTimeInterval withFinishedBlock:^(id obj) {
                        QBSHomeCommodityCell *thisCell = obj;
                        [thisCell setPrice:commodity.data.currentPrice.floatValue/100. withOriginalPrice:commodity.data.originalPrice.floatValue/100.];
                        thisCell.style = QBSHomeCommodityCellNormalStyle;
                    }];
                    
                }
                
                @weakify(self);
                cell.buyAction = ^(id obj) {
                    @strongify(self);
                    QBSCartCommodity *cartCommodity = [[QBSCartCommodity alloc] initFromCommodity:commodity.data withAmount:1 columnId:commodity.data.columnId];
                    QBSOrderViewController *confirmVC = [[QBSOrderViewController alloc] initWithCartCommodities:@[cartCommodity]];
                    [self.navigationController pushViewController:confirmVC animated:YES];
                };
                return cell;
            } else {
                UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFeaturedCategoryCellReusableIdentifier forIndexPath:indexPath];
                cell.backgroundColor = [UIColor whiteColor];
                
                if (!cell.backgroundView) {
                    cell.backgroundView = [[UIImageView alloc] init];
                    cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
                    cell.backgroundView.clipsToBounds = YES;
                }
                
                UIImageView *imageView = (UIImageView *)cell.backgroundView;
                [imageView QB_setImageWithURL:[NSURL URLWithString:commodity.data.columnRmdImgUrl]];
                return cell;
            }
        }
        
        
//        QBSFeaturedCommodityRowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFeaturedCommodityCellReusableIdentifier forIndexPath:indexPath];
//        cell.backgroundColor = [UIColor whiteColor];
//        
//        QBSFeaturedCommodityList *commodityList = [self featuredCommodityCommodityListWithSectionIndex:indexPath.section];
//        
//        NSMutableArray<QBSHomeFeaturedItem *> *items = [NSMutableArray array];
//        [commodityList.data.commodityList enumerateObjectsUsingBlock:^(QBSCommodity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            QBSHomeFeaturedItem *item = [QBSHomeFeaturedItem itemWithTitle:obj.commodityName
//                                                                  imageURL:[NSURL URLWithString:obj.imgUrl]
//                                                                     price:obj.currentPrice.floatValue/100
//                                                             originalPrice:obj.originalPrice.floatValue/100];
//            if (item) {
//                [items addObject:item];
//            }
//        }];
//        cell.items = items;
//        
//        @weakify(self);
//        cell.selectionAction = ^(NSUInteger index, id obj) {
//            @strongify(self);
//            if (index >= commodityList.data.commodityList.count) {
//                return ;
//            }
//            
//            QBSCommodity *commodity = commodityList.data.commodityList[index];
//            [self showDetailOfCommodity:commodity withColumnId:commodityList.data.columnId];
//        };
//        return cell;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (IsHomeSectionIndexEqualsToSectionType(indexPath.section, QBSActivitySection)) {
        QBSActivityHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kActivityHeaderReusableIdentifier forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor whiteColor];
        
        @weakify(self);
        QBSFeaturedCommodityList *list = self.currentActivity;
        [headerView setCountDownTime:list.data.duration.unsignedIntegerValue withFinishedBlock:^(id obj) {
            @strongify(self);
            [self onAcitivitySwitchToNext];
        }];
        
        headerView.tapAction = ^(id obj) {
            @strongify(self);
            QBSActivityListViewController *listVC = [[QBSActivityListViewController alloc] initWithActivityList:self.activities currentActivity:self.currentActivity duration:[obj remainTime]];
            
            [self.navigationController pushViewController:listVC animated:YES];
        };
        return headerView;
    } else {
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    const CGFloat interItemSpacing = [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:indexPath.section];
    const UIEdgeInsets sectionInsets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
    
    if (IsHomeSectionIndexEqualsToSectionType(indexPath.section, QBSBannerSection)) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), CGRectGetWidth(collectionView.bounds)/kBannerImageScale);
    } else if (IsHomeSectionIndexEqualsToSectionType(indexPath.section, QBSFeaturedTypeSection)) {

        const NSUInteger remainWidth = CGRectGetWidth(collectionView.bounds) - interItemSpacing * 2 - sectionInsets.left - sectionInsets.right;
        NSUInteger itemWidth = remainWidth/3;
        if (remainWidth % 3 != 0 && indexPath.item % 3 == 2) {
            itemWidth = remainWidth - itemWidth * 2;
        }
        const CGFloat itemHeight = itemWidth *0.7;
        return CGSizeMake(itemWidth, itemHeight);
    } else if (IsHomeSectionIndexEqualsToSectionType(indexPath.section, QBSActivitySection)) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), CGRectGetWidth(collectionView.bounds) / 3);
    } else if (IsHomeSectionIndexEqualsToSectionType(indexPath.section, QBSFeaturedCommoditySection)) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), 180);
    } else {
        return CGSizeZero;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (IsHomeSectionIndexEqualsToSectionType(section, QBSFeaturedCommoditySection)) {
        return 10;
    }
    return [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (IsHomeSectionIndexEqualsToSectionType(section, QBSBannerSection)) {
        return UIEdgeInsetsZero;
//    } else if (IsHomeSectionIndexEqualsToSectionType(section, QBSFeaturedTypeSection)) {
//        return UIEdgeInsetsMake(0, 30, 0, 30);
    } else if (IsHomeSectionIndexEqualsToSectionType(section, QBSLastSection)) {
        return UIEdgeInsetsZero;
    } else {
        return UIEdgeInsetsMake(0, 0, 10, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (IsHomeSectionIndexEqualsToSectionType(section, QBSActivitySection)) {
        return CGSizeMake(0, 40);
    } else {
        return CGSizeZero;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (IsHomeSectionIndexEqualsToSectionType(indexPath.section, QBSFeaturedTypeSection)) {
        if (indexPath.item < self.featuredTypes.count) {
            QBSHomeGroup *group = self.featuredTypes[indexPath.item];
            [self pushViewControllerWithRecommendType:group.rmdType.unsignedIntegerValue
                                           columnType:group.columnType.unsignedIntegerValue
                                               isLeaf:group.isLeaf.boolValue
                                                relId:group.relId
                                              relName:group.name
                                               relUrl:[NSURL URLWithString:group.wapUrl]];
        }
    } else if (IsHomeSectionIndexEqualsToSectionType(indexPath.section, QBSFeaturedCommoditySection)) {
        if (indexPath.item < self.featuredCommodity.count) {
            QBSFeaturedCommodityList *commodity = self.featuredCommodity[indexPath.item];
            if (commodity.rmdType.unsignedIntegerValue == QBSFeaturedTypeRecommendationColumn) {
                [self pushViewControllerWithRecommendType:QBSRecommendTypeColumn
                                               columnType:commodity.data.columnType.unsignedIntegerValue
                                                   isLeaf:commodity.data.isLeaf.boolValue
                                                    relId:commodity.data.columnId
                                                  relName:nil
                                                   relUrl:nil];
            } else if (commodity.rmdType.unsignedIntegerValue == QBSFeaturedTypeRecommendationCommodity) {
                [self pushViewControllerWithRecommendType:QBSRecommendTypeCommodity
                                               columnType:commodity.data.columnType.unsignedIntegerValue
                                                   isLeaf:commodity.data.isLeaf.boolValue
                                                    relId:commodity.data.commodityId
                                                  relName:nil
                                                   relUrl:nil];
            }
        }
    }
}
@end
