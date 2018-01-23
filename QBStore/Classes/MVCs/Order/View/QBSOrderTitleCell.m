//
//  QBSOrderTitleCell.m
//  Pods
//
//  Created by Sean Yue on 16/8/19.
//
//

#import "QBSOrderTitleCell.h"

@interface QBSOrderTitleCell ()
{
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
}
@end

@implementation QBSOrderTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLabel.font = kMediumFont;
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(kLeftRightContentMarginSpacing);
            }];
        }
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = _titleLabel.textColor;
        _subtitleLabel.font = kMediumFont;
        [self addSubview:_subtitleLabel];
        {
            [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-kLeftRightContentMarginSpacing);
                make.centerY.equalTo(self);
                make.left.equalTo(_titleLabel.mas_right).offset(kMediumHorizontalSpacing).priority(MASLayoutPriorityFittingSizeLevel);
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

- (void)setSubtitleColor:(UIColor *)subtitleColor {
    _subtitleColor = subtitleColor;
    
    if (subtitleColor) {
        _subtitleLabel.textColor = subtitleColor;
    } else {
        _subtitleLabel.textColor = _titleLabel.textColor;
    }
}
@end
