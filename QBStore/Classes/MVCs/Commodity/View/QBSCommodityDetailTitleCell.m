//
//  QBSCommodityDetailTitleCell.m
//  Pods
//
//  Created by Sean Yue on 16/7/9.
//
//

#import "QBSCommodityDetailTitleCell.h"
#import "QBSCollectionViewCell.h"
#import "QBSCustomerServiceButton.h"

static NSString *const kTagCellReusableIdentifier = @"TagCellReusableIdentifier";

@interface QBSCommodityDetailTitleCell () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UILabel *_soldLabel;
    UIButton *_customerServiceButton;
    UIView *_separatorView;
    
    UICollectionView *_tagCV;
}
@property (nonatomic) CGSize priceSize;

@property (nonatomic,retain) NSMutableArray<UILabel *> *tagLabels;
@property (nonatomic,retain) NSMutableArray<NSNumber *> *tagWidths;
@property (nonatomic,readonly) CGFloat tagHeight;
@property (nonatomic,retain,readonly) UIFont *tagFont;
@property (nonatomic) CGSize titleSize;
@property (nonatomic,readonly) CGFloat csButtonWidth;
@end

@implementation QBSCommodityDetailTitleCell
@synthesize tagFont = _tagFont;

DefineLazyPropertyInitialization(NSMutableArray, tagLabels)
DefineLazyPropertyInitialization(NSMutableArray, tagWidths)

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = kBigFont;
        _titleLabel.numberOfLines = 2;
        [self addSubview:_titleLabel];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = kBigFont;
        [self addSubview:_priceLabel];
        
        _soldLabel = [[UILabel alloc] init];
        _soldLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _soldLabel.font = kExtraSmallFont;
        [self addSubview:_soldLabel];

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 3;
        layout.minimumLineSpacing = 3;
        
        _tagCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _tagCV.backgroundColor = self.backgroundColor;
        _tagCV.delegate = self;
        _tagCV.dataSource = self;
        [_tagCV registerClass:[QBSCollectionViewCell class] forCellWithReuseIdentifier:kTagCellReusableIdentifier];
        [self addSubview:_tagCV];
        
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = [UIColor colorWithHexString:@"#E8E8E8"];
        [self addSubview:_separatorView];
        
        _customerServiceButton = [[QBSCustomerServiceButton alloc] init];
        [self addSubview:_customerServiceButton];
        
        @weakify(self);
        [_customerServiceButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            SafelyCallBlock(self.customerServiceAction, self);
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat fullWidth = CGRectGetWidth(self.bounds);
    const CGFloat csButtonWidth = self.csButtonWidth;
    
    _titleLabel.frame = CGRectMake(10, kScreenHeight * 0.01, self.titleSize.width, self.titleSize.height);
    _priceLabel.frame = CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_titleLabel.frame) + kScreenHeight * 0.01, _priceSize.width, _priceSize.height);
    
    const CGSize soldSize = [_soldLabel.text sizeWithAttributes:@{NSFontAttributeName:_soldLabel.font}];
    const CGFloat soldX = CGRectGetMaxX(_priceLabel.frame)+kScreenWidth*0.015;
    _soldLabel.frame = CGRectMake(soldX,
                                  _priceLabel.frame.origin.y + (_priceSize.height - soldSize.height)/2,
                                  CGRectGetMaxX(_titleLabel.frame) - soldX - csButtonWidth, soldSize.height);
    
    _separatorView.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame), 5, 0.5, CGRectGetMaxY(_priceLabel.frame) - 10);
    _customerServiceButton.frame = CGRectMake(CGRectGetMaxX(_separatorView.frame), 0, csButtonWidth, CGRectGetMaxY(_priceLabel.frame));
    
    const CGFloat tagCollectionViewHeight = [self calculateTagCollectionViewHeight];
    _tagCV.frame = CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_priceLabel.frame)+kScreenHeight * 0.01, fullWidth-20, tagCollectionViewHeight);
}

- (CGFloat)csButtonWidth {
    return CGRectGetWidth(self.bounds) * 0.15;
}

