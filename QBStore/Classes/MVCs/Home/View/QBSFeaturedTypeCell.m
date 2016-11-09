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
        _titleLabel.font = kSmallFont;
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
    
    _titleLabel.frame = CGRectMake(5, 15, fullWidth-10, _subtitleLabel.font.pointSize);
    _subtitleLabel.frame = CGRectMake(_titleLabel.frame.origin.x,
                                      CGRectGetMaxY(_titleLabel.frame)+10,
                                      CGRectGetWidth(_titleLabel.frame),
                                      _subtitleLabel.font.pointSize);
    const CGFloat imageY = CGRectGetMaxY(_subtitleLabel.frame) + 10;
    const CGFloat imageHeight = fullHeight - imageY - 10;
    const CGFloat imageWidth = imageHeight;
    const CGFloat imageX = (fullWidth - imageWidth)/2;
    _thumbImageView.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
    
}
@end
