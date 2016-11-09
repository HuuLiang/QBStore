//
//  QBSHomeActivityCell.m
//  Pods
//
//  Created by Sean Yue on 16/6/27.
//
//

#import "QBSHomeActivityCell.h"

@interface QBSHomeActivityCell ()
{
    UIImageView *_thumbImageView;
    UILabel *_priceLabel;
    UILabel *_originalPriceLabel;
    UIImageView *_tagImageView;
}
@end

@implementation QBSHomeActivityCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _originalPriceLabel = [[UILabel alloc] init];
        _originalPriceLabel.textAlignment = NSTextAlignmentCenter;
        _originalPriceLabel.font = kExtraSmallFont;
        _originalPriceLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        [self addSubview:_originalPriceLabel];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.textColor = [UIColor colorWithHexString:@"#FD472B"];
        _priceLabel.font = kSmallFont;
        [self addSubview:_priceLabel];

        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImageView.clipsToBounds = YES;
        [self addSubview:_thumbImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat fullWidth = CGRectGetWidth(self.bounds);
    const CGFloat fullHeight = CGRectGetHeight(self.bounds);
    
    _originalPriceLabel.frame = CGRectMake(5, fullHeight-10-_originalPriceLabel.font.pointSize, fullWidth-10, _originalPriceLabel.font.pointSize);
    
    const CGFloat priceHeight = _priceLabel.font.pointSize;
    const CGFloat priceY = _originalPriceLabel.frame.origin.y - 5 - priceHeight;
    _priceLabel.frame = CGRectMake(_originalPriceLabel.frame.origin.x, priceY,
                                   _originalPriceLabel.frame.size.width, priceHeight);
    
    const CGFloat imageY = 10;
    const CGFloat imageHeight = _priceLabel.frame.origin.y - imageY * 2;
    const CGFloat imageWidth = imageHeight;
    const CGFloat imageX = (fullWidth - imageWidth) / 2;
    _thumbImageView.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView QB_setImageWithURL:imageURL];
}

- (void)setPrice:(CGFloat)price {
    _price = price;
    _priceLabel.text = [NSString stringWithFormat:@"¥ %@", QBSIntegralPrice(price)];
}

- (void)setOriginalPrice:(CGFloat)originalPrice {
    _originalPrice = originalPrice;
    _originalPriceLabel.attributedText = [[NSAttributedString alloc] initWithString:QBSIntegralPrice(originalPrice)
                                                                         attributes:@{NSStrikethroughStyleAttributeName:@1}];
}

- (void)setTagURL:(NSURL *)tagURL {
    _tagURL = tagURL;
    
    if (_tagURL && !_tagImageView) {
        _tagImageView = [[UIImageView alloc] init];
        _tagImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_tagImageView];
        {
            [_tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.equalTo(self);
                make.width.equalTo(self).multipliedBy(0.25);
                make.height.equalTo(_tagImageView.mas_width);
            }];
        }
    }
    
    [_tagImageView sd_setImageWithURL:tagURL];
    _tagImageView.hidden = tagURL == nil;
}
@end
