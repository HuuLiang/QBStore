//
//  QBSOrderListPriceCell.m
//  Pods
//
//  Created by Sean Yue on 16/8/3.
//
//

#import "QBSOrderListPriceCell.h"

@interface QBSOrderListPriceCell ()
{
    UILabel *_priceLabel;
}
@property (nonatomic,retain) UIButton *paymentButton;
@property (nonatomic,retain) UIButton *commentButton;
@property (nonatomic,retain) UIButton *rebuyButton;
@property (nonatomic,retain) UIButton *confirmButton;
@end

@implementation QBSOrderListPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _priceLabel = [[UILabel alloc] init];
        [self addSubview:_priceLabel];
        {
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kLeftRightContentMarginSpacing);
                make.centerY.equalTo(self);
            }];
        }
    }
    return self;
}

- (UIButton *)paymentButton {
    if (_paymentButton) {
        return _paymentButton;
    }
    
    _paymentButton = [[UIButton alloc] init];
    _paymentButton.hidden = YES;
    _paymentButton.forceRoundCorner = YES;
    _paymentButton.titleLabel.font = kSmallFont;
    [_paymentButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FD472B"]] forState:UIControlStateNormal];
    [_paymentButton setTitle:@"付 款" forState:UIControlStateNormal];
    AssociatedButtonWithAction(_paymentButton, paymentAction);
    [self addSubview:_paymentButton];
    {
        [_paymentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-kLeftRightContentMarginSpacing);
            make.centerY.equalTo(self);
            make.height.equalTo(self).multipliedBy(0.6);
            make.width.equalTo(_paymentButton.mas_height).multipliedBy(2.8);
//            make.size.mas_equalTo(CGSizeMake(66, 24));
        }];
    }
    return _paymentButton;
}

- (UIButton *)commentButton {
    if (_commentButton) {
        return _commentButton;
    }
    
    _commentButton = [[UIButton alloc] init];
    _commentButton.hidden = YES;
    _commentButton.titleLabel.font = kSmallFont;
    [_commentButton setTitleColor:[UIColor colorWithHexString:@"#B3B3B3"] forState:UIControlStateNormal];
    [_commentButton setTitle:@"评价" forState:UIControlStateNormal];
    _commentButton.layer.borderColor = [_commentButton titleColorForState:UIControlStateNormal].CGColor;
    _commentButton.layer.borderWidth = 1;
    _commentButton.forceRoundCorner = YES;
    AssociatedButtonWithAction(_commentButton, commentAction);
    [self addSubview:_commentButton];
    {
        [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rebuyButton.mas_left).offset(-kMediumHorizontalSpacing);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(70, 24));
        }];
    }
    return _commentButton;
}

- (UIButton *)rebuyButton {
    if (_rebuyButton) {
        return _rebuyButton;
    }
    
    _rebuyButton = [[UIButton alloc] init];
    _rebuyButton.hidden = YES;
    _rebuyButton.titleLabel.font = kSmallFont;
    [_rebuyButton setTitleColor:[UIColor colorWithHexString:@"#FD472B"] forState:UIControlStateNormal];
    [_rebuyButton setTitle:@"再次购买" forState:UIControlStateNormal];
    _rebuyButton.layer.borderColor = [_rebuyButton titleColorForState:UIControlStateNormal].CGColor;
    _rebuyButton.layer.borderWidth = 1;
    _rebuyButton.forceRoundCorner = YES;
    AssociatedButtonWithAction(_rebuyButton, rebuyAction);
    [self addSubview:_rebuyButton];
    {
        [_rebuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-kMediumHorizontalSpacing);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(70, 24));
        }];
    }
    return _rebuyButton;
}

- (UIButton *)confirmButton {
    if (_confirmButton) {
        return _confirmButton;
    }
    
    _confirmButton = [[UIButton alloc] init];
    _confirmButton.hidden = YES;
    _confirmButton.titleLabel.font = kSmallFont;
    [_confirmButton setTitleColor:[UIColor colorWithHexString:@"#FD472B"] forState:UIControlStateNormal];
    [_confirmButton setTitle:@"确认收货" forState:UIControlStateNormal];
    _confirmButton.layer.borderColor = [_confirmButton titleColorForState:UIControlStateNormal].CGColor;
    _confirmButton.layer.borderWidth = 1;
    _confirmButton.forceRoundCorner = YES;
    AssociatedButtonWithAction(_confirmButton, confirmAction);
    [self addSubview:_confirmButton];
    {
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-kLeftRightContentMarginSpacing);
            make.centerY.equalTo(self);
            make.height.equalTo(self).multipliedBy(0.6);
            make.width.equalTo(_confirmButton.mas_height).multipliedBy(2.8);
        }];
    }
    return _confirmButton;
}

- (void)setPaymentAction:(QBSAction)paymentAction {
    _paymentAction = paymentAction;
    
    if (paymentAction) {
        self.paymentButton.hidden = NO;
    } else {
        _paymentButton.hidden = YES;
    }
}

- (void)setCommentAction:(QBSAction)commentAction {
    _commentAction = commentAction;
    
    if (commentAction) {
        self.commentButton.hidden = NO;
    } else {
        _commentButton.hidden = YES;
    }
}

- (void)setRebuyAction:(QBSAction)rebuyAction {
    _rebuyAction = rebuyAction;
    
    if (rebuyAction) {
        self.rebuyButton.hidden = NO;
    } else {
        _rebuyButton.hidden = YES;
    }
}

- (void)setConfirmAction:(QBSAction)confirmAction {
    _confirmAction = confirmAction;
    
    if (confirmAction) {
        self.confirmButton.hidden = NO;
    } else {
        _confirmButton.hidden = YES;
    }
}

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice {
    NSString *prefixString = @"合计：";
    NSString *priceString = [NSString stringWithFormat:@"¥ %@", QBSIntegralPrice(price)];
    NSString *originalPriceString = QBSIntegralPrice(originalPrice);
    
    NSString *str = [prefixString stringByAppendingString:priceString];
    if (originalPrice > 0) {
        str = [str stringByAppendingFormat:@" %@", originalPriceString];
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],
                                NSFontAttributeName:kSmallFont} range:NSMakeRange(0, prefixString.length)];
    
    [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FD472B"],
                                NSFontAttributeName:kMediumFont} range:NSMakeRange(prefixString.length, priceString.length)];
    
    if (originalPrice > 0) {
        [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],
                                    NSFontAttributeName:kSmallFont,
                                    NSStrikethroughStyleAttributeName:@1} range:NSMakeRange(str.length-originalPriceString.length, originalPriceString.length)];
    }
    
    _priceLabel.attributedText = attrString;
}

@end
