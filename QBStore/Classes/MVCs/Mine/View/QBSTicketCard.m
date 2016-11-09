//
//  QBSTicketCard.m
//  QBStore
//
//  Created by Sean Yue on 2016/11/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSTicketCard.h"

@interface QBSTicketCard ()
@property (nonatomic,retain) UIImageView *backgroundImageView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *subtitleLabel;
@property (nonatomic,retain) UILabel *headerLabel;
@property (nonatomic,retain) UILabel *footerLabel;
@end

@implementation QBSTicketCard

- (instancetype)initWithFrontSide:(BOOL)isFrontSide {
    self = [super init];
    if (self) {
        _isFrontSide = isFrontSide;
    }
    return self;
}

- (UIImageView *)backgroundImageView {
    if (_backgroundImageView) {
        return _backgroundImageView;
    }
    
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_backgroundImageView];
    {
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _backgroundImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = _isFrontSide ? [UIFont boldSystemFontOfSize:40.]:[UIFont boldSystemFontOfSize:26.];
    _titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:_titleLabel];
    {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (_isFrontSide) {
                make.center.equalTo(self);
            } else {
                make.left.equalTo(self).offset(kLeftRightContentMarginSpacing);
                make.centerY.equalTo(self).multipliedBy(0.6);
                make.right.equalTo(self).multipliedBy(0.75);
            }
        }];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (_subtitleLabel) {
        return _subtitleLabel;
    }
    
    _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.font = [UIFont systemFontOfSize:16.];
    _subtitleLabel.textColor = [UIColor whiteColor];
    _subtitleLabel.numberOfLines = 5;
    [self addSubview:_subtitleLabel];
    {
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(kTopBottomContentMarginSpacing*2);
            make.bottom.lessThanOrEqualTo(self).offset(-kTopBottomContentMarginSpacing);
        }];
    }
    return _subtitleLabel;
}

- (UILabel *)headerLabel {
    if (_headerLabel) {
        return _headerLabel;
    }
    
    _headerLabel = [[UILabel alloc] init];
    _headerLabel.textColor = [UIColor whiteColor];
    _headerLabel.font = [UIFont boldSystemFontOfSize:18.];
    [self addSubview:_headerLabel];
    {
        [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(15);
        }];
    }
    return _headerLabel;
}

- (UILabel *)footerLabel {
    if (_footerLabel) {
        return _footerLabel;
    }
    
    _footerLabel = [[UILabel alloc] init];
    _footerLabel.textColor = [UIColor whiteColor];
    _footerLabel.font = [UIFont systemFontOfSize:16.];
    [self addSubview:_footerLabel];
    {
        [_footerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.bottom.equalTo(self).offset(-15);
        }];
    }
    return _footerLabel;
}

- (void)setBackgroundImageURL:(NSURL *)backgroundImageURL {
    _backgroundImageURL = backgroundImageURL;
    [self.backgroundImageView sd_setImageWithURL:backgroundImageURL];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    
    if (!_isFrontSide) {
        if (subtitle) {
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = 3;
            
            self.subtitleLabel.attributedText = [[NSAttributedString alloc] initWithString:subtitle attributes:@{NSParagraphStyleAttributeName:style}];
        } else {
            self.subtitleLabel.attributedText = nil;
        }
        
    }
}

- (void)setHeader:(NSString *)header {
    _header = header;
    
    if (_isFrontSide) {
        self.headerLabel.text = header;
    }
}

- (void)setFooter:(NSString *)footer {
    _footer = footer;
    
    if (_isFrontSide) {
        self.footerLabel.text = footer;
    }
}

+ (instancetype)frontSidedCard {
    QBSTicketCard *card = [[self alloc] initWithFrontSide:YES];
    return card;
}

+ (instancetype)backSidedCard {
    QBSTicketCard *card = [[self alloc] initWithFrontSide:NO];
    return card;
}
@end
