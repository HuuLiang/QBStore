//
//  QBSCustomerServiceButton.m
//  Pods
//
//  Created by Sean Yue on 16/7/17.
//
//

#import "QBSCustomerServiceButton.h"

#define kInterItemSpacing CGRectGetHeight(contentRect)*0.05
#define kTitleLabelFont kExExSmallFont

@implementation QBSCustomerServiceButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setImage:[UIImage QBS_imageWithResourcePath:@"customer_service"] forState:UIControlStateNormal];
        [self setTitle:@"客服" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        
        self.titleLabel.font = kTitleLabelFont;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    const CGFloat imageWidth = CGRectGetWidth(contentRect) / 3;
    const CGFloat imageHeight = imageWidth;
    
    const CGFloat imageX = (CGRectGetWidth(contentRect) - imageWidth)/2;
    const CGFloat imageY = (CGRectGetHeight(contentRect) - imageHeight - kInterItemSpacing - kTitleLabelFont.pointSize)/2;
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect imageRect = [self imageRectForContentRect:contentRect];
    return CGRectMake(contentRect.origin.x, CGRectGetMaxY(imageRect)+kInterItemSpacing, contentRect.size.width, kTitleLabelFont.pointSize);
}

//- (CGRect)contentRectForBounds:(CGRect)bounds {
//    const CGFloat contentWidth = CGRectGetWidth(bounds) / 3;
//    const CGFloat contentHeight = contentWidth + 30;
//    const CGFloat contentX = (CGRectGetWidth(bounds)-contentWidth)/2;
//    const CGFloat contentY = (CGRectGetHeight(bounds)-contentHeight)/2;
//    return CGRectMake(contentX, contentY, contentWidth, contentHeight);
//}
@end
