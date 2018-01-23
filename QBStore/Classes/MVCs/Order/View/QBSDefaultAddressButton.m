//
//  QBSDefaultAddressButton.m
//  Pods
//
//  Created by Sean Yue on 16/8/2.
//
//

#import "QBSDefaultAddressButton.h"

@implementation QBSDefaultAddressButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleLabel.font = kSmallFont;
        [self setImage:[UIImage QBS_imageWithResourcePath:@"selected_icon"] forState:UIControlStateSelected];
        [self setImage:[UIImage QBS_imageWithResourcePath:@"unselected_icon"] forState:UIControlStateNormal];
        [self setTitle:@"设为默认地址" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect imageRect = [super imageRectForContentRect:contentRect];
    return CGRectMake(contentRect.origin.x, imageRect.origin.y, imageRect.size.width, imageRect.size.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect titleRect = [super titleRectForContentRect:contentRect];
    CGRect imageRect = [self imageRectForContentRect:contentRect];
    const CGFloat titleX = CGRectGetMaxX(imageRect) + contentRect.size.width *0.05;
    return CGRectMake(titleX, titleRect.origin.y, titleRect.size.width, titleRect.size.height);
}
@end
