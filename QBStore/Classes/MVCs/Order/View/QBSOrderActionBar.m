//
//  QBSOrderActionBar.m
//  Pods
//
//  Created by Sean Yue on 16/8/26.
//
//

#import "QBSOrderActionBar.h"

@interface QBSOrderActionButton : UIButton

@end

@implementation QBSOrderActionButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect imageRect = [super imageRectForContentRect:contentRect];
    return CGRectOffset(imageRect, -5, 0);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect titleRect = [super titleRectForContentRect:contentRect];
    return CGRectOffset(titleRect, 5, 0);
}
@end

@interface QBSOrderActionBar ()
{
    UIView *_separatorView;
}
@property (nonatomic,retain) NSMutableArray<QBSOrderActionButton *> *buttons;
@property (nonatomic,retain) NSMutableArray<UIView *> *verticalSeparators;
@end

@implementation QBSOrderActionBar

DefineLazyPropertyInitialization(NSMutableArray, buttons)
DefineLazyPropertyInitialization(NSMutableArray, verticalSeparators)

- (instancetype)init {
    self = [super init];
    if (self) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = [UIColor colorWithHexString:@"#FF206F"];
        [self addSubview:_separatorView];
        {
            [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
                make.height.mas_equalTo(0.5);
            }];
        }
    }
    return self;
}

- (void)reloadButtons {
    NSUInteger numberOfButtons = [self.dataSource numberOfButtons:self];
    
    NSInteger numberOfRemovedButtons = (NSInteger)self.buttons.count - (NSInteger)numberOfButtons;
    if (numberOfRemovedButtons > 0) {
        NSRange removeRange = NSMakeRange(self.buttons.count-numberOfRemovedButtons, numberOfRemovedButtons);
        [[self.buttons subarrayWithRange:removeRange] enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.buttons removeObjectsInRange:removeRange];
    }
    
    for (NSUInteger index = 0; index < numberOfButtons; ++index) {
        UIButton *button = [self buttonAtIndex:index];
        
        NSString *buttonTitle;
        UIImage *buttonImage;
        
        if ([self.dataSource respondsToSelector:@selector(actionBar:titleAtIndex:)]) {
            buttonTitle = [self.dataSource actionBar:self titleAtIndex:index];
        }
        
        if ([self.dataSource respondsToSelector:@selector(actionBar:imageAtIndex:)]) {
            buttonImage = [self.dataSource actionBar:self imageAtIndex:index];
        }
        
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setImage:[buttonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    
    NSUInteger numberOfVerticalSeparators = numberOfButtons == 0 ? 0 : numberOfButtons - 1;
    NSInteger numberOfDiffSeparators = (NSInteger)numberOfVerticalSeparators - (NSInteger)self.verticalSeparators.count;
    if (numberOfDiffSeparators < 0) {
        NSRange removeRange = NSMakeRange(self.verticalSeparators.count-labs(numberOfDiffSeparators), labs(numberOfDiffSeparators));
        [[self.verticalSeparators subarrayWithRange:removeRange] enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.verticalSeparators removeObjectsInRange:removeRange];
    } else if (numberOfDiffSeparators > 0) {
        for (NSUInteger i = 0; i < numberOfDiffSeparators; ++i) {
            UIView *separator = [[UIView alloc] init];
            separator.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
            [self insertSubview:separator aboveSubview:_separatorView];
            [self.verticalSeparators addObject:separator];
        }
    }
    
    [self setNeedsLayout];
}

- (NSString *)buttonTitleAtIndex:(NSUInteger)index {
    if (index < self.buttons.count) {
        UIButton *button = self.buttons[index];
        return [button titleForState:UIControlStateNormal];
    }
    return nil;
}

- (UIButton *)newButton {
    QBSOrderActionButton *newButton = [[QBSOrderActionButton alloc] init];
//    newButton.layer.borderWidth = 0.5;
//    newButton.layer.cornerRadius = 5;
    newButton.titleLabel.font = kMediumFont;
    [newButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [newButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#efefef"]] forState:UIControlStateHighlighted];
    newButton.imageView.tintColor = [newButton titleColorForState:UIControlStateNormal];
    [self insertSubview:newButton belowSubview:_separatorView];
    [self.buttons addObject:newButton];
    
    @weakify(self);
    [newButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        NSUInteger index = [self.buttons indexOfObject:sender];
        if (index == NSNotFound) {
            return ;
        }
        
        if ([self.delegate respondsToSelector:@selector(actionBar:didClickButtonAtIndex:)]) {
            [self.delegate actionBar:self didClickButtonAtIndex:index];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    return newButton;
}

//- (UIView *)newVerticalSeparator {
//    UIView *separator = [[UIView alloc] init];
//    separator.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
//    [self addSubview:separator];
//    [self.verticalSeparators addObject:separator];
//    return separator;
//}

- (UIButton *)buttonAtIndex:(NSUInteger)index {
    if (index < self.buttons.count) {
        UIButton *button = self.buttons[index];
        return button;
    } else {
        return [self newButton];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.buttons.count == 0) {
        return ;
    }
    
    const CGFloat fullWidth = self.bounds.size.width;
    const CGFloat fullHeight = self.bounds.size.height;

    const CGFloat buttonWidth = fullWidth / self.buttons.count;
    const CGFloat buttonHeight = fullHeight;
    const CGFloat buttonY = (fullHeight - buttonHeight)/2;
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(buttonWidth * idx, buttonY, buttonWidth, buttonHeight);
        
        if (idx < self.verticalSeparators.count) {
            UIView *separator = self.verticalSeparators[idx];
            
            const CGFloat separatorHeight = buttonHeight * 0.6;
            const CGFloat separatorY = (fullHeight - separatorHeight)/2;
            separator.frame = CGRectMake(CGRectGetMaxX(obj.frame), separatorY, 0.5, separatorHeight);
        }
    }];
    
    
}

@end
