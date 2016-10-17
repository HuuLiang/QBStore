//
//  QBSCommodityCommentCell.m
//  Pods
//
//  Created by Sean Yue on 16/7/18.
//
//

#import "QBSCommodityCommentCell.h"

@interface QBSCommodityCommentCell ()
{
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
    UILabel *_contentLabel;
}
@end

@implementation QBSCommodityCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        const UIEdgeInsets contentInsets = [[self class] contentInsets];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLabel.font = kSmallFont;
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(contentInsets.left);
                make.top.equalTo(self).offset(contentInsets.top);
            }];
        }
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _subtitleLabel.font = kExtraSmallFont;
        [self addSubview:_subtitleLabel];
        {
            [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-contentInsets.right);
                make.centerY.equalTo(_titleLabel);
                make.left.equalTo(_titleLabel.mas_right).offset(5).priority(MASLayoutPriorityFittingSizeLevel);
            }];
        }
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _contentLabel.font = kSmallFont;
        _contentLabel.numberOfLines = 5;
        [self addSubview:_contentLabel];
        {
            [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_titleLabel);
                make.right.equalTo(_subtitleLabel);
                make.top.equalTo(_titleLabel.mas_bottom).offset(2);
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

- (void)setContent:(NSString *)content {
    _content = content;
    _contentLabel.text = content;
}

+ (UIEdgeInsets)contentInsets {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
@end
