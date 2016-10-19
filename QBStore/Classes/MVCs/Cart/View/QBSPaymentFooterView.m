//
//  QBSPaymentFooterView.m
//  Pods
//
//  Created by Sean Yue on 16/7/23.
//
//

#import "QBSPaymentFooterView.h"

@interface QBSPaymentFooterView ()
{
    UIView *_separatorView;
    UIButton *_paymentButton;
    UIButton *_selectionButton;
    UILabel *_priceLabel;
}
@end

@implementation QBSPaymentFooterView

- (instancetype)initWithPaymentTitle:(NSString *)paymentTitle allowsSelection:(BOOL)allowsSelection {
    self = [super init];
    if (self) {
        _showAmountInPaymentButton = YES;
        _paymentTitle = paymentTitle;
        _allowsSelection = allowsSelection;
        
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = [[[self class] appearance] separatorColor] ?: [UIColor colorWithHexString:@"#FF206F"];
        [self addSubview:_separatorView];
        {
            [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
                make.height.mas_equalTo(0.5);
            }];
        }
        
        _paymentButton = [[UIButton alloc] init];
        _paymentButton.titleLabel.font = kBigFont;
        [_paymentButton setTitle:paymentTitle forState:UIControlStateNormal];
        [_paymentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_paymentButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FF206F"]] forState:UIControlStateNormal];
        [_paymentButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#888888"]] forState:UIControlStateDisabled];
        _paymentButton.enabled = NO;
        [self addSubview:_paymentButton];
        {
            [_paymentButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.top.equalTo(self);
                make.width.equalTo(self).dividedBy(3);
            }];
        }
        
        @weakify(self);
        if (allowsSelection) {
            _selectionButton = [[UIButton alloc] init];
            _selectionButton.titleLabel.font = kMediumFont;
            [_selectionButton setImage:[UIImage QBS_imageWithResourcePath:@"unselected_icon"] forState:UIControlStateNormal];
            [_selectionButton setImage:[UIImage QBS_imageWithResourcePath:@"selected_icon"] forState:UIControlStateSelected];
            [_selectionButton setTitle:@" 全选 " forState:UIControlStateNormal];
            [_selectionButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            [self addSubview:_selectionButton];
            {
                [_selectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self);
                    make.centerY.equalTo(self);
                    make.width.mas_offset(88);
                }];
            }
            
            [_selectionButton bk_addEventHandler:^(id sender) {
                @strongify(self);
                self.selected = !self.selected;
                SafelyCallBlock(self.selectionChangedAction, self);
            } forControlEvents:UIControlEventTouchUpInside];
        }
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.numberOfLines = 2;
        [self addSubview:_priceLabel];
        {
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_selectionButton?_selectionButton.mas_right:self).offset(_selectionButton?0:kLeftRightContentMarginSpacing);
                make.right.equalTo(_paymentButton.mas_left).offset(-kLeftRightContentMarginSpacing);
                make.centerY.equalTo(self);
            }];
        }
        
        [_paymentButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.editingSelection) {
                SafelyCallBlock(self.deleteSelectionAction, self);
            } else {
                SafelyCallBlock(self.paymentAction, self);
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    _separatorView.backgroundColor = separatorColor;
}

- (void)setSelected:(BOOL)selected {
    if (_selected == selected) {
        return ;
    }
    
    _selected = selected;
    _selectionButton.selected = selected;
}

- (void)setPaymentTitle:(NSString *)paymentTitle {
    _paymentTitle = paymentTitle;
    [_paymentButton setTitle:paymentTitle forState:UIControlStateNormal];
}

- (void)setEditingSelection:(BOOL)editingSelection {
    _editingSelection = editingSelection;
    
    if (editingSelection) {
        _priceLabel.hidden = YES;
    } else {
        _priceLabel.hidden = NO;
    }
    [self updatePaymentButton];
}

- (void)setShowAmountInPaymentButton:(BOOL)showAmountInPaymentButton {
    _showAmountInPaymentButton = showAmountInPaymentButton;
    [self updatePaymentButton];
}

- (void)updatePaymentButton {
    NSString *title;
    
    if (_editingSelection) {
        if (_amount > 0) {
            title = [NSString stringWithFormat:@"删除(%ld)", (unsigned long)_amount];
        } else {
            title = @"删除";
        }
    } else {
        if (_amount > 0 && _showAmountInPaymentButton) {
            title = [NSString stringWithFormat:@"%@(%ld)", self.paymentTitle, (unsigned long)_amount];
        } else {
            title = self.paymentTitle;
        }
    }
    
    _paymentButton.enabled = _amount > 0;
    [_paymentButton setTitle:title forState:UIControlStateNormal];
}

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice andAmount:(NSUInteger)amount {
    _currentPrice = price;
    _originalPrice = originalPrice;
    _amount = amount;
    
    NSString *prefixString = @"合计：";
    NSString *priceString = [NSString stringWithFormat:@"¥%@", QBSIntegralPrice(price)];
    
    NSString *str = [NSString stringWithFormat:@"%@%@", prefixString, priceString];
    if (originalPrice > 0) {
        str = [str stringByAppendingFormat:@"\n原价：%@", QBSIntegralPrice(originalPrice)];
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],
                                NSFontAttributeName:kSmallFont} range:NSMakeRange(0, prefixString.length)];
    
    [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FD472B"],
                                NSFontAttributeName:kMediumFont} range:NSMakeRange(prefixString.length, priceString.length)];
    
    if (originalPrice > 0) {
        [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],
                                    NSFontAttributeName:kSmallFont,
                                    NSStrikethroughStyleAttributeName:@1} range:NSMakeRange(prefixString.length+priceString.length+1, attrString.length-prefixString.length-priceString.length-1)];
    }
    
    _priceLabel.attributedText = attrString;
    
    [self updatePaymentButton];
}
@end
