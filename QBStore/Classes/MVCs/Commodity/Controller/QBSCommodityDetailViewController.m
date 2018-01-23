//
//  QBSCommodityDetailViewController.m
//  Pods
//
//  Created by Sean Yue on 16/7/8.
//
//

#import "QBSCommodityDetailViewController.h"
#import "QBSBannerCell.h"
#import "QBSCommodityDetailActivityCell.h"
#import "QBSCommodityDetailTitleCell.h"
#import "QBSCommodityDetailServiceMarkRowCell.h"
#import "QBSFavouritesHeaderView.h"
#import "QBSFavouritesCell.h"
#import "QBSCommodityDetailShoppingBar.h"

#import "QBSCommodityDetailSubViewController.h"
#import "QBSCustomerServiceController.h"
#import "QBSCartViewController.h"
#import "QBSOrderViewController.h"

#import "QBSCommodity.h"
#import "QBSCommodityDetail.h"
#import "QBSCartCommodity.h"

typedef NS_ENUM(NSUInteger, QBSCommodityDetailSection) {
    QBSBannerSection,
    QBSSummarySection,
    QBSDetailSection,
    QBSFavouritesSection,
    QBSCommodityDetailSectionCount
};

typedef NS_ENUM(NSUInteger, QBSCommodityDetailSummarySectionItem) {
    QBSSummaryActivityItem,
    QBSSummaryTitleItem,
    QBSSummaryServiceMarkItem,
    QBSSummaryItemCount
};

static NSString *const kBannerCellReusableIdentifier = @"BannerCellReusableIdentifier";
static NSString *const kActivityCellReusableIdentifier = @"ActivityCellReusableIdentifier";
static NSString *const kTitleCellReusableIdentifier = @"TitleCellReusableIdentifier";
static NSString *const kServiceMarkRowCellReusableIdentifier = @"ServiceMarkRowCellReusableIdentifier";
static NSString *const kDetailHeaderReusableIdentifier = @"DetailHeaderReusableIdentifier";
static NSString *const kDetailCellReusableIdentifier = @"DetailCellReusableIdentifier";
static NSString *const kFavouritesHeaderReusableIdentifier = @"FavouritesHeaderReusableIdentifier";
static NSString *const kFavouritesCellReusableIdentifier = @"FavouritesCellReusableIdentifier";

static const void *kBannerCellSelectedImageAnimatingAssociatedKey = &kBannerCellSelectedImageAnimatingAssociatedKey;

#define kShoppingBarHeight MAX(kScreenHeight*0.066, 38)

@interface QBSBannerCell (Detail)
@property (nonatomic) BOOL isSelectedImageAnimating;
@end

@implementation QBSBannerCell (Detail)

- (void)setIsSelectedImageAnimating:(BOOL)isSelectedImageAnimating {
    objc_setAssociatedObject(self, kBannerCellSelectedImageAnimatingAssociatedKey, @(isSelectedImageAnimating), OBJC_ASSOCIATION_COPY);
}

- (BOOL)isSelectedImageAnimating {
    NSNumber *value = objc_getAssociatedObject(self, kBannerCellSelectedImageAnimatingAssociatedKey);
    return value.boolValue;
}
@end

@interface QBSCommodityDetailViewController () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UICollectionView *_layoutCV;
    QBSCommodityDetailShoppingBar *_shoppingBar;
}
@property (nonatomic,retain) QBSCommodityDetail *commodityDetail;
@property (nonatomic,retain) QBSCommodityDetailSubViewController *subViewController;
@property (nonatomic) CGFloat titleCellHeight;
@property (nonatomic,retain) NSDate *activityEndDate;
@end

@implementation QBSCommodityDetailViewController

