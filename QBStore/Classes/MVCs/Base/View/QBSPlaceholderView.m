//
//  QBSPlaceholderView.m
//  QBStore
//
//  Created by Sean Yue on 2016/10/28.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSPlaceholderView.h"

@interface QBSPlaceholderView ()
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
}
@end

@implementation QBSPlaceholderView
@synthesize actionButton = _actionButton;

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLabel.font = kBigFont;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _actionButton = [[UIButton alloc] init];
        [_actionButton setTitleColor:kQBSThemeColor forState:UIControlStateNormal];
        _actionButton.layer.cornerRadius = 5;
        _actionButton.layer.borderColor = kQBSThemeColor.CGColor;
        _actionButton.layer.borderWidth = 1;
        _actionButton.titleLabel.font = kBigFont;
        [self addSubview:_actionButton];
        
        AssociatedButtonWithAction(_actionButton, action);
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

+ (instancetype)showPlaceholderForView:(UIView *)view
                             withImage:(UIImage *)image
                                 title:(NSString *)title
                           buttonTitle:(NSString *)buttonTitle
                          buttonAction:(QBSAction)buttonAction
{
    QBSPlaceholderView *placeholderView = [self placeholderForView:view];
    if (!placeholderView) {
        placeholderView = [[self alloc] init];
    }
    
    placeholderView.image = image;
    placeholderView.title = title;
    placeholderView.action = buttonAction;
    [placeholderView.actionButton setTitle:buttonTitle forState:UIControlStateNormal];

    [placeholderView showPlaceholderForView:view];
    return placeholderView;
}

+ (instancetype)placeholderForView:(UIView *)view {
    return [view.subviews bk_match:^BOOL(UIView *obj) {
        return [obj isKindOfClass:[QBSPlaceholderView class]];
    }];
}

- (void)showPlaceholderForView:(UIView *)view {
    QBSPlaceholderView *placeholderView = [[self class] placeholderForView:view];
    if (placeholderView == self) {
        return ;
    } else {
        [placeholderView removeFromSuperview];
    }
    
    [view addSubview:self];
    {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.width.equalTo(view);
            make.height.equalTo(view).multipliedBy(0.75);
        }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat fullWidth = self.bounds.size.width;
    
    const CGSize imageSize = _imageView.image.size;
    const CGFloat imageX = (fullWidth - imageSize.width)/2;
    _imageView.frame = CGRectMake(imageX, 0, imageSize.width, imageSize.height);
    
    const CGFloat titleY = CGRectGetMaxY(_imageView.frame)+kScreenHeight*0.045;
    _titleLabel.frame = CGRectMake(0, titleY, fullWidth, _titleLabel.font.pointSize);
    
    const CGFloat buttonHeight = 44;
    const CGFloat buttonWidth = [[_actionButton titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName:_actionButton.titleLabel.font}].width+20;
    const CGFloat buttonX = (fullWidth-buttonWidth)/2;
    const CGFloat buttonY = CGRectGetMaxY(_titleLabel.frame)+kScreenHeight*0.075;
    _actionButton.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
    _actionButton.hidden = [_actionButton titleForState:UIControlStateNormal] == nil;
}

- (void)hide {
    if (self.superview) {
        [self removeFromSuperview];
    }
}
@end

