//
//  QBSCommodityCell.m
//  Pods
//
//  Created by Sean Yue on 16/7/5.
//
//

#import "QBSCommodityCell.h"

@interface QBSCommodityCell ()
{
    UIImageView *_thumbImageView;
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UILabel *_soldLabel;
}
@end

@implementation QBSCommodityCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImageView.clipsToBounds = YES;
        [self addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.left.equalTo(self).offset(10);
                make.right.equalTo(self).offset(-10);
                make.top.equalTo(self).offset(10);
                make.height.equalTo(_thumbImageView.mas_width);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = kMediumFont;
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_thumbImageView);
                make.top.equalTo(_thumbImageView.mas_bottom).offset(5);
                make.height.mas_equalTo(40);
            }];
        }
        
        _priceLabel = [[UILabel alloc] init];
        [self addSubview:_priceLabel];
        {
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_thumbImageView);
                make.top.equalTo(_titleLabel.mas_bottom).offset(5);
                make.height.mas_equalTo(18);
            }];
        }
        
        _soldLabel = [[UILabel alloc] init];
        _soldLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _soldLabel.font = kExtraSmallFont;
        [self addSubview:_soldLabel];
        {
            [_soldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_thumbImageView);
                make.top.equalTo(_priceLabel.mas_bottom).offset(kScreenHeight * 0.005);
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

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice {
    NSString *priceString = [NSString stringWithFormat:@"¥%@", QBSIntegralPrice(price)];
    
    NSString *str = priceString;
    if (originalPrice > 0) {
        NSString *originalPriceString = QBSIntegralPrice(originalPrice);
        str = [str stringByAppendingFormat:@" %@", originalPriceString];
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

- (void)setSold:(NSUInteger)sold {
    _sold = sold;
    _soldLabel.text = [NSString stringWithFormat:@"已售：%ld件", (unsigned long)sold];
}

+ (CGFloat)cellAspects {
    return 0.66;
}
@end