- (instancetype)initWithCommodityId:(NSNumber *)commodityId columnId:(NSNumber *)columnId {
    self = [super init];
    if (self) {
        _commodityId = commodityId;
        _columnId = columnId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
//    if ([layout respondsToSelector:@selector(sectionHeadersPinToVisibleBounds)]) {
//        layout.sectionHeadersPinToVisibleBounds = YES;
//    }
    
    _layoutCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCV.backgroundColor = self.view.backgroundColor;
    _layoutCV.delegate = self;
    _layoutCV.dataSource = self;
    [_layoutCV registerClass:[QBSBannerCell class] forCellWithReuseIdentifier:kBannerCellReusableIdentifier];
    [_layoutCV registerClass:[QBSCommodityDetailActivityCell class] forCellWithReuseIdentifier:kActivityCellReusableIdentifier];
    [_layoutCV registerClass:[QBSCommodityDetailTitleCell class] forCellWithReuseIdentifier:kTitleCellReusableIdentifier];
    [_layoutCV registerClass:[QBSCommodityDetailServiceMarkRowCell class] forCellWithReuseIdentifier:kServiceMarkRowCellReusableIdentifier];
    [_layoutCV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDetailHeaderReusableIdentifier];
    [_layoutCV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kDetailCellReusableIdentifier];
    [_layoutCV registerClass:[QBSFavouritesHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFavouritesHeaderReusableIdentifier];
    [_layoutCV registerClass:[QBSFavouritesCell class] forCellWithReuseIdentifier:kFavouritesCellReusableIdentifier];
    [self.view addSubview:_layoutCV];
    {
        [_layoutCV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, kShoppingBarHeight, 0));
        }];
    }
    
    @weakify(self);
    [_layoutCV QBS_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadCommodityDetails];
    }];
    [_layoutCV QBS_triggerPullToRefresh];
    
    _shoppingBar = [[QBSCommodityDetailShoppingBar alloc] init];
    _shoppingBar.buyButton.enabled = NO;
    _shoppingBar.addToCartButton.enabled = NO;
    [self.view addSubview:_shoppingBar];
    {
        [_shoppingBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(kShoppingBarHeight);
        }];
    }
    
    _shoppingBar.cartAction = ^(id obj) {
        @strongify(self);
        [self.navigationController pushViewController:[[QBSCartViewController alloc] init] animated:YES];
    };
    
    _shoppingBar.addToCartAction = ^(id obj) {
        @strongify(self);
        
        if (self.commodityDetail) {
            [self.commodityDetail addToCartWithColumnId:self.columnId completion:^(BOOL success) {
                if (success) {
                    @strongify(self);
                    [self updateCartCommodityAmount];
                }
            }];
        }
    };
    
    _shoppingBar.buyAction = ^(id obj) {
        @strongify(self);
        
        if (self.commodityDetail) {
            QBSCartCommodity *cartCommodity = [[QBSCartCommodity alloc] initFromCommodity:self.commodityDetail withAmount:1 columnId:self.columnId];
            QBSOrderViewController *confirmVC = [[QBSOrderViewController alloc] initWithCartCommodities:@[cartCommodity]];
            [self.navigationController pushViewController:confirmVC animated:YES];
        }
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateCartCommodityAmount];
}

- (void)updateCartCommodityAmount {
    [QBSCartCommodity totalSelectedAmountAsync:^(NSUInteger amount) {
        _shoppingBar.numberOfCommodities = amount;
    }];
}

- (void)loadCommodityDetails {
    @weakify(self);
    [[QBSRESTManager sharedManager] request_queryCommodityDetailWithCommodityId:self.commodityId
                                                                       columnId:self.columnId
                                                              completionHandler:^(id obj, NSError *error)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutCV QBS_endPullToRefresh];
        
        if (obj) {
            QBSCommodityDetail *commodityDetail = ((QBSCommodityDetailResponse *)obj).commodityInfo;
            if (!commodityDetail.isAvailable) {
                [[QBSHUDManager sharedManager] showError:@"该商品已经下架！"];
                
                [QBSCartCommodity objectFromPersistenceWithPKValue:commodityDetail.commodityId async:^(id obj) {
                    if (obj) {
                        ((QBSCartCommodity *)obj).isAvailable = @(NO);
                        [((QBSCartCommodity *)obj) save];
                    }
                }];
                [self.navigationController popViewControllerAnimated:YES];
                return ;
            }
            self->_shoppingBar.addToCartButton.enabled = YES;
            self->_shoppingBar.buyButton.enabled = YES;
            
            self.commodityDetail = commodityDetail;
            self.title = self.commodityDetail.commodityName;
            
            if (self.commodityDetail.activityPrice && self.commodityDetail.leftTime) {
                self.activityEndDate = [NSDate dateWithTimeIntervalSinceNow:self.commodityDetail.leftTime.unsignedIntegerValue];
            }
            
            self.subViewController.commodityDetail = self.commodityDetail;
            [self->_layoutCV reloadData];
        } else {
            error.qbsErrorMessage = [NSString stringWithFormat:@"商品详情加载失败：%@", error.qbsErrorMessage];
            QBSHandleError(error);
        }
    }];
}

