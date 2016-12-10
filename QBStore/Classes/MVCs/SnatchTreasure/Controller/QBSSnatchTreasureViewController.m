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
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, kWidth(20), 0);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
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
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        QBSSnatchTreasureHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSnatchTreasureHeaderReusableIdentifier forIndexPath:indexPath];
        return headerView;
    } else if (kind == UICollectionElementKindSectionFooter) {
        QBSSnatchTreasureFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSnatchTreasureFooterReusableIdentifier forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, kWidth(88));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section != 2) {
        return CGSizeZero;
    } else {
        return CGSizeMake(kScreenWidth, kWidth(128));
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
