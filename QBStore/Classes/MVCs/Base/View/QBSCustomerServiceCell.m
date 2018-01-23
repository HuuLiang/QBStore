//
//  QBSCustomerServiceCell.m
//  Pods
//
//  Created by Sean Yue on 16/7/19.
//
//

#import "QBSCustomerServiceCell.h"

@interface QBSCustomerServiceCell ()
{
    UIImageView *_thumbImageView;
    UILabel *_titleLabel;
}
@end

@implementation QBSCustomerServiceCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kSmallFont;
        [self addSubview:_titleLabel];

        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_thumbImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat fullWidth = CGRectGetWidth(self.bounds);
    const CGFloat fullHeight = CGRectGetHeight(self.bounds);
    
    const CGFloat imageWidth = fullWidth * 0.5;
    const CGFloat imageHeight = imageWidth;
    const CGFloat imageX = (fullWidth-imageWidth)/2;
    const CGFloat imageY = fullHeight * 0.1;
    _thumbImageView.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
    
    const CGFloat titleX = 10;
    const CGFloat titleWidth = fullWidth - titleX * 2;
    const CGFloat titleY = CGRectGetMaxY(_thumbImageView.frame) + fullHeight * 0.1;
    _titleLabel.frame = CGRectMake(titleX, titleY, titleWidth, _titleLabel.font.pointSize);
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView sd_setImageWithURL:imageURL];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}
@end
