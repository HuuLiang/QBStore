//
//  QBSActivityListCell.m
//  Pods
//
//  Created by Sean Yue on 16/7/19.
//
//

#import "QBSActivityListCell.h"
#import "QBSProgressView.h"

@interface QBSActivityListCell ()
{
    UIImageView *_thumbImageView;
    UIImageView *_tagImageView;
    
    UILabel *_titleLabel;
    UILabel *_currentPriceLabel;
    UILabel *_originalPriceLabel;
    
    UIButton *_buyButton;
    
    UILabel *_soldLabel;
    QBSProgressView *_progressView;
}
@end

@implementation QBSActivityListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_thumbImageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = kMediumFont;
        _titleLabel.numberOfLines = 2;
        [self addSubview:_titleLabel];

        _buyButton = [[UIButton alloc] init];
        _buyButton.backgroundColor = [UIColor colorWithHexString:@"#FD472B"];
        _buyButton.titleLabel.font = kSmallFont;
        _buyButton.forceRoundCorner = YES;
        [_buyButton setTitle:@"马上抢购" forState:UIControlStateNormal];
        [self addSubview:_buyButton];

        _currentPriceLabel = [[UILabel alloc] init];
        _currentPriceLabel.textColor = [UIColor colorWithHexString:@"#FD472B"];
        _currentPriceLabel.font = kMediumFont;
        [self addSubview:_currentPriceLabel];

        _originalPriceLabel = [[UILabel alloc] init];
        _originalPriceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _originalPriceLabel.font = kExtraSmallFont;
        [self addSubview:_originalPriceLabel];

        _soldLabel = [[UILabel alloc] init];
        _soldLabel.text = @"已售：";
        _soldLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _soldLabel.font = kExtraSmallFont;
        [self addSubview:_soldLabel];

        _progressView = [[QBSProgressView alloc] init];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"#ff2b6f"];
        _progressView.trackTintColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [self addSubview:_progressView];

        AssociatedButtonWithAction(_buyButton, buyAction);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat fullWidth = self.bounds.size.width;
    const CGFloat fullHeight = self.bounds.size.height;
    
    const CGFloat thumbHeight = fullHeight * 0.8;
    const CGFloat thumbWidth = thumbHeight;
    const CGFloat thumbY = (fullHeight - thumbHeight)/2;
    const CGFloat thumbX = kLeftRightContentMarginSpacing;
    _thumbImageView.frame = CGRectMake(thumbX, thumbY, thumbWidth, thumbHeight);
    
    if (_tagImageView) {
        const CGFloat tagWidth = thumbWidth * 0.25;
        const CGFloat tagHeight = tagWidth;
        const CGFloat tagX = thumbWidth - tagWidth;
        _tagImageView.frame = CGRectMake(tagX, 0, tagWidth, tagHeight);
    }
    
    const CGFloat titleX = CGRectGetMaxX(_thumbImageView.frame) + kBigHorizontalSpacing;
    const CGFloat titleY = thumbY;
    const CGFloat titleWidth = fullWidth - kLeftRightContentMarginSpacing - titleX;
    const CGFloat titleHeight = _titleLabel.font.pointSize * _titleLabel.numberOfLines + kBigVerticalSpacing;
    _titleLabel.frame = CGRectMake(titleX, titleY, titleWidth, titleHeight);
    
    const CGFloat buyWidth = 80;
    const CGFloat buyHeight = 28;
    const CGFloat buyX = CGRectGetMaxX(_titleLabel.frame)-buyWidth;
    const CGFloat buyY = CGRectGetMaxY(_titleLabel.frame) + kMediumVerticalSpacing;
    _buyButton.frame = CGRectMake(buyX, buyY, buyWidth, buyHeight);

    const CGFloat currentPriceX = titleX;
    const CGFloat currentPriceY = CGRectGetMaxY(_titleLabel.frame)+kMediumVerticalSpacing;
    const CGFloat currentPriceWidth = titleWidth - buyWidth - kSmallHorizontalSpacing;
    const CGFloat currentPriceHeight = _currentPriceLabel.font.pointSize;
    _currentPriceLabel.frame = CGRectMake(currentPriceX, currentPriceY, currentPriceWidth, currentPriceHeight);
    
    const CGFloat originalPriceX = currentPriceX;
    const CGFloat originalPriceY = CGRectGetMaxY(_currentPriceLabel.frame) + kMediumVerticalSpacing;
    const CGFloat originalPriceWidth = currentPriceWidth;
    const CGFloat originalPriceHeight = _originalPriceLabel.font.pointSize;
    _originalPriceLabel.frame = CGRectMake(originalPriceX, originalPriceY, originalPriceWidth, originalPriceHeight);
    
    const CGSize soldSize = [_soldLabel.text sizeWithAttributes:@{NSFontAttributeName:_soldLabel.font}];
    const CGFloat soldX = titleX;
    const CGFloat soldY = CGRectGetMaxY(_originalPriceLabel.frame) + kMediumVerticalSpacing;
    _soldLabel.frame = CGRectMake(soldX, soldY, soldSize.width, soldSize.height);
    
    const CGFloat progressWidth = titleWidth * 0.6;
    const CGFloat progressHeight = 10;
    const CGFloat progressX = CGRectGetMaxX(_soldLabel.frame)+2;
    const CGFloat progressY = soldY + (soldSize.height - progressHeight)/2;
    _progressView.frame = CGRectMake(progressX, progressY, progressWidth, progressHeight);
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView QB_setImageWithURL:imageURL];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setSoldPercent:(NSUInteger)soldPercent {
    _soldPercent = soldPercent;
    _progressView.progress = soldPercent;
}

- (void)setCurrentPrice:(CGFloat)currentPrice {
    _currentPrice = currentPrice;
    _currentPriceLabel.text = [NSString stringWithFormat:@"¥ %@", QBSIntegralPrice(currentPrice)];
}

- (void)setOriginalPrice:(CGFloat)originalPrice {
    _originalPrice = originalPrice;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价：¥%@", QBSIntegralPrice(originalPrice)]];
    [attrString addAttribute:NSStrikethroughStyleAttributeName value:@1 range:NSMakeRange(3, attrString.length-3)];
    _originalPriceLabel.attributedText = attrString;
}

- (void)setTagURL:(NSURL *)tagURL {
    _tagURL = tagURL;
    
    if (tagURL && !_tagImageView) {
        _tagImageView = [[UIImageView alloc] init];
        _tagImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_thumbImageView addSubview:_tagImageView];
    }
    
    [_tagImageView sd_setImageWithURL:tagURL];
    _tagImageView.hidden = tagURL == nil;
}
@end
