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
    UIImageView *_backImageView;
}
@end

@implementation QBSMineAvatarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage QBS_imageWithResourcePath:@"mine_header_background" ofType:@"jpg"]];
        [self addSubview:_backImageView];
        
        {
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
            
        }
        _backImageView.userInteractionEnabled = YES;
        _avatarButton = [[QBSAvatarButton alloc] init];
        [_backImageView addSubview:_avatarButton];
        {
            [_avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_backImageView);
                make.centerY.equalTo(_backImageView).offset(15);
                make.width.equalTo(_backImageView).multipliedBy(0.2);
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
