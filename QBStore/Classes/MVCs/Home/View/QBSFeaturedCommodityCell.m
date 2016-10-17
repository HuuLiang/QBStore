//
//  QBSFeaturedCommodityCell.m
//  Pods
//
//  Created by Sean Yue on 16/7/5.
//
//

#import "QBSFeaturedCommodityCell.h"

@interface QBSFeaturedCommodityCell ()
{
    UIImageView *_thumbImageView;
    UILabel *_titleLabel;
    UILabel *_priceLabel;
}
@end

@implementation QBSFeaturedCommodityCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_priceLabel];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kSmallFont;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.numberOfLines = 2;
        //_titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImageView.clipsToBounds = YES;
        [self addSubview:_thumbImageView];
    }
    return self;
}

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice {
    NSString *priceString = [NSString stringWithFormat:@"¥ %@", QBSIntegralPrice(price)];
    NSString *str = priceString;
    if (originalPrice > 0) {
        NSString *originalPriceString = QBSIntegralPrice(originalPrice);
        str = [str stringByAppendingFormat:@" %@", originalPriceString];
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];

    [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FD472B"],
                                NSFontAttributeName:kMediumFont} range:NSMakeRange(0, priceString.length)];
    
    if (originalPrice > 0) {
        [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],
                                    NSFontAttributeName:kSmallFont,
                                    NSStrikethroughStyleAttributeName:@1} range:NSMakeRange(priceString.length+1, attrString.length-priceString.length-1)];
    }
    
    _priceLabel.attributedText = attrString;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView sd_setImageWithURL:imageURL];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat fullWidth = CGRectGetWidth(self.bounds);
    const CGFloat fullHeight = CGRectGetHeight(self.bounds);
    
    const CGFloat priceHeight = 16;
    _priceLabel.frame = CGRectMake(5, fullHeight-priceHeight-10, fullWidth-10, priceHeight);
    
    const CGFloat titleHeight = 40;
    _titleLabel.frame = CGRectMake(_priceLabel.frame.origin.x, CGRectGetMinY(_priceLabel.frame)-5-titleHeight,
                                   CGRectGetWidth(_priceLabel.frame), titleHeight);
    
    const CGFloat imageY = 10;
    const CGFloat imageHeight = _titleLabel.frame.origin.y - imageY * 2;
    const CGFloat imageWidth = imageHeight;
    const CGFloat imageX = (fullWidth - imageWidth) / 2;
    _thumbImageView.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
}
@end
