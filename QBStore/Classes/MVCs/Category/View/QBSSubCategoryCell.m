//
//  QBSSubCategoryCell.m
//  Pods
//
//  Created by Sean Yue on 16/7/6.
//
//

#import "QBSSubCategoryCell.h"

@interface QBSSubCategoryCell ()
{
    UIImageView *_thumbImageView;
    UILabel *_titleLabel;
}
@end

@implementation QBSSubCategoryCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImageView.clipsToBounds = YES;
        [self addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self).multipliedBy(0.7);
                make.height.equalTo(_thumbImageView.mas_width);
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(10);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kSmallFont;
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_thumbImageView.mas_bottom).offset(5);
                make.left.right.equalTo(self);
            }];
        }
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    if (title.length > 6) {
        title = [title substringToIndex:6];
    }
    _title = title;
    _titleLabel.text = title;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView sd_setImageWithURL:imageURL];
}
@end
