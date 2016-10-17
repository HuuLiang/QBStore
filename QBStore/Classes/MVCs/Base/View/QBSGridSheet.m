//
//  QBSGridSheet.m
//  Pods
//
//  Created by Sean Yue on 16/8/22.
//
//

#import "QBSGridSheet.h"

static NSString *const kSheetItemCellReusableIdentifier = @"SheetItemCellReusableIdentifier";

@interface QBSGridSheetItemCell : UICollectionViewCell
{
    UILabel *_titleLabel;
    UIImageView *_iconImageView;
}
@property (nonatomic,retain) QBSGridSheetItem *item;
@end

@implementation QBSGridSheetItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLabel.font = kSmallFont;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.layer.borderWidth = 1;
        [self addSubview:_titleLabel];
        
        _iconImageView = [[UIImageView alloc] init];
//        _iconImageView.layer.borderWidth = 1;
        [self addSubview:_iconImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat fullWidth = CGRectGetWidth(self.bounds);
    const CGFloat fullHeight = CGRectGetHeight(self.bounds);
    
    const CGFloat footerHeight = [[self class] footerHeight];
    _titleLabel.frame = CGRectMake(0, fullHeight-footerHeight, fullWidth, _titleLabel.font.pointSize);
    
    const CGFloat imageHeight = (fullHeight - footerHeight) * 0.6;
    const CGFloat imageWidth = imageHeight;
    const CGFloat imageX = (fullWidth - imageWidth)/2;
    const CGFloat imageY = (fullHeight - imageHeight - footerHeight) / 2;
    _iconImageView.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

- (void)setItem:(QBSGridSheetItem *)item {
    _item = item;
    
    _titleLabel.text = item.title;
    _iconImageView.image = item.iconImage;
}

+ (CGFloat)footerHeight {
    return 30;
}
@end

@interface QBSGridSheet () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    UICollectionView *_sheetCV;
}
@property (nonatomic,readonly) CGFloat rowHeight;
@end

@implementation QBSGridSheet

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = layout.minimumInteritemSpacing;
        
        _sheetCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _sheetCV.backgroundColor = [UIColor whiteColor];
        _sheetCV.delegate = self;
        _sheetCV.dataSource = self;
        _sheetCV.scrollEnabled = NO;
        [_sheetCV registerClass:[QBSGridSheetItemCell class] forCellWithReuseIdentifier:kSheetItemCellReusableIdentifier];
        [self addSubview:_sheetCV];
        
//        @weakify(self);
//        [self bk_whenTapped:^{
//            @strongify(self);
//            [self dismiss];
//        }];
        
    }
    return self;
}

- (void)setItems:(NSArray<QBSGridSheetItem *> *)items {
    _items = items;
    
    [_sheetCV reloadData];
}

- (void)showInWindow {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if ([keyWindow.subviews bk_any:^BOOL(id obj) {
        return [obj isKindOfClass:[self class]];
    }])
    {
        return ;
    }
    
    self.frame = keyWindow.bounds;
    self.alpha = 0;
    [keyWindow addSubview:self];
    
    const NSUInteger numberOfRows = (_items.count + 2) / 3;
    _sheetCV.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, numberOfRows * self.rowHeight);
    
    [UIView animateWithDuration:0.25 animations:^{
        _sheetCV.frame = CGRectOffset(_sheetCV.frame, 0, -CGRectGetHeight(_sheetCV.frame));
        self.alpha = 1;
    }];
    
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        _sheetCV.frame = CGRectOffset(_sheetCV.frame, 0, CGRectGetHeight(_sheetCV.frame));
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (CGFloat)rowHeight {
    return self.bounds.size.height * 0.12;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

#pragma mark - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QBSGridSheetItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSheetItemCellReusableIdentifier forIndexPath:indexPath];
    
    if (indexPath.item < self.items.count) {
        QBSGridSheetItem *item = self.items[indexPath.item];
        cell.item = item;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    const CGFloat interItemSpacing = [(UICollectionViewFlowLayout *)collectionViewLayout minimumInteritemSpacing];
    const CGFloat itemWidth = (CGRectGetWidth(collectionView.bounds) - 2 * interItemSpacing)/3;
    return CGSizeMake(itemWidth, self.rowHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self dismiss];
    
    if (indexPath.item < self.items.count) {
        QBSGridSheetItem *item = self.items[indexPath.item];
        SafelyCallBlock(item.action, self);
    }
}
@end

@implementation QBSGridSheetItem

+ (instancetype)itemWithTitle:(NSString *)title iconImage:(UIImage *)iconImage action:(QBSAction)action {
    QBSGridSheetItem *item = [[self alloc] init];
    item.title = title;
    item.iconImage = iconImage;
    item.action = action;
    return item;
}
@end
