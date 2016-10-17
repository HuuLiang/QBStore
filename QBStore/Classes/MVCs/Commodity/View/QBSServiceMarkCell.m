//
//  QBSServiceMarkCell.m
//  Pods
//
//  Created by Sean Yue on 16/7/9.
//
//

#import "QBSServiceMarkCell.h"

@interface QBSServiceMarkCell ()
{
    UIImageView *_thumbImageView;
    UILabel *_nameLabel;
}
@end

@implementation QBSServiceMarkCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        _thumbImageView.clipsToBounds = YES;
        [self addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.centerX.equalTo(self);
                make.width.equalTo(self).multipliedBy(0.35);
                make.height.equalTo(_thumbImageView.mas_width);
            }];
        }
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _nameLabel.font = kExtraSmallFont;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        {
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
            }];
        }
    }
    return self;
}

- (void)setName:(NSString *)name {
    _name = name;
    _nameLabel.text = name;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView sd_setImageWithURL:imageURL];
}
@end
