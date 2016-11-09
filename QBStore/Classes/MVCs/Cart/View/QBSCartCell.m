//
//  QBSCartCell.m
//  Pods
//
//  Created by Sean Yue on 16/7/22.
//
//

#import "QBSCartCell.h"
#import "QBSAmountPicker.h"

@interface QBSCartCell ()
{
    UIImageView *_thumbImageView;
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UIButton *_selectionButton;
    QBSAmountPicker *_amountPicker;
    UIButton *_deleteButton;
}
@end

@implementation QBSCartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _selectionButton = [[UIButton alloc] init];
        _selectionButton.contentMode = UIViewContentModeCenter;
        [_selectionButton setImage:[UIImage QBS_imageWithResourcePath:@"unselected_icon"] forState:UIControlStateNormal];
        [_selectionButton setImage:[UIImage QBS_imageWithResourcePath:@"selected_icon"] forState:UIControlStateSelected];
        [self addSubview:_selectionButton];
        {
            [_selectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.equalTo(self);
                make.width.equalTo(self).multipliedBy(0.15);
            }];
        }
        
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_selectionButton.mas_right);
                make.height.equalTo(self).multipliedBy(0.75);
                make.width.equalTo(_thumbImageView.mas_height);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = kMediumFont;
        _titleLabel.numberOfLines = 2;
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_thumbImageView);
                make.left.equalTo(_thumbImageView.mas_right).offset(kLeftRightContentMarginSpacing);
                make.right.equalTo(self).offset(-kLeftRightContentMarginSpacing);
                make.height.mas_equalTo(_titleLabel.font.pointSize * _titleLabel.numberOfLines + kBigVerticalSpacing);
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

        _amountPicker = [[QBSAmountPicker alloc] init];
        [self addSubview:_amountPicker];
        {
            [_amountPicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_titleLabel);
                make.top.equalTo(_priceLabel.mas_bottom).offset(kMediumVerticalSpacing);
                make.bottom.equalTo(_thumbImageView);
                make.width.equalTo(_titleLabel).multipliedBy(0.5);
            }];
        }
        
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setImage:[UIImage QBS_imageWithResourcePath:@"cart_item_delete"] forState:UIControlStateNormal];
        [self addSubview:_deleteButton];
        {
            [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_amountPicker);
                make.centerX.equalTo(_titleLabel).multipliedBy(1.25);
            }];
        }
        
        self.showSeparator = YES;
        
        
        AssociatedButtonWithAction(_deleteButton, deleteAction);
        
        @weakify(self);
        [_selectionButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            [sender setSelected:![sender isSelected]];
            SafelyCallBlock(self.selectionChangedAction, self);
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_amountPicker bk_addEventHandler:^(id sender) {
            @strongify(self);
            self.amount = [sender amount];
            SafelyCallBlock(self.amountChangedAction, self);
        } forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)setItemSelected:(BOOL)itemSelected {
    _selectionButton.selected = itemSelected;
}

- (BOOL)itemSelected {
    return _selectionButton.selected;
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
    _amountPicker.amount = amount;
}

- (NSUInteger)amount {
    return _amountPicker.amount;
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
