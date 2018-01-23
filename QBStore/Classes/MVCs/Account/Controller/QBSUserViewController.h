//
//  QBSUserViewController.h
//  Pods
//
//  Created by Sean Yue on 16/8/4.
//
//

#import "QBSBaseViewController.h"

@interface QBSUserViewController : QBSBaseViewController

@property (nonatomic,copy) void (^completionHandler)(BOOL success);

- (void)onCloseCompleted;
- (UIImage *)backgroundImage;
- (BOOL)shouldUseBackgroundMask;

@end
