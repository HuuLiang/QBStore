//
//  QBSTableViewCell.m
//  Pods
//
//  Created by Sean Yue on 16/7/19.
//
//

#import "QBSTableViewCell.h"

@interface QBSTableViewCell ()
@property (nonatomic,retain) UIView *separatorView;
@end

@implementation QBSTableViewCell
@synthesize separatorColor = _separatorColor;

- (UIColor *)separatorColor {
    UIColor *color = _separatorColor;
    if (color) {
        return color;
    }
    
    color = [[[self class] appearance] separatorColor];
    if (color) {
        return color;
    }
    
    return [UIColor colorWithHexString:@"#E9E9E9"];
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    _separatorView.backgroundColor = separatorColor;
}

- (void)setShowSeparator:(BOOL)showSeparator {
    _showSeparator = showSeparator;
    
    if (showSeparator) {
        self.separatorView.hidden = NO;
    } else {
        _separatorView.hidden = YES;
    }
}

- (void)setSeparatorInsets:(UIEdgeInsets)separatorInsets {
    _separatorInsets = separatorInsets;
    
    [_separatorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(separatorInsets.left);
        make.right.equalTo(self).offset(-separatorInsets.right);
    }];
}

- (UIView *)separatorView {
    if (_separatorView) {
        return _separatorView;
    }
    
    _separatorView = [[UIView alloc] init];
    _separatorView.backgroundColor = self.separatorColor;
    [self addSubview:_separatorView];
    {
        [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(self.separatorInsets.left);
            make.right.equalTo(self).offset(-self.separatorInsets.right);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _separatorView;
}
@end