- (void)setTitle:(NSString *)title {
    NSString *commodityName = title;
    const NSUInteger titleLength = 15;
    NSString *shortTitle = commodityName.length <= titleLength ? commodityName : [[commodityName substringToIndex:titleLength-3] stringByAppendingString:@"..."];
    [super setTitle:shortTitle];
}

- (QBSCommodityDetailSubViewController *)subViewController {
    if (_subViewController) {
        return _subViewController;
    }
    
    @weakify(self);
    _subViewController = [[QBSCommodityDetailSubViewController alloc] initWithCommodityId:self.commodityId];
    _subViewController.contentHeightChangedAction = ^(id obj) {
        @strongify(self);
        if (self) {
            [self->_layoutCV.collectionViewLayout invalidateLayout];
//            [self->_layoutCV reloadData];
        }
    };
    return _subViewController;
}

- (void)bannerCell:(QBSBannerCell *)bannerCell didSelectBannerAtIndex:(NSUInteger)index {
    if (index >= self.commodityDetail.displayList.count) {
        return ;
    }
    
    if (bannerCell.isSelectedImageAnimating) {
        return ;
    }
    
    bannerCell.isSelectedImageAnimating = YES;
    
    QBSCommodityImageInfo *imageInfo = self.commodityDetail.displayList[index];
    
    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.backgroundColor = [UIColor whiteColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView QB_setImageWithURL:[NSURL URLWithString:imageInfo.imgUrl]];
    imageView.frame = [bannerCell convertRect:bannerCell.bounds toView:self.view.window];
    [self.view.window addSubview:imageView];
    
    QBSBannerCell *fullScreenBanner = [[QBSBannerCell alloc] initWithFrame:self.view.window.bounds];
    fullScreenBanner.backgroundColor = [UIColor whiteColor];
    fullScreenBanner.imageURLStrings = bannerCell.imageURLStrings;
    fullScreenBanner.shouldAutoScroll = bannerCell.shouldAutoScroll;
    fullScreenBanner.shouldInfiniteScroll = bannerCell.shouldInfiniteScroll;
    fullScreenBanner.currentIndex = bannerCell.currentIndex;
    fullScreenBanner.pageControlYAspect = 0.8;
    fullScreenBanner.selectionAction = ^(NSUInteger index, QBSBannerCell *obj) {
        [imageView QB_setImageWithURL:[NSURL URLWithString:obj.imageURLStrings[index]]];
        imageView.hidden = NO;
        bannerCell.currentIndex = obj.currentIndex;
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            obj.alpha = 0;
        } completion:^(BOOL finished) {
            [obj removeFromSuperview];
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            imageView.frame = [bannerCell convertRect:bannerCell.bounds toView:self.view.window];
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            bannerCell.isSelectedImageAnimating = NO;
        }];
    };
    
    fullScreenBanner.alpha = 0;
    [self.view.window addSubview:fullScreenBanner];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        imageView.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            fullScreenBanner.alpha = 1;
        } completion:^(BOOL finished) {
            imageView.hidden = YES;
        }];
        
        //bannerCell.isSelectedImageAnimating = NO;
    }];
    
//    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        imageView.bounds = self.view.window.bounds;
//    } completion:^(BOOL finished) {
//        fullScreenBanner.alpha = 1;
//        bannerCell.isSelectedImageAnimating = NO;
//    }];
    
//    [UIView animateWithDuration:0.1 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
//        fullScreenBanner.alpha = 1;
//    } completion:^(BOOL finished) {
//        imageView.hidden = YES;
//        bannerCell.isSelectedImageAnimating = NO;
//    }];
}

- (BOOL)isActivityCommodity {
    if (!self.activityEndDate) {
        return NO;
    }
    
    NSTimeInterval timeInterval = [self.activityEndDate timeIntervalSinceNow];
    if (timeInterval <= 0) {
        return NO;
    }
    
    return YES;
}

