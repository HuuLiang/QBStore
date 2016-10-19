//
//  QBSWeChatLoginButton.m
//  Pods
//
//  Created by Sean Yue on 16/7/27.
//
//

#import "QBSWeChatLoginButton.h"

@implementation QBSWeChatLoginButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setImage:[UIImage QBS_imageWithResourcePath:@"login_wechat"] forState:UIControlStateNormal];
        [self setTitle:@"微信一键登录" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.titleLabel.font = kMediumFont;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect imageRect = [super imageRectForContentRect:contentRect];
    return CGRectOffset(imageRect, -10, 0);
}
@end
