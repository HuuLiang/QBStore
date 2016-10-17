//
//  QBSFeaturedCommodityHeaderView.m
//  Pods
//
//  Created by Sean Yue on 16/7/5.
//
//

#import "QBSFeaturedCommodityHeaderView.h"

@interface QBSFeaturedCommodityHeaderView ()
{
    UIImageView *_thumbImageView;
}
@end

@implementation QBSFeaturedCommodityHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImageView.clipsToBounds = YES;
        [self addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        
        UIImageView *triangleImageView = [[UIImageView alloc] initWithImage:[UIImage QBS_imageWithResourcePath:@"Common/triangle"]];
        [self addSubview:triangleImageView];
        {
            [triangleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self);
                make.left.equalTo(self).offset(20);
            }];
        }
    }
    return self;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView sd_setImageWithURL:imageURL];
}
@end
