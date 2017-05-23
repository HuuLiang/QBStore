//
//  QBSCategoryCell.m
//  QBStore
//
//  Created by Sean Yue on 2016/10/28.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSCategoryCell.h"

@interface QBSCategoryCell ()
{
    UIImageView *_thumbImageView;
//    UIView *_maskView;
    UILabel *_titleLabel;
}
@end

@implementation QBSCategoryCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        
//        _maskView = [[UIView alloc] init];
<<<<<<< HEAD
//        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//        [_thumbImageView addSubview:_maskView];
//        {
//            [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(_thumbImageView);
//            }];
//        }
//        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = kHugeBoldFont;
        _titleLabel.numberOfLines = 2;
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self).offset(-kTopBottomContentMarginSpacing);
=======
//        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//        [_thumbImageView addSubview:_maskView];
//        {
//            [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.equalTo(_thumbImageView);
//                make.height.mas_equalTo(44);
//            }];
//        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = kExtraBigFont;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.height.mas_equalTo(50);
>>>>>>> Final
            }];
        }
    }
    return self;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView QB_setImageWithURL:imageURL];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}
@end
