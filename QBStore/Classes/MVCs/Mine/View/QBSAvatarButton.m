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
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.forceRoundCorner = YES;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(contentRect.origin.x, contentRect.origin.y, contentRect.size.width, contentRect.size.width);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect imageRect = [self imageRectForContentRect:contentRect];
    const CGFloat titleWidth = imageRect.size.width * 1.25;
    return CGRectMake(-(titleWidth-imageRect.size.width)/2, CGRectGetMaxY(imageRect)+5, titleWidth, 30);
}
@end
