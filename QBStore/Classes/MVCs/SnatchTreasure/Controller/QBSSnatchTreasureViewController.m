//
//  QBSSnatchTreasureViewController.m
//  QBStore
//
//  Created by Liang on 2016/12/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSSnatchTreasureViewController.h"
#import "QBSSantchTreasureCell.h"
#import "QBSSnatchTreasureHeaderView.h"
#import "QBSSnatchTreasureFooterView.h"

static NSString *const kSnatchTreasureCellReusableIdentifier = @"SnatchTreasureCellReusableIdentifier";
static NSString *const kSnatchTreasureHeaderReusableIdentifier = @"SnatchTreasureHeaderReusableIdentifier";
static NSString *const kSnatchTreasureFooterReusableIdentifier = @"SnatchTreasureFooterReusableIdentifier";


@interface QBSSnatchTreasureViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
}
//@property (nonatomic) 
@end

@implementation QBSSnatchTreasureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"2元抢购";
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 1;
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    [_layoutCollectionView registerClass:[QBSSantchTreasureCell class] forCellWithReuseIdentifier:kSnatchTreasureCellReusableIdentifier];
    [_layoutCollectionView registerClass:[QBSSnatchTreasureHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSnatchTreasureHeaderReusableIdentifier];
        [_layoutCollectionView registerClass:[QBSSnatchTreasureFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kSnatchTreasureFooterReusableIdentifier];
    [self.view addSubview:_layoutCollectionView];
    
    [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self);
    [_layoutCollectionView QBS_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self reloadData];
    }];
    [_layoutCollectionView QBS_triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData {
    [_layoutCollectionView reloadData];
    [_layoutCollectionView QBS_endPullToRefresh];
//    @weakify(self);
//    [[QBSRESTManager sharedManager] request_fetchSnatchTreasureCommodityWithCompletionHandler:^(id obj, NSError *error) {
//        @strongify(self);
//        [self->_layoutCollectionView reloadData];
//    }];
}


#pragma mark -- UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QBSSantchTreasureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSnatchTreasureCellReusableIdentifier forIndexPath:indexPath];
    cell.titleStr = @"123123";
    cell.commodityUrl = @"http://img.jtd51.com/images/funmall/20161101ssp.png";
    cell.currentPrice = @"200";
    cell.originalPrice = @"1111";
    cell.joinCount = @"123";
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        QBSSnatchTreasureHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSnatchTreasureHeaderReusableIdentifier forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        headerView.titleStr = [NSString stringWithFormat:@"%ld元夺宝",indexPath.section];
        headerView.timeStr = @"S1611101";
        headerView.dateStr = @"201612121338";
        return headerView;
    } else if (kind == UICollectionElementKindSectionFooter) {
        QBSSnatchTreasureFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSnatchTreasureFooterReusableIdentifier forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        return footerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
    
    const CGFloat width = kScreenWidth - insets.left - insets.right - layout.minimumLineSpacing;
    const CGFloat height = width * 0.4;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 0, 10, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, kWidth(88));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section != 1) {
        return CGSizeZero;
    } else {
        return CGSizeMake(kScreenWidth, kWidth(128));
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
