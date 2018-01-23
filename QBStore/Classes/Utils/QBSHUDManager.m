//
//  QBSHUDManager.m
//  Pods
//
//  Created by Sean Yue on 16/8/20.
//
//

#import "QBSHUDManager.h"
#import "SVProgressHUD.h"

@implementation QBSHUDManager

SynthesizeSingletonMethod(sharedManager, QBSHUDManager)

- (instancetype)init {
    self = [super init];
    if (self) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD setMinimumDismissTimeInterval:2];
    }
    return self;
}

- (void)showError:(NSString *)error {
    [SVProgressHUD showErrorWithStatus:error];
}

- (void)showError:(NSString *)error afterDismiss:(QBSAction)block {
    NSTimeInterval displayDuration = [SVProgressHUD displayDurationForString:error];
    [SVProgressHUD showErrorWithStatus:error];
    
    [self bk_performBlock:block afterDelay:displayDuration];
}

- (void)showSuccess:(NSString *)success {
    [SVProgressHUD showSuccessWithStatus:success];
}

- (void)showInfo:(NSString *)info {
    [SVProgressHUD showInfoWithStatus:info];
}

- (void)showLoading {
    [SVProgressHUD show];
}

- (void)showLoading:(NSString *)text {
    [SVProgressHUD showWithStatus:text];
}

- (void)showProgress:(CGFloat)progress {
    [SVProgressHUD showProgress:progress];
}

- (void)showProgressProgress:(CGFloat)progress withTitle:(NSString *)title {
    [SVProgressHUD showProgress:progress status:title];
}

- (void)hide {
    [SVProgressHUD dismiss];
}

- (void)hideWithDelay:(NSTimeInterval)delay {
    [SVProgressHUD dismissWithDelay:delay];
}

- (void)setTitle:(NSString *)title {
    [SVProgressHUD setStatus:title];
}

- (BOOL)isShown {
    return [SVProgressHUD isVisible];
}
//- (UIView *)visibleHUDView {
//    if (![SVProgressHUD isVisible]) {
//        return nil;
//    }
//    
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wundeclared-selector"
//    return [SVProgressHUD performSelector:@selector(sharedView)];
//#pragma clang diagnostic pop
//}
@end