- (QBSCommodityDetailSummarySectionItem)summarySectionItemAtIndex:(NSUInteger)itemIndex {
    if ([self isActivityCommodity]) {
        return itemIndex;
    } else {
        return itemIndex+1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegateFlowLayout,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.commodityDetail ? QBSCommodityDetailSectionCount : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == QBSSummarySection) {
        NSInteger numberOfItems = QBSSummaryItemCount;
        if (![self isActivityCommodity]) {
            --numberOfItems;
        }
        
        if (self.commodityDetail.serviceList.count == 0) {
            --numberOfItems;
        }
        return numberOfItems;
    } else if (section == QBSFavouritesSection) {
        return self.commodityDetail.guessCommodityList.count;
    } else {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == QBSBannerSection) {
        QBSBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBannerCellReusableIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.shouldAutoScroll = NO;
        cell.shouldInfiniteScroll = NO;
        
        NSMutableArray *imageURLStrings = [NSMutableArray array];
        [self.commodityDetail.displayList enumerateObjectsUsingBlock:^(QBSCommodityImageInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.imgUrl) {
                [imageURLStrings addObject:obj.imgUrl];
            }
        }];
        cell.imageURLStrings = imageURLStrings;
        @weakify(self);
        cell.selectionAction = ^(NSUInteger index, id obj) {
            @strongify(self);
            [self bannerCell:obj didSelectBannerAtIndex:index];
        };
        return cell;
    } else if (indexPath.section == QBSSummarySection) {
        UICollectionViewCell *summaryCell;
        if ([self summarySectionItemAtIndex:indexPath.item] == QBSSummaryTitleItem) {
            QBSCommodityDetailTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTitleCellReusableIdentifier forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
            summaryCell = cell;
            
            cell.title = self.commodityDetail.commodityName;
            cell.sold = self.commodityDetail.numSold.unsignedIntegerValue;
            cell.onlyShowTitle = [self isActivityCommodity];
            [cell setPrice:self.commodityDetail.currentPrice.floatValue/100 withOriginalPrice:self.commodityDetail.originalPrice.floatValue/100];
            
            NSMutableArray *tags = [NSMutableArray array];
            [self.commodityDetail.tagsInfo enumerateObjectsUsingBlock:^(QBSCommodityTag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.tagsName.length > 0) {
                    [tags addObject:obj.tagsName];
                }
            }];
            
            //tags = @[@"限时秒杀",@"优惠特价",@"XXXX",@"OOOO",@"限时秒杀",@"优惠特价",@"XXXX",@"OOOO",@"限时秒杀",@"优惠特价",@"XXXX",@"OOOO",@"限时秒杀",@"优惠特价",@"XXXX",@"OOOO"].mutableCopy;
            if (cell.tags != tags && ![cell.tags isEqualToArray:tags]) {
                cell.tags = tags;
            }
            
            self.titleCellHeight = cell.cellHeight;
            [collectionView.collectionViewLayout invalidateLayout];
            
            @weakify(self);
            cell.customerServiceAction = ^(id obj) {
                @strongify(self);
                QBSCustomerServiceController *csController = [[QBSCustomerServiceController alloc] init];
                [csController showInView:self.view.window];
            };
        } else if ([self summarySectionItemAtIndex:indexPath.item] == QBSSummaryServiceMarkItem) {
            QBSCommodityDetailServiceMarkRowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kServiceMarkRowCellReusableIdentifier forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
            summaryCell = cell;
            
            cell.marks = self.commodityDetail.serviceList;
        } else if ([self summarySectionItemAtIndex:indexPath.item] == QBSSummaryActivityItem) {
            QBSCommodityDetailActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kActivityCellReusableIdentifier forIndexPath:indexPath];
            summaryCell = cell;
            
            cell.backgroundColor = [UIColor colorWithHexString:@"#F8E71C"];
            cell.currentPrice = self.commodityDetail.currentPrice.floatValue/100.;
            cell.originalPrice = self.commodityDetail.originalPrice.floatValue/100.;
            cell.sold = self.commodityDetail.numSold.unsignedIntegerValue;
            
            if ([self isActivityCommodity]) {
                [cell setCountDownTime:[self.activityEndDate timeIntervalSinceNow] withFinishedBlock:^(id obj) {
                    [collectionView reloadSections:[NSIndexSet indexSetWithIndex:QBSSummarySection]];
                }];
            }
        }
        
        if (indexPath.item == 0) {
            summaryCell.layer.shadowOpacity = 0.3;
            summaryCell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        } else {
            summaryCell.layer.shadowOpacity = 0;
        }
        return summaryCell;
    } else if (indexPath.section == QBSDetailSection) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDetailCellReusableIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        if (![self.childViewControllers containsObject:self.subViewController]) {
            [self addChildViewController:self.subViewController];
            
            if (![cell.subviews containsObject:self.subViewController.view]) {
                [cell addSubview:self.subViewController.view];
                {
                    [self.subViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(cell);
                    }];
                }
            }
            
            [self.subViewController didMoveToParentViewController:self];
        }
        
        return cell;
    } else if (indexPath.section == QBSFavouritesSection) {
        QBSFavouritesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFavouritesCellReusableIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        if (indexPath.item < self.commodityDetail.guessCommodityList.count) {
            QBSCommodity *favCommodity = self.commodityDetail.guessCommodityList[indexPath.item];
            cell.imageURL = [NSURL URLWithString:favCommodity.imgUrl];
            cell.title = favCommodity.commodityName;
            cell.sold = favCommodity.numSold.unsignedIntegerValue;
            [cell setPrice:favCommodity.currentPrice.floatValue/100 withOriginalPrice:favCommodity.originalPrice.floatValue/100];
        }
        return cell;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == QBSFavouritesSection) {
        QBSFavouritesHeaderView *favHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kFavouritesHeaderReusableIdentifier forIndexPath:indexPath];
        favHeader.backgroundColor = collectionView.backgroundColor;
        return favHeader;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == QBSBannerSection) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), CGRectGetWidth(collectionView.bounds)/1.5);
    } else if (indexPath.section == QBSSummarySection) {
        if ([self summarySectionItemAtIndex:indexPath.item] == QBSSummaryTitleItem) {
            return CGSizeMake(CGRectGetWidth(collectionView.bounds), self.titleCellHeight);
        } else if ([self summarySectionItemAtIndex:indexPath.item] == QBSSummaryServiceMarkItem) {
            return CGSizeMake(CGRectGetWidth(collectionView.bounds), CGRectGetWidth(collectionView.bounds)*0.16);
        } else if ([self summarySectionItemAtIndex:indexPath.item] == QBSSummaryActivityItem) {
            return CGSizeMake(CGRectGetWidth(collectionView.bounds), CGRectGetWidth(collectionView.bounds)*0.173);
        }
        
    } else if (indexPath.section == QBSDetailSection) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), self.subViewController.contentHeight);
    } else if (indexPath.section == QBSFavouritesSection) {
        const CGFloat interItemSpacing = [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:indexPath.section];
        const UIEdgeInsets sectionInsets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
        const CGFloat itemWidth = (CGRectGetWidth(collectionView.bounds) - interItemSpacing - sectionInsets.left - sectionInsets.right)/2;
        const CGFloat itemHeight = MAX(225,itemWidth / [QBSFavouritesCell cellAspects]);
        return CGSizeMake(itemWidth, itemHeight);
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == QBSSummarySection) {
        return 1;
    } else if (section == QBSFavouritesSection) {
        return [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
    } else {
        return 0;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == QBSFavouritesSection) {
        return 10;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == QBSBannerSection) {
        return UIEdgeInsetsZero;
    } else if (section == QBSDetailSection) {
        return UIEdgeInsetsMake(1, 0, 0, 0);
    } else if (section == QBSFavouritesSection) {
        if (self.commodityDetail.guessCommodityList.count == 0) {
            return UIEdgeInsetsMake(0, 10, 0, 10);
        } else {
            return UIEdgeInsetsMake(0, 10, 10, 10);
        }
    } else {
        return UIEdgeInsetsMake(0, 0, 15, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == QBSFavouritesSection) {
        if (self.commodityDetail.guessCommodityList.count > 0) {
            return CGSizeMake(0, 44);
        }
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == QBSFavouritesSection) {
        if (indexPath.item < self.commodityDetail.guessCommodityList.count) {
            QBSCommodity *commodity = self.commodityDetail.guessCommodityList[indexPath.item];
            QBSCommodityDetailViewController *detailVC = [[QBSCommodityDetailViewController alloc] initWithCommodityId:commodity.commodityId columnId:self.columnId];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}
@end
