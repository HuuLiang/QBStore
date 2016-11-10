//
//  QBSHomeCommodityCell.m
//  QBStore
//
//  Created by Sean Yue on 2016/10/31.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSHomeCommodityCell.h"
#import "MZTimerLabel.h"

@interface QBSHomeCommodityCell ()
@property (nonatomic,retain) UIImageView *thumbImageView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) NSMutableArray<UILabel *> *tagLabels;
@property (nonatomic,retain) UITextView *detailTextView;
@property (nonatomic,retain) UILabel *soldLabel;
@property (nonatomic,retain) UILabel *priceLabel;
@property (nonatomic,retain) UIButton *buyButton;
@property (nonatomic,retain) UIImageView *footerImageView;

@property (nonatomic,retain) UIImageView *countingIconImageView;
@property (nonatomic,retain) MZTimerLabel *timerLabel;
@end

@implementation QBSHomeCommodityCell

DefineLazyPropertyInitialization(NSMutableArray, tagLabels)

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.style = QBSHomeCommodityCellNormalStyle;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat fullWidth = CGRectGetWidth(self.bounds);
    const CGFloat fullHeight = CGRectGetHeight(self.bounds);
    
    const CGFloat imageHeight = fullHeight * 0.7;
    const CGFloat imageWidth = imageHeight;
    const CGFloat imageX = kMediumHorizontalSpacing;
    const CGFloat imageY = (fullHeight - imageHeight)/2;
    _thumbImageView.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
    
    const CGFloat titleX = CGRectGetMaxX(_thumbImageView.frame) + kMediumHorizontalSpacing;
    const CGFloat titleY = kTopBottomContentMarginSpacing;
    const CGFloat titleWidth = fullWidth - kMediumHorizontalSpacing - titleX;
    const CGFloat titleHeight =  _titleLabel ? [_titleLabel.text boundingRectWithSize:CGSizeMake(titleWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_titleLabel.font} context:nil].size.height : 0;
    _titleLabel.frame = CGRectMake(titleX, titleY, titleWidth, titleHeight);
    
    [self.tagLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        const CGSize textSize = [obj.text sizeWithAttributes:@{NSFontAttributeName:obj.font}];
        const CGFloat tagWidth = textSize.width + 10;
        const CGFloat tagHeight = textSize.height + 3;
        
        BOOL newLine = NO;
        const CGFloat tagMaxX = CGRectGetMaxX(_titleLabel.frame);
        CGFloat tagX = titleX;
        if (idx > 0) {
            tagX = CGRectGetMaxX(self.tagLabels[idx-1].frame)+3;
            
            if (tagX+tagWidth>tagMaxX) {
                newLine = YES;
                tagX = titleX;
            }
        }
        
        CGFloat tagY = CGRectGetMaxY(_titleLabel.frame)+5;
        if (idx > 0) {
            if (!newLine) {
                tagY = self.tagLabels[idx-1].frame.origin.y;
            } else {
                tagY = CGRectGetMaxY(self.tagLabels[idx-1].frame)+5;
            }
        }
        obj.frame = CGRectMake(tagX, tagY, tagWidth, tagHeight);
    }];
    
    const CGFloat buyWidth = 68;
    const CGFloat buyHeight = 30;
    const CGFloat buyX = fullWidth - kLeftRightContentMarginSpacing - buyWidth - (_style==QBSHomeCommodityCellActivityStyle?10:0);
    const CGFloat buyY = fullHeight - kTopBottomContentMarginSpacing - buyHeight;
    _buyButton.frame = CGRectMake(buyX, buyY, buyWidth, buyHeight);
    
    const CGSize priceSize = [_priceLabel.attributedText size];
    const CGFloat priceX = titleX+kSmallHorizontalSpacing;
    const CGFloat priceY = buyY + (buyHeight-priceSize.height)/2;//fullHeight - priceSize.height - kTopBottomContentMarginSpacing;
    const CGFloat priceWidth = CGRectGetMaxX(_buyButton.frame)-priceX-5;
    _priceLabel.frame = CGRectMake(priceX, priceY, priceWidth, priceSize.height);
    
    const CGSize soldSize = _soldLabel ? [_soldLabel.text sizeWithAttributes:@{NSFontAttributeName:_soldLabel.font}] : CGSizeZero;
    const CGFloat soldX = fullWidth - soldSize.width - kLeftRightContentMarginSpacing;
    const CGFloat soldY = buyY - soldSize.height - kMediumVerticalSpacing;
    _soldLabel.frame = CGRectMake(soldX, soldY, soldSize.width+5, soldSize.height);
    
    if (!_footerImageView.hidden) {
        _footerImageView.frame = CGRectMake(titleX, buyY-kSmallVerticalSpacing, fullWidth-titleX, buyHeight + kSmallVerticalSpacing *2);
    }
    
    if (!_countingIconImageView.hidden) {
        const CGSize iconSize = _countingIconImageView.image.size;
        const CGFloat iconX = titleX;
        const CGFloat iconY = soldY + (soldSize.height - iconSize.height)/2;
        _countingIconImageView.frame = CGRectMake(iconX, iconY, iconSize.width, iconSize.height);
    }
    
    if (!_timerLabel.hidden) {
        const CGFloat timerHeight = 30;
        const CGFloat timerX = CGRectGetMaxX(_countingIconImageView.frame)+5;
        const CGFloat timerY = _countingIconImageView.frame.origin.y + (CGRectGetHeight(_countingIconImageView.frame)-timerHeight)/2;
        _timerLabel.frame = CGRectMake(timerX, timerY, soldX - timerX, timerHeight);
    }
    
    const CGFloat detailX = titleX;
    const CGFloat detailY = self.tagLabels.lastObject ? CGRectGetMaxY(self.tagLabels.lastObject.frame) + kMediumVerticalSpacing : titleY+kMediumVerticalSpacing;
    const CGFloat detailWidth = titleWidth;
    const CGFloat detailHeight = soldY - detailY;
    _detailTextView.frame = CGRectMake(detailX, detailY, detailWidth, detailHeight);
}

