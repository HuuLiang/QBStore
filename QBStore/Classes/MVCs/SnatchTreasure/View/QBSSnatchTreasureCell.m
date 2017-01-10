//
//  QBSSnatchTreasureCell.m
//  QBStore
//
//  Created by Sean Yue on 2016/12/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSSnatchTreasureCell.h"

@interface QBSSnatchTreasureCell ()
{
    UIImageView *_thumbImageView;
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UILabel *_popLabel;
    
    UIButton *_actionButton;
}
@end

@implementation QBSSnatchTreasureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_thumbImageView];
//        {
//            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.top.equalTo(self).offset(kLeftRightContentMarginSpacing);
//                make.bottom.equalTo(self).offset(-kLeftRightContentMarginSpacing);
//                make.width.equalTo(_thumbImageView.mas_height);
//            }];
//        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _titleLabel.font = kMediumFont;
        _titleLabel.numberOfLines = 2;
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_thumbImageView.mas_right).offset(kLeftRightContentMarginSpacing);
                make.right.equalTo(self).offset(-kLeftRightContentMarginSpacing);
                make.top.equalTo(_thumbImageView);
            }];
        }
        
        _priceLabel = [[UILabel alloc] init];
        [self addSubview:_priceLabel];
        {
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_titleLabel);
                make.top.equalTo(_titleLabel.mas_bottom).offset(kMediumVerticalSpacing);
            }];
        }
        
        _popLabel = [[UILabel alloc] init];
        _popLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        _popLabel.font = kSmallFont;
        [self addSubview:_popLabel];
        {
            [_popLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_titleLabel);
                make.top.equalTo(_priceLabel.mas_bottom).offset(kMediumVerticalSpacing);
            }];
        }
        
        _buttonEnabled = YES;
        
        _actionButton = [[UIButton alloc] init];
//        [_actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FF206F"]] forState:UIControlStateNormal];
//        [_actionButton setTitle:@"立即申请" forState:UIControlStateNormal];
        _actionButton.titleLabel.font = kMediumFont;
        _actionButton.layer.cornerRadius = 5;
        _actionButton.clipsToBounds = YES;
        _actionButton.userInteractionEnabled = NO;
        [self addSubview:_actionButton];
        {
            [_actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_thumbImageView);
                make.left.equalTo(_titleLabel);
                make.right.equalTo(_titleLabel).offset(-kLeftRightContentMarginSpacing);
                make.height.mas_equalTo(34);
            }];
        }
        
//        AssociatedButtonWithAction(_actionButton, buttonAction);
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat fullHeight = CGRectGetHeight(self.bounds);
    
    const CGFloat imageX = fullHeight * 0.075;
    const CGFloat imageY = imageX;
    const CGFloat imageHeight = fullHeight - imageY * 2;
    _thumbImageView.frame = CGRectMake(imageX, imageY, imageHeight, imageHeight);
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView QB_setImageWithURL:imageURL];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice {
    NSString *priceString = [NSString stringWithFormat:@"¥%@", QBSIntegralPrice(price)];
    
    NSString *str = priceString;
    if (originalPrice > 0) {
        NSString *originalPriceString = QBSIntegralPrice(originalPrice);
        str = [str stringByAppendingFormat:@" %@",originalPriceString];
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FD472B"],
                                NSFontAttributeName:kMediumFont} range:NSMakeRange(0, priceString.length)];
    
    if (originalPrice > 0) {
        [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],
                                    NSFontAttributeName:kSmallFont,
                                    NSStrikethroughStyleAttributeName:@1} range:NSMakeRange(priceString.length+1, attrString.length-priceString.length-1)];
    }
    
    _priceLabel.attributedText = attrString;
}

- (void)setPopularity:(NSUInteger)popularity {
    _popularity = popularity;
    _popLabel.text = [NSString stringWithFormat:@"%ld人参与", (unsigned long)popularity];
}

- (void)setButtonBackgroundColor:(UIColor *)buttonBackgroundColor {
    _buttonBackgroundColor = buttonBackgroundColor;
    [_actionButton setBackgroundImage:[UIImage imageWithColor:buttonBackgroundColor] forState:UIControlStateNormal];
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    _buttonTitle = buttonTitle;
    [_actionButton setTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)setButtonEnabled:(BOOL)buttonEnabled {
    _buttonEnabled = buttonEnabled;
    _actionButton.enabled = buttonEnabled;
}
@end
