//
//  QBSProgressView.m
//  Pods
//
//  Created by Sean Yue on 16/7/20.
//
//

#import "QBSProgressView.h"

@interface QBSProgressView ()
{
    UILabel *_percentLabel;
    UIView *_percentView;
}
@end

@implementation QBSProgressView

- (instancetype)init {
    self = [super init];
    if (self) {
        _percentView = [[UIView alloc] init];
        [self addSubview:_percentView];

        _percentLabel = [[UILabel alloc] init];
        _percentLabel.textColor = [UIColor whiteColor];
        [_percentView addSubview:_percentLabel];
        {
            [_percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_percentView);
            }];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
    
    _percentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds)*_progress/100, CGRectGetHeight(self.bounds));
    _percentView.layer.cornerRadius = CGRectGetHeight(_percentView.frame)/2;
    
    _percentLabel.font = [UIFont systemFontOfSize:CGRectGetHeight(_percentView.frame)];
}

- (void)setProgress:(NSUInteger)progress {
    _progress = progress;
    _percentLabel.text = [NSString stringWithFormat:@"%ld%%", (unsigned long)progress];
    
    [self setNeedsLayout];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = progressTintColor;
    _percentView.backgroundColor = progressTintColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
    _trackTintColor = trackTintColor;
    self.backgroundColor = trackTintColor;
}
@end
