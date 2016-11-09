//
//  QBSTicketAppCell.m
//  QBStore
//
//  Created by Sean Yue on 2016/11/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSTicketAppCell.h"

@interface QBSTicketAppCell ()
{
    UIImageView *_thumbImageView;
    UILabel *_titleLabel;
    UILabel *_detailLabel;
    UILabel *_downloadLabel;
}
@end

@implementation QBSTicketAppCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImageView.clipsToBounds = YES;
        _thumbImageView.layer.cornerRadius = 15;
        [self addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(10);
                make.top.equalTo(self).offset(10);
                make.bottom.equalTo(self).offset(-10);
                make.width.equalTo(_thumbImageView.mas_height);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kBigBoldFont;
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_thumbImageView.mas_right).offset(kLeftRightContentMarginSpacing);
                make.top.equalTo(_thumbImageView);
                make.right.equalTo(self).offset(-kLeftRightContentMarginSpacing);
            }];
        }
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = kMediumFont;
        _detailLabel.numberOfLines = 5;
        [self addSubview:_detailLabel];
        {
            [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_titleLabel);
                make.right.equalTo(self).offset(-kLeftRightContentMarginSpacing);
                make.top.equalTo(_titleLabel.mas_bottom).offset(kMediumVerticalSpacing);
                make.bottom.lessThanOrEqualTo(self);
            }];
        }
        
        _downloadLabel = [[UILabel alloc] init];
        _downloadLabel.textColor = [UIColor whiteColor];
        _downloadLabel.font = kSmallFont;
        _downloadLabel.text = @"点击下载";
        _downloadLabel.backgroundColor = [UIColor colorWithHexString:@"#D0021B"];
        _downloadLabel.textAlignment = NSTextAlignmentCenter;
        _downloadLabel.layer.cornerRadius = 4;
        _downloadLabel.layer.masksToBounds = YES;
        [self addSubview:_downloadLabel];
        {
            const CGSize textSize = [_downloadLabel.text sizeWithAttributes:@{NSFontAttributeName:_downloadLabel.font}];
            [_downloadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-kLeftRightContentMarginSpacing);
                make.centerY.equalTo(_titleLabel);
                make.size.mas_equalTo(CGSizeMake(textSize.width+10, textSize.height+5));
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

- (void)setDetail:(NSString *)detail {
    _detail = detail;
    _detailLabel.text = detail;
}

@end
