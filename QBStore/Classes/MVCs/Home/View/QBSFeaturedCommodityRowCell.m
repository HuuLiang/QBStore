//
//  QBSFeaturedCommodityRowCell.m
//  Pods
//
//  Created by Sean Yue on 16/7/5.
//
//

#import "QBSFeaturedCommodityRowCell.h"
#import "QBSFeaturedCommodityCell.h"

@implementation QBSHomeFeaturedItem

+ (instancetype)itemWithTitle:(NSString *)title imageURL:(NSURL *)imageURL price:(CGFloat)price originalPrice:(CGFloat)originalPrice {
    QBSHomeFeaturedItem *item = [[self alloc] init];
    item.title = title;
    item.imageURL = imageURL;
    item.price = price;
    item.originalPrice = originalPrice;
    return item;
}
@end

static NSString *const kFeaturedCommodityCellReusableIdentifier = @"FeaturedCommodityCellReusableIdentifier";

@interface QBSFeaturedCommodityRowCell () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UICollectionView *_contentView;
}
@end

@implementation QBSFeaturedCommodityRowCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _contentView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.backgroundColor = self.backgroundColor;
        [_contentView registerClass:[QBSFeaturedCommodityCell class] forCellWithReuseIdentifier:kFeaturedCommodityCellReusableIdentifier];
        [self addSubview:_contentView];
        {
            [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
    }
    return self;
}

- (void)setItems:(NSArray<QBSHomeFeaturedItem *> *)items {
    _items = items;
    [_contentView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QBSFeaturedCommodityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFeaturedCommodityCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < _items.count) {
        QBSHomeFeaturedItem *item = _items[indexPath.item];
        cell.title = item.title;
        cell.imageURL = item.imageURL;
        [cell setPrice:item.price withOriginalPrice:item.originalPrice];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.bounds) * 0.4, CGRectGetHeight(collectionView.bounds));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SafelyCallBlock(self.selectionAction, indexPath.item, self);
}
@end
