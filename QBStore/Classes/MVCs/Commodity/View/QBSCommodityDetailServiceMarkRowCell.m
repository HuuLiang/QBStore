//
//  QBSCommodityDetailServiceMarkRowCell.m
//  Pods
//
//  Created by Sean Yue on 16/7/9.
//
//

#import "QBSCommodityDetailServiceMarkRowCell.h"
#import "QBSServiceMarkCell.h"
#import "QBSCommodityDetail.h"

static NSString *const kServiceMarkCellReusableIdentifier = @"ServiceMarkCellReusableIdentifier";

@interface QBSCommodityDetailServiceMarkRowCell () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCV;
}
@end

@implementation QBSCommodityDetailServiceMarkRowCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _layoutCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _layoutCV.backgroundColor = self.backgroundColor;
        _layoutCV.delegate = self;
        _layoutCV.dataSource = self;
        [_layoutCV registerClass:[QBSServiceMarkCell class] forCellWithReuseIdentifier:kServiceMarkCellReusableIdentifier];
        [self addSubview:_layoutCV];
        {
            [_layoutCV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
    }
    return self;
}

- (void)setMarks:(NSArray<QBSCommodityServiceMark *> *)marks {
    _marks = marks;
    [_layoutCV reloadData];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.marks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QBSServiceMarkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kServiceMarkCellReusableIdentifier forIndexPath:indexPath];

    if (indexPath.item < self.marks.count) {
        QBSCommodityServiceMark *mark = self.marks[indexPath.item];
        cell.imageURL = [NSURL URLWithString:mark.imgUrl];
        cell.name = mark.serviceName;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    const CGFloat itemHeight = CGRectGetHeight(collectionView.bounds) * 0.7;
    const CGFloat itemWidth = itemHeight * 1.5;
    return CGSizeMake(itemWidth, itemHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGRectGetWidth(collectionView.bounds) * 0.2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 0);
}
@end