- (UIImageView *)thumbImageView {
    if (_thumbImageView) {
        return _thumbImageView;
    }
    
    _thumbImageView = [[UIImageView alloc] init];
    _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_thumbImageView];
    return _thumbImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLabel.font = kBigFont;
    _titleLabel.numberOfLines = 2;
    [self addSubview:_titleLabel];
    return _titleLabel;
}

- (UITextView *)detailTextView {
    if (_detailTextView) {
        return _detailTextView;
    }
    
    _detailTextView = [[UITextView alloc] init];
    _detailTextView.font = kSmallFont;
    _detailTextView.textColor = [UIColor colorWithHexString:@"#666666"];
    _detailTextView.editable = NO;
    _detailTextView.scrollEnabled = NO;
    _detailTextView.userInteractionEnabled = NO;
    [self addSubview:_detailTextView];
    return _detailTextView;
}

- (UILabel *)priceLabel {
    if (_priceLabel) {
        return _priceLabel;
    }
    
    _priceLabel = [[UILabel alloc] init];
    [self addSubview:_priceLabel];
    return _priceLabel;
}

- (UILabel *)soldLabel {
    if (_soldLabel) {
        return _soldLabel;
    }
    
    _soldLabel = [[UILabel alloc] init];
    _soldLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _soldLabel.font = kSmallFont;
    [self addSubview:_soldLabel];
    return _soldLabel;
}

- (void)setThumbImageURL:(NSURL *)thumbImageURL {
    _thumbImageURL = thumbImageURL;
    
    [self.thumbImageView QB_setImageWithURL:thumbImageURL];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setTags:(NSArray<NSString *> *)tags {
    if (tags.count == _tags.count) {
        __block BOOL tagsChanged = NO;
        [tags enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isEqualToString:_tags[idx]]) {
                *stop = YES;
                tagsChanged = YES;
            }
        }];
        
        if (!tagsChanged) {
            return ;
        }
    }

    _tags = tags;
    
    const NSInteger numberOfAddedTagLabels = tags.count - self.tagLabels.count;
    if (numberOfAddedTagLabels > 0) {
        for (NSUInteger i = 0; i < numberOfAddedTagLabels; ++i) {
            UILabel *label = [[UILabel alloc] init];
            label.font = kExtraSmallFont;
            label.textColor = [UIColor colorWithHexString:@"#FF206F"];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.borderWidth = 1;
            label.layer.borderColor = label.textColor.CGColor;
//            label.forceRoundCorner = YES;
            [self addSubview:label];

            [self.tagLabels addObject:label];
        }
    } else if (numberOfAddedTagLabels < 0) {
        for (NSUInteger i = self.tagLabels.count+numberOfAddedTagLabels; i < self.tagLabels.count; ++i) {
            UILabel *label = self.tagLabels[i];
            [label removeFromSuperview];
            [self.tagLabels removeObject:label];
        }
    }
    
    [self.tagLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.text = tags[idx];
    }];
}

