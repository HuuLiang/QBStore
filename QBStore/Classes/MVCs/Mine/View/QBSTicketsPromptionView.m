//
//  QBSTicketsPromptionView.m
//  QBStore
//
//  Created by Sean Yue on 2016/11/12.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSTicketsPromptionView.h"

@interface QBSTicketsPromptionView ()
{
    UIImageView *_thumbImageView;
    UIButton *_closeButton;
    UIView *_lineView;
}
@end

@implementation QBSTicketsPromptionView

+ (instancetype)showPromptionInView:(UIView *)view {
    QBSTicketsPromptionView *newView = [[self alloc] init];
    [newView showInView:view];
    return newView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        _thumbImageView = [[UIImageView alloc] initWithImage:[UIImage QBS_imageWithResourcePath:@"ticket_promption" ofType:@"jpg"]];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.centerY.equalTo(self).multipliedBy(0.8);
                make.width.equalTo(self).multipliedBy(0.8);
                make.height.equalTo(_thumbImageView.mas_width);
            }];
        }
        
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage QBS_imageWithResourcePath:@"close"] forState:UIControlStateNormal];
        [self addSubview:_closeButton];
        {
            [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_thumbImageView);
                make.top.equalTo(_thumbImageView.mas_bottom).offset(30);
            }];
        }
        
        @weakify(self);
        [_closeButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            [self hide];
        } forControlEvents:UIControlEventTouchUpInside];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
        [self insertSubview:_lineView belowSubview:_thumbImageView];
        {
            [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_thumbImageView);
                make.width.mas_equalTo(1);
                make.top.equalTo(_thumbImageView.mas_centerY);
                make.bottom.equalTo(_closeButton.mas_top);
            }];
        }
    }
    return self;
}

- (void)showInView:(UIView *)view {
    if ([view.subviews containsObject:self]) {
        return ;
    }
    
    self.frame = view.bounds;
    [view addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    
    CGRect buttonFrame = _closeButton.frame;
    if (CGRectIsEmpty(buttonFrame)) {
        return view;
    }
    
    CGRect expandedFrame = CGRectInset(buttonFrame, -10, -10);
    if (CGRectContainsPoint(expandedFrame, point)) {
        return _closeButton;
    }
    return view;
}
@end
