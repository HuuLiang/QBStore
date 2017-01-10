//
//  QBSSnatchTreasureHeaderView.m
//  QBStore
//
//  Created by Sean Yue on 2016/12/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSSnatchTreasureHeaderView.h"

@interface QBSSnatchTreasureHeaderView ()
{
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
}
@end

@implementation QBSSnatchTreasureHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kMediumBoldFont;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#FF206F"];
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.centerY.equalTo(self);
            }];
        }
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        _subtitleLabel.font = kSmallFont;
        [self addSubview:_subtitleLabel];
        {
            [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-15);
                make.centerY.equalTo(self);
            }];
        }
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

@end
