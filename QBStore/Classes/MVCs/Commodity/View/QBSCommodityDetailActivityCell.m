//
//  QBSCommodityDetailActivityCell.m
//  QBStore
//
//  Created by Sean Yue on 2016/11/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSCommodityDetailActivityCell.h"
#import "MZTimerLabel.h"

@interface QBSCommodityDetailActivityCell ()
{
    UIImageView *_backgroundImageView;
    UILabel *_priceLabel;
    UILabel *_originalPriceLabel;
    UILabel *_soldLabel;
    UILabel *_countingLabel;
    MZTimerLabel *_timerLabel;
}
@end

@implementation QBSCommodityDetailActivityCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_background"]];
        [self addSubview:_backgroundImageView];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = kHugeBoldFont;
        _priceLabel.textColor = [UIColor whiteColor];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_priceLabel];
        
        _originalPriceLabel = [[UILabel alloc] init];
        _originalPriceLabel.font = kSmallFont;
        _originalPriceLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
        _originalPriceLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_originalPriceLabel];
        
        _soldLabel = [[UILabel alloc] init];
        _soldLabel.font = kSmallFont;
        _soldLabel.textColor = [UIColor whiteColor];
        _soldLabel.textAlignment = NSTextAlignmentCenter;
        _soldLabel.backgroundColor = [UIColor colorWithHexString:@"#980C1D"];
        [self addSubview:_soldLabel];
        
        _countingLabel = [[UILabel alloc] init];
        _countingLabel.textAlignment = NSTextAlignmentCenter;
        _countingLabel.font = kSmallFont;
        _countingLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _countingLabel.text = @"距结束仅剩";
        [self addSubview:_countingLabel];
        
        _timerLabel = [[MZTimerLabel alloc] initWithTimerType:MZTimerLabelTypeTimer];
        _timerLabel.textAlignment = NSTextAlignmentCenter;
        _timerLabel.shouldCountBeyondHHLimit = YES;
        [self addSubview:_timerLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat fullHeight = CGRectGetHeight(self.bounds);
    const CGFloat fullWidth = CGRectGetWidth(self.bounds);
    
    _backgroundImageView.frame = CGRectMake(0, 0, fullWidth*0.7, fullHeight);
    
    const CGSize originalSize = [_originalPriceLabel.attributedText.string sizeWithAttributes:@{NSFontAttributeName:_originalPriceLabel.font}];
    const CGFloat originalWidth = originalSize.width+5;
    const CGFloat originalHeight = originalSize.height;
    const CGFloat originalX = CGRectGetMaxX(_backgroundImageView.frame)*0.8-originalWidth;
    const CGFloat originalY = fullHeight/2-originalHeight;
    _originalPriceLabel.frame = CGRectMake(originalX, originalY, originalWidth, originalHeight);
    
    const CGSize soldSize = [_soldLabel.text sizeWithAttributes:@{NSFontAttributeName:_soldLabel.font}];
    const CGFloat soldWidth = soldSize.width+5;
    const CGFloat soldHeight = soldSize.height+3;
    const CGFloat soldX = originalX + (originalWidth-soldWidth)/2;
    const CGFloat soldY = CGRectGetMaxY(_originalPriceLabel.frame) + kSmallVerticalSpacing;
    _soldLabel.frame = CGRectMake(soldX, soldY, soldWidth, soldHeight);
    
    const CGFloat priceX = kLeftRightContentMarginSpacing;
    const CGFloat priceWidth = MIN(soldX, originalX) - priceX;
    _priceLabel.frame = CGRectMake(priceX, 0, priceWidth, fullHeight);
    
    const CGSize countingSize = [_countingLabel.text sizeWithAttributes:@{NSFontAttributeName:_countingLabel.font}];
    const CGFloat countingWidth = countingSize.width+5;
    const CGFloat countingHeight = countingSize.height+3;
    const CGFloat countingX = _backgroundImageView.frame.size.width+((fullWidth-_backgroundImageView.frame.size.width)-countingWidth)/2;
    const CGFloat countingY = fullHeight/2-countingHeight;
    _countingLabel.frame = CGRectMake(countingX, countingY, countingWidth, countingHeight);
    
    const CGFloat timerX = CGRectGetMaxX(_backgroundImageView.frame)+5;
    const CGFloat timerY = CGRectGetMaxY(_countingLabel.frame);
    const CGFloat timerWidth = fullWidth-timerX-5;
    const CGFloat timerHeight = 30;
    _timerLabel.frame = CGRectMake(timerX, timerY, timerWidth, timerHeight);
}

- (void)setCurrentPrice:(CGFloat)currentPrice {
    _currentPrice = currentPrice;
    
    NSString *priceString = QBSIntegralPrice(currentPrice);
    _priceLabel.text = [NSString stringWithFormat:@"¥ %@元", priceString];
}

- (void)setOriginalPrice:(CGFloat)originalPrice {
    _originalPrice = originalPrice;
    
    NSString *priceString = [NSString stringWithFormat:@"¥ %@元", QBSIntegralPrice(originalPrice)];
    _originalPriceLabel.attributedText = [[NSAttributedString alloc] initWithString:priceString attributes:@{NSStrikethroughStyleAttributeName:@1}];
}

- (void)setSold:(NSUInteger)sold {
    _sold = sold;
    _soldLabel.text = [NSString stringWithFormat:@"%@件已售", sold < 10000 ? @(sold).stringValue : @"9999+"];
}

- (void)setCountDownTime:(NSTimeInterval)countDownTime withFinishedBlock:(QBSAction)finishedBlock {
    @weakify(self);
    [_timerLabel reset];
    [_timerLabel setCountDownTime:countDownTime];
    [_timerLabel startWithEndingBlock:^(NSTimeInterval countTime) {
        @strongify(self);
        SafelyCallBlock(finishedBlock, self);
    }];
}
@end
