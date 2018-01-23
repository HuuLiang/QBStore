//
//  QBSOrderManifestCell.m
//  Pods
//
//  Created by Sean Yue on 16/8/3.
//
//

#import "QBSOrderManifestCell.h"

@interface QBSOrderManifestCell ()
{
    UIImageView *_thumbImageView;
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UILabel *_amountLabel;
}
@end

@implementation QBSOrderManifestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self).offset(kLeftRightContentMarginSpacing);
                make.height.equalTo(self.contentView).multipliedBy(0.75);
                make.width.mas_equalTo(_thumbImageView.mas_height);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = kMediumFont;
        _titleLabel.numberOfLines = 2;
        [self.contentView addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_thumbImageView);
                make.left.equalTo(_thumbImageView.mas_right).offset(kLeftRightContentMarginSpacing);
                make.right.equalTo(self).offset(-kLeftRightContentMarginSpacing);
                make.height.mas_equalTo(_titleLabel.font.pointSize * _titleLabel.numberOfLines + kBigVerticalSpacing);
            }];
        }
        
        _priceLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_priceLabel];
        {
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_titleLabel);
                make.top.equalTo(_titleLabel.mas_bottom).offset(kMediumVerticalSpacing);
            }];
        }
        
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _amountLabel.font = kSmallFont;
        [self.contentView addSubview:_amountLabel];
        {
            [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_priceLabel);
                make.right.equalTo(_titleLabel);
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

- (void)setAmount:(NSUInteger)amount {
    _amount = amount;
    _amountLabel.text = [NSString stringWithFormat:@"x%ld", (unsigned long)amount];
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

@end
