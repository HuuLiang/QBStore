//
//  QBSSortButton.m
//  Pods
//
//  Created by Sean Yue on 16/7/12.
//
//

#import "QBSSortButton.h"

#define kNormalSortIconColor [UIColor colorWithHexString:@"#999999"]
#define kSelectedSortIconColor [UIColor colorWithHexString:@"#FF206F"]

@interface QBSSortButton ()
{
    UIImageView *_upperImageView;
    UIImageView *_lowerImageView;
}
@end

@implementation QBSSortButton

+ (instancetype)buttonWithTitle:(NSString *)title hasSortMode:(BOOL)hasSortMode delegate:(id<QBSSortButtonDelegate>)delegate {
    QBSSortButton *button = [[self alloc] initWithTitle:title hasSortMode:hasSortMode delegate:delegate];
    return button;
}

- (instancetype)initWithTitle:(NSString *)title hasSortMode:(BOOL)hasSortMode delegate:(id<QBSSortButtonDelegate>)delegate {
    self = [super init];
    if (self) {
        _hasSortMode = hasSortMode;
        _delegate = delegate;
        
        self.titleLabel.font = kMediumFont;
        [self setTitleColor:[UIColor colorWithHexString:@"#FF206F"] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
        
        if (hasSortMode) {
            _upperImageView = [[UIImageView alloc] initWithImage:[[UIImage QBS_imageWithResourcePath:@"triangle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            _upperImageView.tintColor = kNormalSortIconColor;
            _upperImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:_upperImageView];
            {
                [_upperImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.titleLabel.mas_right).offset(5);
                    make.bottom.equalTo(self.titleLabel.mas_centerY).offset(-1);
                    make.size.mas_equalTo(CGSizeMake(5, 5));
                }];
            }
            
            _lowerImageView = [[UIImageView alloc] initWithImage:[[UIImage QBS_imageWithResourcePath:@"triangle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            _lowerImageView.tintColor = kNormalSortIconColor;
            _lowerImageView.contentMode = UIViewContentModeScaleAspectFit;
            _lowerImageView.transform = CGAffineTransformMakeRotation(M_PI);
            [self addSubview:_lowerImageView];
            {
                [_lowerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.left.equalTo(_upperImageView);
                    make.top.equalTo(self.titleLabel.mas_centerY).offset(1);
                }];
            }
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (self.hasSortMode) {
        if (selected) {
            if (self.sortMode == QBSSortModeUnknown) {
                self.sortMode = QBSSortModeDescending;
            }
        } else {
            self.sortMode = QBSSortModeUnknown;
        }
    } else {
        self.sortMode = selected ? QBSSortModeNone : QBSSortModeUnknown;
    }
    
    
}

- (void)setSortMode:(QBSSortMode)sortMode {
    if (_sortMode == sortMode) {
        return ;
    }
    
    _sortMode = sortMode;
    _upperImageView.tintColor = sortMode == QBSSortModeAscending ? kSelectedSortIconColor : kNormalSortIconColor;
    _lowerImageView.tintColor = sortMode == QBSSortModeDescending ? kSelectedSortIconColor : kNormalSortIconColor;
    
    if (sortMode != QBSSortModeUnknown) {
        if ([self.delegate respondsToSelector:@selector(sortButton:didChangeSortMode:)]) {
            [self.delegate sortButton:self didChangeSortMode:sortMode];
        }
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGSize titleSize = [[self titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName:kMediumFont}];
    const CGFloat titleX = (CGRectGetWidth(contentRect) - titleSize.width)/2-(self.hasSortMode?10:0);
    const CGFloat titleY = (CGRectGetHeight(contentRect) - titleSize.height)/2;
    return CGRectMake(titleX, titleY, titleSize.width, titleSize.height);
}
@end
