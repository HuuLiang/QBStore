//
//  QBSOrderCommodityListCell.m
//  Pods
//
//  Created by Sean Yue on 16/7/29.
//
//

#import "QBSOrderCommodityListCell.h"

static NSString *const kCellReusableIdentifier = @"CellReusableIdentifier";
static const void *kImageViewAssociatedKey = &kImageViewAssociatedKey;

@interface QBSOrderCommodityListCell () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_commodityCV;
    UILabel *_amountLabel;
    
    UIImageView *_leftPagingIndicator;
    UIImageView *_rightPagingIndicator;
}
@end

@implementation QBSOrderCommodityListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _commodityCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _commodityCV.backgroundColor = self.backgroundColor;
        _commodityCV.delegate = self;
        _commodityCV.dataSource = self;
        [_commodityCV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellReusableIdentifier];
        [_commodityCV addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) options:NSKeyValueObservingOptionNew context:nil];
        [_commodityCV addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew context:nil];
        [self.contentView addSubview:_commodityCV];
        {
            [_commodityCV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self.contentView);
                make.width.equalTo(self.contentView).multipliedBy(0.8);
            }];
        }
        
        @weakify(self);
        [_commodityCV bk_whenTapped:^{
            @strongify(self);
            SafelyCallBlock(self.commodityAction, self);
        }];
        
        _leftPagingIndicator = [[UIImageView alloc] initWithImage:[[UIImage QBS_imageWithResourcePath:@"paging_indicator"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        _leftPagingIndicator.tintColor = [UIColor colorWithHexString:@"#FF206F"];
        _leftPagingIndicator.contentMode = UIViewContentModeScaleAspectFit;
        _leftPagingIndicator.transform = CGAffineTransformMakeRotation(M_PI);
        _leftPagingIndicator.hidden = YES;
        [self.contentView addSubview:_leftPagingIndicator];
        {
            [_leftPagingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_commodityCV).offset(5);
                make.centerY.equalTo(_commodityCV);
                make.size.mas_equalTo(CGSizeMake(15, 15));
            }];
        }
        
        _rightPagingIndicator = [[UIImageView alloc] initWithImage:[[UIImage QBS_imageWithResourcePath:@"paging_indicator"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        _rightPagingIndicator.tintColor = _leftPagingIndicator.tintColor;
        _rightPagingIndicator.contentMode = UIViewContentModeScaleAspectFit;
        _rightPagingIndicator.hidden = YES;
        [self.contentView addSubview:_rightPagingIndicator];
        {
            [_rightPagingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_commodityCV).offset(-5);
                make.centerY.equalTo(_commodityCV);
                make.size.equalTo(_leftPagingIndicator);
            }];
        }
        
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = self.separatorColor;
        [self.contentView addSubview:separatorView];
        {
            [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_commodityCV.mas_right).offset(10);
                make.top.bottom.equalTo(_commodityCV);
                make.width.mas_equalTo(0.5);
            }];
        }
        
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _amountLabel.font = kSmallFont;
        _amountLabel.text = @"共0件";
        _amountLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_amountLabel];
        {
            [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(separatorView.mas_right);
                make.centerY.right.equalTo(self.contentView);
            }];
        }
    }
    return self;
}

- (void)dealloc {
    [_commodityCV removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize))];
    [_commodityCV removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
}

- (void)setImageURLStrings:(NSArray *)imageURLStrings {
    _imageURLStrings = imageURLStrings;
    
    [_commodityCV reloadData];
    [self updateVisibilitiesOfPagingIndicators];
}

- (void)setAmount:(NSUInteger)amount {
    _amount = amount;
    
    _amountLabel.text = [NSString stringWithFormat:@"共%ld件", (unsigned long)amount];
}

- (void)updateVisibilitiesOfPagingIndicators {
    if (_commodityCV.contentOffset.x < CGRectGetHeight(_commodityCV.bounds) / 2) {
        _leftPagingIndicator.hidden = YES;
    } else {
        _leftPagingIndicator.hidden = NO;
    }
    
    if (_commodityCV.contentOffset.x + CGRectGetWidth(_commodityCV.bounds) > _commodityCV.contentSize.width - CGRectGetHeight(_commodityCV.bounds) / 2) {
        _rightPagingIndicator.hidden = YES;
    } else {
        _rightPagingIndicator.hidden = NO;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]
        || [keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
        [self updateVisibilitiesOfPagingIndicators];
    }
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageURLStrings.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReusableIdentifier forIndexPath:indexPath];
    
    UIImageView *imageView = objc_getAssociatedObject(cell, kImageViewAssociatedKey);
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell addSubview:imageView];
        {
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell).insets(UIEdgeInsetsMake(10, 10, 10, 10));
            }];
        }
        
        objc_setAssociatedObject(cell, kImageViewAssociatedKey, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (indexPath.item < self.imageURLStrings.count) {
        [imageView QB_setImageWithURL:[NSURL URLWithString:self.imageURLStrings[indexPath.item]]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetHeight(collectionView.bounds), CGRectGetHeight(collectionView.bounds));
}

@end