- (CGFloat)cellHeight {
    const CGFloat tagCollectionViewHeight = [self calculateTagCollectionViewHeight];
    return self.titleSize.height + (_priceLabel.hidden ? 0 : _priceLabel.font.pointSize) + tagCollectionViewHeight + (tagCollectionViewHeight == 0 ? kScreenHeight *0.04 : kScreenHeight * 0.05);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
    
    const CGFloat titleWidth = CGRectGetWidth(self.bounds) - 20 - self.csButtonWidth;
    const CGRect titleRect = [title boundingRectWithSize:CGSizeMake(titleWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_titleLabel.font} context:nil];
    self.titleSize = CGSizeMake(titleWidth, titleRect.size.height);
}

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice {
    NSString *priceString = [NSString stringWithFormat:@"¥%@ ", QBSIntegralPrice(price)];
    
    NSAttributedString *priceAttrString = [[NSAttributedString alloc] initWithString:priceString attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FD472B"],
                                                                                                                            NSFontAttributeName:kBigFont}];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithAttributedString:priceAttrString];
    
    if (originalPrice > 0) {
        NSString *originalPriceString = QBSIntegralPrice(originalPrice);
        NSAttributedString *originalPriceAttrString = [[NSAttributedString alloc] initWithString:originalPriceString attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],
                                                                                                                                  NSFontAttributeName:kExtraSmallFont,
                                                                                                                                  NSStrikethroughStyleAttributeName:@1}];
        [attrString appendAttributedString:originalPriceAttrString];
    }
    
    _priceLabel.attributedText = attrString;
    _priceSize = [attrString size];
    
    [self setNeedsLayout];
}

- (void)setSold:(NSUInteger)sold {
    _sold = sold;
    _soldLabel.text = [NSString stringWithFormat:@"已售:%ld件", (unsigned long)sold];
    
    [self setNeedsLayout];
}

- (void)setTags:(NSArray<NSString *> *)tags {
    _tags = tags;
    
    [self.tagWidths removeAllObjects];
    [tags enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize tagSize = [obj sizeWithAttributes:@{NSFontAttributeName:self.tagFont}];
        [self.tagWidths addObject:@(tagSize.width + 5)];
    }];
    
    [_tagCV reloadData];
    
    [self setNeedsLayout];
}

- (UIFont *)tagFont {
    if (_tagFont) {
        return _tagFont;
    }
    
    _tagFont = kExExSmallFont;
    return _tagFont;
}

- (CGFloat)tagHeight {
    return self.tagFont.pointSize+5;
}

- (CGFloat)calculateTagCollectionViewHeight {
    if (_tagCV.hidden) {
        return 0;
    }
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_tagCV.collectionViewLayout;
    const CGFloat interItemSpacing = layout.minimumInteritemSpacing;
    const CGFloat lineSpacing = layout.minimumLineSpacing;
    const CGFloat fullWidth = CGRectGetWidth(self.bounds);
    
    __block NSUInteger rows = 0;
    __block CGFloat remainWidth = 0;
    [self.tagWidths enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (remainWidth < obj.floatValue) {
            remainWidth = fullWidth;
            ++rows;
        }
        
        remainWidth = remainWidth - obj.floatValue - interItemSpacing;
    }];
    
    return rows == 0 ? 0 : rows * self.tagHeight + (rows - 1) * lineSpacing;
}

- (void)setOnlyShowTitle:(BOOL)onlyShowTitle {
    _onlyShowTitle = onlyShowTitle;
    
    _priceLabel.hidden = onlyShowTitle;
    _soldLabel.hidden = onlyShowTitle;
    _tagCV.hidden = onlyShowTitle;
    
    [self setNeedsLayout];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QBSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTagCellReusableIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor featuredColorWithIndex:indexPath.item];
    cell.layer.cornerRadius = self.tagFont.pointSize / 4;
    
    cell.textLabel.font = self.tagFont;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.item < self.tags.count) {
        NSString *tag = self.tags[indexPath.item];
        cell.textLabel.text = tag;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.tagWidths.count) {
        const CGFloat itemWidth = [self.tagWidths[indexPath.item] floatValue];
        return CGSizeMake(itemWidth, self.tagHeight);
    }
    return CGSizeZero;
}
@end
