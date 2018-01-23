//
//  QBSHomeActivityRowCell.m
//  Pods
//
//  Created by Sean Yue on 16/7/1.
//
//

#import "QBSHomeActivityRowCell.h"
#import "QBSHomeActivityCell.h"

@implementation QBSHomeActivityItem

+ (instancetype)itemWithImageURL:(NSURL *)imageURL price:(CGFloat)price originalPrice:(CGFloat)originalPrice tagURL:(NSURL *)tagURL {
    QBSHomeActivityItem *item = [[self alloc] init];
    item.imageURL = imageURL;
    item.price = price;
    item.originalPrice = originalPrice;
    item.tagURL = tagURL;
    return item;
}
@end

static NSString *const kActivityCellReusableIdentifier = @"ActivityCellReusableIdentifier";

@interface QBSHomeActivityRowCell () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UICollectionView *_contentView;
}
@end

@implementation QBSHomeActivityRowCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _contentView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.backgroundColor = self.backgroundColor;
        [_contentView registerClass:[QBSHomeActivityCell class] forCellWithReuseIdentifier:kActivityCellReusableIdentifier];
        [self addSubview:_contentView];
        {
            [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
    }
    return self;
}

- (void)setItems:(NSArray<QBSHomeActivityItem *> *)items {
    _items = items;
    [_contentView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QBSHomeActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kActivityCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < _items.count) {
        QBSHomeActivityItem *item = _items[indexPath.item];
        cell.imageURL = item.imageURL;
        cell.price = item.price;
        cell.originalPrice = item.originalPrice;
        cell.tagURL = item.tagURL;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.bounds) * 0.25, CGRectGetHeight(collectionView.bounds));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SafelyCallBlock(self.selectionAction, indexPath.item, self);
}
@end
