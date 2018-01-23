//
//  QBSMineAvatarView.m
//  QBStore
//
//  Created by Sean Yue on 2016/10/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSMineAvatarView.h"
#import "QBSAvatarButton.h"

@interface QBSMineAvatarView ()
{
    QBSAvatarButton *_avatarButton;
//    UIButton *_logoutButton;
}
@end

@implementation QBSMineAvatarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _avatarButton = [[QBSAvatarButton alloc] init];
        [self addSubview:_avatarButton];
        {
            [_avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.centerY.equalTo(self).offset(15);
                make.width.equalTo(self).multipliedBy(0.2);
                make.height.equalTo(_avatarButton.mas_width).offset(30);
            }];
        }
        
//        _logoutButton = [[UIButton alloc] init];
//        _logoutButton.hidden = YES;
//        _logoutButton.titleLabel.font = kSmallFont;
//        [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
//        [self addSubview:_logoutButton];
//        {
//            [_logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(self).offset(-5);
//                make.centerY.equalTo(self).multipliedBy(0.5);
//                make.size.mas_equalTo(CGSizeMake(88, 44));
//            }];
//        }
        
        AssociatedButtonWithAction(_avatarButton, avatarAction);
//        AssociatedButtonWithAction(_logoutButton, logoutAction);
    }
    return self;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_avatarButton sd_setImageWithURL:imageURL forState:UIControlStateNormal placeholderImage:self.placeholderImage options:SDWebImageRetryFailed|SDWebImageRefreshCached];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [_avatarButton setTitle:title forState:UIControlStateNormal];
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    [_avatarButton setImage:placeholderImage forState:UIControlStateNormal];
}
//
//- (void)setShowLogoutButton:(BOOL)showLogoutButton {
//    _showLogoutButton = showLogoutButton;
//    _logoutButton.hidden = !showLogoutButton;
//}
@end
