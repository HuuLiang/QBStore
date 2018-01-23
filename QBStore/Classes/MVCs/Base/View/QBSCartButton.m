//
//  QBSCartButton.m
//  Pods
//
//  Created by Sean Yue on 16/7/22.
//
//

#import "QBSCartButton.h"
#import "MZTimerLabel.h"
//#import "JSBadgeView.h"
#import "UIView+WZLBadge.h"

@interface QBSCartButton ()
//@property (nonatomic,retain) JSBadgeView *badgeView;
@property (nonatomic) BOOL badgeValueChanged;
@end

@implementation QBSCartButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageView.clipsToBounds = NO;
        self.imageView.badgeFont = kExExSmallFont;
        self.imageView.badgeTextColor = [UIColor whiteColor];
        self.imageView.tintColor = [UIColor colorWithHexString:@"#666666"];
        [self setImage:[[UIImage QBS_imageWithResourcePath:@"cart"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.badgeBackgroundColor = [UIColor colorWithHexString:@"#FF206F"];
    }
    return self;
}

- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor {
    _badgeBackgroundColor = badgeBackgroundColor;
    self.imageView.badgeBgColor = badgeBackgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [self setBackgroundImage:[UIImage imageWithColor:backgroundColor] forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_badgeValueChanged) {
        [self.imageView showBadgeWithStyle:WBadgeStyleNumber value:_numberOfCommodities animationType:WBadgeAnimTypeNone];
        _badgeValueChanged = NO;
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect imageRect = [super imageRectForContentRect:contentRect];
    
    if (CGRectIsEmpty(imageRect)) {
        return imageRect;
    }
    return CGRectOffset(imageRect, self.imageOffset.horizontal, self.imageOffset.vertical);
}

- (void)setNumberOfCommodities:(NSUInteger)numberOfCommodities {
    if (_numberOfCommodities == numberOfCommodities) {
        return ;
    }
    
    _numberOfCommodities = numberOfCommodities;
    _badgeValueChanged = YES;
    [self setNeedsLayout];
}
//- (JSBadgeView *)badgeView {
//    if (_badgeView) {
//        return _badgeView;
//    }
//    
//    _badgeView = [[JSBadgeView alloc] initWithParentView:self.imageView alignment:JSBadgeViewAlignmentTopRight];
//    _badgeView.badgeTextFont = kExExSmallFont;
//    _badgeView.badgeBackgroundColor = [UIColor colorWithHexString:@"#FF206F"];
//    _badgeView.badgeTextColor = [UIColor whiteColor];
//    return _badgeView;
//}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    if (_numberOfCommodities > 0) {
//        self.badgeView.badgeText = _numberOfCommodities > 99 ? @"99+" : @(_numberOfCommodities).stringValue;
//    } else {
//        _badgeView.badgeText = nil;
//    }
//    //self.badgeView.frameToPositionInRelationWith = self.imageView.bounds;
//}

@end
