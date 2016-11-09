//
//  QBSOrderCommentListCell.m
//  Pods
//
//  Created by Sean Yue on 16/8/29.
//
//

#import "QBSOrderCommentListCell.h"
#import "UITextView+Placeholder.h"

@interface QBSOrderCommentListCell () <UITextViewDelegate>
{
    UIImageView *_thumbImageView;
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UILabel *_starLabel;
    UITextView *_commentTextView;
}
@property (nonatomic,retain) NSArray<UIButton *> *starButtons;
@end

@implementation QBSOrderCommentListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kLeftRightContentMarginSpacing);
                make.top.equalTo(self).offset(kTopBottomContentMarginSpacing);
                make.width.equalTo(self).multipliedBy(0.25);
                make.height.equalTo(_thumbImageView.mas_width);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = kMediumFont;
        _titleLabel.numberOfLines = 2;
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_thumbImageView.mas_right).offset(kMediumHorizontalSpacing);
                make.right.equalTo(self).offset(-kLeftRightContentMarginSpacing);
                make.top.equalTo(_thumbImageView);
                make.height.mas_equalTo(_titleLabel.font.pointSize*(_titleLabel.numberOfLines+1));
            }];
        }
        
        _priceLabel = [[UILabel alloc] init];
        [self addSubview:_priceLabel];
        {
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_titleLabel);
                make.top.equalTo(_titleLabel.mas_bottom).offset(kSmallVerticalSpacing);
            }];
        }
        
        _starLabel = [[UILabel alloc] init];
        _starLabel.font = kMediumFont;
        _starLabel.textColor = _titleLabel.textColor;
        _starLabel.text = @"评分：";
        [self addSubview:_starLabel];
        {
            [_starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_titleLabel);
                make.top.equalTo(_priceLabel.mas_bottom).offset(kMediumVerticalSpacing);
            }];
        }
        
        [self.starButtons.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_starLabel.mas_right);
            make.centerY.equalTo(_starLabel);
        }];
        
        _commentTextView = [[UITextView alloc] init];
        _commentTextView.layer.borderWidth = 0.5;
        _commentTextView.layer.borderColor = [UIColor colorWithHexString:@"#979797"].CGColor;
        _commentTextView.placeholder = @"宝贝用的好吗?来分享一下您的使用感受吧！";
        _commentTextView.font = kSmallFont;
        _commentTextView.delegate = self;
        [self addSubview:_commentTextView];
        {
            [_commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_titleLabel);
                make.top.equalTo(self.starButtons.firstObject.mas_bottom).offset(kSmallVerticalSpacing);
                make.bottom.equalTo(self).offset(-kTopBottomContentMarginSpacing);
            }];
        }
        
        @weakify(self);
        [self bk_whenTapped:^{
            @strongify(self);
            [self endEditing:YES];
        }];
    }
    return self;
}

- (NSArray<UIButton *> *)starButtons {
    if (_starButtons) {
        return _starButtons;
    }
    
    NSMutableArray *stars = [NSMutableArray arrayWithCapacity:5];
    for (NSUInteger i = 0; i < 5; ++i) {
        UIButton *starButton = [[UIButton alloc] init];
        starButton.contentEdgeInsets = UIEdgeInsetsMake(kLeftRightContentMarginSpacing/2, kLeftRightContentMarginSpacing/2, kLeftRightContentMarginSpacing/2, kLeftRightContentMarginSpacing/2);
        [starButton setImage:[UIImage QBS_imageWithResourcePath:@"comment_unstar"] forState:UIControlStateNormal];
        [starButton setImage:[UIImage QBS_imageWithResourcePath:@"comment_star"] forState:UIControlStateSelected];
        [self addSubview:starButton];
        
        UIButton *prevButton = stars.lastObject;
        if (prevButton) {
            [starButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(prevButton.mas_right);
                make.centerY.equalTo(prevButton);
            }];
        }
        [stars addObject:starButton];
        
        @weakify(self);
        [starButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            self.stars = i+1;
            
            SafelyCallBlock(self.starAction, self);
        } forControlEvents:UIControlEventTouchUpInside];
        
    }
    _starButtons = stars;
    return _starButtons;
}

- (void)setStars:(NSUInteger)stars {
    _stars = stars;
    
    for (NSUInteger buttonIndex = 0; buttonIndex < 5; ++buttonIndex) {
        [self.starButtons[buttonIndex] setSelected:buttonIndex < stars];
    }
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

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    SafelyCallBlock(self.commentAction, textView.text);
}
@end
