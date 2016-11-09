//
//  QBSHomeCommodityCell.m
//  QBStore
//
//  Created by Sean Yue on 2016/10/31.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSHomeCommodityCell.h"

@interface QBSHomeCommodityCell ()
@property (nonatomic,retain) UIImageView *thumbImageView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) NSMutableArray<UILabel *> *tagLabels;
@property (nonatomic,retain) UITextView *detailTextView;
@end

@implementation QBSHomeCommodityCell

DefineLazyPropertyInitialization(NSMutableArray, tagLabels)

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (UIImageView *)thumbImageView {
    if (_thumbImageView) {
        return _thumbImageView;
    }
    
    _thumbImageView = [[UIImageView alloc] init];
    _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_thumbImageView];
    {
        [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kMediumHorizontalSpacing);
            make.centerY.equalTo(self);
            make.height.equalTo(self).multipliedBy(0.7);
            make.width.equalTo(_thumbImageView.mas_height);
        }];
    }
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
    {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.thumbImageView.mas_right).offset(kMediumHorizontalSpacing);
            make.right.equalTo(self).offset(-kMediumHorizontalSpacing);
            make.top.equalTo(self).offset(kTopBottomContentMarginSpacing);
        }];
    }
    return _titleLabel;
}

- (UITextView *)detailTextView {
    if (_detailTextView) {
        return _detailTextView;
    }
    
    return _detailTextView;
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
    _tags = tags;
    
    const NSInteger numberOfAddedTagLabels = tags.count - self.tagLabels.count;
    if (numberOfAddedTagLabels > 0) {
        for (NSUInteger i = 0; i < numberOfAddedTagLabels; ++i) {
            UILabel *label = [[UILabel alloc] init];
            label.font = kExtraSmallFont;
            label.textColor = [UIColor colorWithHexString:@"#FF206F"];
            [self addSubview:label];
            {
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.tagLabels.lastObject ? self.tagLabels.lastObject.mas_right : self);
                    make.top.equalTo(self.titleLabel.mas_bottom).offset(kSmallVerticalSpacing);
                }];
            }
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

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice {
    
}

- (void)setCountDownTime:(NSTimeInterval)countDownTime withFinishedBlock:(QBSAction)finishedBlock {
    
}
@end
