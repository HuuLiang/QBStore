//
//  QBSOrderStatusButton.m
//  QBStore
//
//  Created by ylz on 2016/12/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSOrderStatusButton.h"

@implementation QBSOrderStatusButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel.backgroundColor = [UIColor redColor];
//        self.titleLabel.layer.cornerRadius = 5;
//        self.titleLabel.clipsToBounds = YES;
//        self.imageView.forceRoundCorner = YES;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(contentRect.size.width*0.7/2, (contentRect.size.height/2 - contentRect.size.width*0.3), contentRect.size.width*0.3, contentRect.size.width*0.3);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect imageRect = [self imageRectForContentRect:contentRect];
    const CGFloat titleWidth = imageRect.size.width * 2;
    return CGRectMake(imageRect.origin.x - (titleWidth - imageRect.size.width)/2, CGRectGetMaxY(imageRect)+5, titleWidth, 30);
}

@end
