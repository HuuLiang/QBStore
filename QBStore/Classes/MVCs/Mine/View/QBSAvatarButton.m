//
//  QBSAvatarButton.m
//  QBStore
//
//  Created by Sean Yue on 2016/10/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSAvatarButton.h"

@implementation QBSAvatarButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.showTitleAsButtonStyle = YES;
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.forceRoundCorner = YES;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(contentRect.origin.x, contentRect.origin.y, contentRect.size.width, contentRect.size.width);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    if (CGRectIsEmpty(contentRect)) {
        return CGRectZero;
    }
    
    CGRect imageRect = [self imageRectForContentRect:contentRect];
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    
    const CGFloat titleWidth = MAX(imageRect.size.width * 1.25, titleSize.width + 5);
    const CGFloat titleYOffset = CGRectGetHeight(contentRect) * 0.1;
    return CGRectMake(-(titleWidth-imageRect.size.width)/2, CGRectGetMaxY(imageRect)+titleYOffset, titleWidth, 30);
}

- (void)setShowTitleAsButtonStyle:(BOOL)showTitleAsButtonStyle {
    _showTitleAsButtonStyle = showTitleAsButtonStyle;
    
    if (showTitleAsButtonStyle) {
        self.titleLabel.backgroundColor = [UIColor colorWithHexString:@"#FF206F"];
        self.titleLabel.layer.cornerRadius = 5;
        self.titleLabel.clipsToBounds = YES;
        self.titleLabel.font = kMediumFont;
    } else {
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.layer.cornerRadius = 0;
        self.titleLabel.clipsToBounds = NO;
        self.titleLabel.font = kExtraBigFont;
    }
}
@end
