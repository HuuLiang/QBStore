//
//  QBSHUDManager.h
//  Pods
//
//  Created by Sean Yue on 16/8/20.
//
//

#import <Foundation/Foundation.h>

@interface QBSHUDManager : NSObject

DeclareSingletonMethod(sharedManager)

- (void)showError:(NSString *)error;
- (void)showError:(NSString *)error afterDismiss:(QBSAction)block;
- (void)showSuccess:(NSString *)success;
- (void)showInfo:(NSString *)info;

- (void)showLoading;
- (void)showLoading:(NSString *)text;

- (void)showProgress:(CGFloat)progress;
- (void)showProgressProgress:(CGFloat)progress withTitle:(NSString *)title;

- (void)hide;
- (void)hideWithDelay:(NSTimeInterval)delay;

- (void)setTitle:(NSString *)title;

- (BOOL)isShown;

//- (UIView *)visibleHUDView;

@end
