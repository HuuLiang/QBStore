//
//  QBSFeaturedTypeCell.m
//  Pods
//
//  Created by Sean Yue on 16/6/27.
//
//

#import "QBSFeaturedTypeCell.h"

@interface QBSFeaturedTypeCell ()
{
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
    UIImageView *_thumbImageView;
}
@end

@implementation QBSFeaturedTypeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kMediumFont;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = kExtraSmallFont;
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:_subtitleLabel];
        
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImageView.clipsToBounds = YES;
        [self addSubview:_thumbImageView];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    _subtitleLabel.text = subtitle;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView QB_setImageWithURL:imageURL];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    _titleLabel.textColor = titleColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat fullHeight = CGRectGetHeight(self.bounds);
    const CGFloat fullWidth = CGRectGetWidth(self.bounds);
    
    _titleLabel.frame = CGRectMake(5, fullHeight-15-_titleLabel.font.pointSize, fullWidth-10, _titleLabel.font.pointSize);
//    _subtitleLabel.frame = CGRectMake(_titleLabel.frame.origin.x,
//                                      CGRectGetMaxY(_titleLabel.frame)+10,
//                                      CGRectGetWidth(_titleLabel.frame),
//                                      _subtitleLabel.font.pointSize);
    
    const CGFloat remainHeight = _titleLabel.frame.origin.y;

    const CGFloat imageHeight = remainHeight * 0.6;
    const CGFloat imageWidth = imageHeight;
    const CGFloat imageY = (remainHeight-imageHeight)/2;
    const CGFloat imageX = (fullWidth - imageWidth)/2;
    _thumbImageView.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
    
}
@end
