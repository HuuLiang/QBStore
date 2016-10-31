//
//  QBSCategoryViewController.m
//  QBStore
//
//  Created by Sean Yue on 2016/10/28.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSCategoryViewController.h"
#import "QBSCategoryCell.h"
#import "QBSCategoryList.h"
#import "QBSCommodityListViewController.h"

static NSString *const kCategoryCellReusableIdentifier = @"CategoryCellReusableIdentifier";

@interface QBSCategoryViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCV;
}
@property (nonatomic,retain) NSArray<QBSCategory *> *categories;
@end

@implementation QBSCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = layout.minimumInteritemSpacing;
    layout.sectionInset = UIEdgeInsetsMake(layout.minimumInteritemSpacing,
                                           layout.minimumInteritemSpacing,
                                           layout.minimumInteritemSpacing,
                                           layout.minimumInteritemSpacing);
    
    _layoutCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCV.backgroundColor = self.view.backgroundColor;
    _layoutCV.delegate = self;
    _layoutCV.dataSource = self;
    [_layoutCV registerClass:[QBSCategoryCell class] forCellWithReuseIdentifier:kCategoryCellReusableIdentifier];
    [self.view addSubview:_layoutCV];
    {
        [_layoutCV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutCV QBS_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadCategories];
    }];
    [_layoutCV QBS_triggerPullToRefresh];
}

- (void)loadCategories {
    @weakify(self);
    [[QBSRESTManager sharedManager] request_queryCategoriesWithCompletionHandler:^(id obj, NSError *error) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutCV QBS_endPullToRefresh];
        
        if (obj) {
            QBSCategoryListResponse *resp = obj;
            self.categories = resp.channelDto.columnList;
            [self->_layoutCV reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QBSCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCategoryCellReusableIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.item < self.categories.count) {
        QBSCategory *category = self.categories[indexPath.item];
        cell.title = category.columnName;
        cell.imageURL = [NSURL URLWithString:category.columnImgUrl];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    const UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    const UIEdgeInsets sectionInsets = layout.sectionInset;
    const CGFloat interItemSpacing = layout.minimumInteritemSpacing;
    
    const CGFloat itemWidth = (CGRectGetWidth(collectionView.bounds)-sectionInsets.left-sectionInsets.right-interItemSpacing)/2;
    const CGFloat itemHeight = itemWidth;
    return CGSizeMake(itemWidth, itemHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.categories.count) {
        QBSCategory *category = self.categories[indexPath.item];
        QBSCommodityListViewController *listVC = [[QBSCommodityListViewController alloc] initWithColumnId:category.columnId
                                                                                               columnType:category.columnType.unsignedIntegerValue
                                                                                               columnName:category.columnName];
        [self.navigationController pushViewController:listVC animated:YES];
    }
}
@end
