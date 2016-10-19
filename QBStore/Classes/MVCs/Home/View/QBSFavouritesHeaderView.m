//
//  QBSFavouritesHeaderView.m
//  Pods
//
//  Created by Sean Yue on 16/7/5.
//
//

#import "QBSFavouritesHeaderView.h"

@interface QBSFavouritesHeaderView ()
{
    
}
@end

@implementation QBSFavouritesHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *heartImageView = [[UIImageView alloc] initWithImage:[UIImage QBS_imageWithResourcePath:@"heart"]];
        [self addSubview:heartImageView];
        {
            [heartImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.centerX.equalTo(self).multipliedBy(0.75);
            }];
        }
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor colorWithHexString:@"#FF206F"];
        titleLabel.font = kBigFont;
        titleLabel.text = @"猜你喜欢";
        [self addSubview:titleLabel];
        {
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(heartImageView.mas_right).offset(15);
            }];
        }
        
        UIImageView *separatorLeft = [[UIImageView alloc] initWithImage:[UIImage QBS_imageWithResourcePath:@"fav_separator"]];
        separatorLeft.transform = CGAffineTransformMakeRotation(M_PI);
        [self addSubview:separatorLeft];
        {
            [separatorLeft mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(heartImageView.mas_left).offset(-30);
            }];
        }
        
        UIImageView *separatorRight = [[UIImageView alloc] initWithImage:[UIImage QBS_imageWithResourcePath:@"fav_separator"]];
        [self addSubview:separatorRight];
        {
            [separatorRight mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(titleLabel.mas_right).offset(15);
            }];
        }
    }
    return self;
}

@end