- (void)setSold:(NSUInteger)sold {
    _sold = sold;
    self.soldLabel.text = [NSString stringWithFormat:@"%@件已付款", sold < 10000 ? @(sold).stringValue:@"9999+"];
}

- (void)setDetails:(NSString *)details {
    _details = details;
    self.detailTextView.text = details;
}

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice {
    NSString *priceString = [NSString stringWithFormat:@"¥%@元", QBSIntegralPrice(price)];
    
    NSString *str = priceString;
    if (originalPrice > 0) {
        NSString *originalPriceString = QBSIntegralPrice(originalPrice);
        str = [str stringByAppendingFormat:@" ¥%@元", originalPriceString];
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FD472B"],
                                NSFontAttributeName:kBigFont} range:NSMakeRange(0, priceString.length)];
    
    if (originalPrice > 0) {
        [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#888888"],
                                    NSFontAttributeName:kMediumFont,
                                    NSStrikethroughStyleAttributeName:@1} range:NSMakeRange(priceString.length+1, attrString.length-priceString.length-1)];
    }
    
    self.priceLabel.attributedText = attrString;
}

- (void)setCountDownTime:(NSTimeInterval)countDownTime withFinishedBlock:(QBSAction)finishedBlock {
    
    if (!_timerLabel) {
        _timerLabel = [[MZTimerLabel alloc] initWithTimerType:MZTimerLabelTypeTimer];
        [self addSubview:_timerLabel];
    }
    
    @weakify(self);
    [_timerLabel reset];
    [_timerLabel setCountDownTime:countDownTime];
    [_timerLabel startWithEndingBlock:^(NSTimeInterval countTime) {
        @strongify(self);
        SafelyCallBlock(finishedBlock, self);
    }];
}

- (void)setStyle:(QBSHomeCommodityCellStyle)style {
    _style = style;
    
    if (!_buyButton) {
        _buyButton = [[UIButton alloc] init];
        _buyButton.titleLabel.font = kMediumFont;
        _buyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _buyButton.userInteractionEnabled = YES;
//        AssociatedButtonWithAction(_buyButton, buyAction);
        [self addSubview:_buyButton];
    }
    
    if (style == QBSHomeCommodityCellActivityStyle) {
        [_buyButton setTitle:@"马上抢" forState:UIControlStateNormal];
        
        _buyButton.layer.cornerRadius = 4;
        _buyButton.backgroundColor = [UIColor colorWithHexString:@"#F8F51C"];
        [_buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_buyButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        _timerLabel.hidden = NO;
        
        if (!_footerImageView) {
            _footerImageView = [[UIImageView alloc] init];
            _footerImageView.image = [UIImage imageNamed:@"buy_footer"];
            [self insertSubview:_footerImageView atIndex:0];
        }
        _footerImageView.hidden = NO;
        
        if (!_countingIconImageView) {
            _countingIconImageView = [[UIImageView alloc] init];
            _countingIconImageView.image = [UIImage imageNamed:@"counting_clock"];
            _countingIconImageView.contentMode = UIViewContentModeLeft;
            [self addSubview:_countingIconImageView];
        }
        
        _countingIconImageView.hidden = NO;
    } else {
        [_buyButton setTitle:@"去购买" forState:UIControlStateNormal];
        
        _buyButton.layer.cornerRadius = 0;
        _buyButton.backgroundColor = [UIColor clearColor];
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyButton setBackgroundImage:[UIImage imageNamed:@"buy_background"] forState:UIControlStateNormal];
        
        [_timerLabel reset];
        _timerLabel.hidden = YES;
        _footerImageView.hidden = YES;
        _countingIconImageView.hidden = YES;
    }
    
}
@end
