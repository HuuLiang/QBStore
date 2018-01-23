//
//  QBSUserProfileViewController.h
//  Pods
//
//  Created by Sean Yue on 16/8/4.
//
//

#import "QBSUserViewController.h"

@interface QBSUserProfileViewController : QBSUserViewController

@property (nonatomic,copy) QBSAction logoutAction;

- (instancetype)init __attribute__((unavailable("Use - initWithLogoutAction: instead!")));
- (instancetype)initWithLogoutAction:(QBSAction)logoutAction;

@end
