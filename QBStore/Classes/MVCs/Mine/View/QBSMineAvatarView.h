//
//  QBSMineAvatarView.h
//  QBStore
//
//  Created by Sean Yue on 2016/10/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBSMineAvatarView : UIView

@property (nonatomic,retain) UIImage *placeholderImage;
@property (nonatomic) NSString *title;
@property (nonatomic) NSURL *imageURL;
@property (nonatomic,copy) QBSAction avatarAction;

//@property (nonatomic) BOOL showLogoutButton;
//@property (nonatomic,copy) QBSAction logoutAction;

@end
