//
//  QBSErrorHandler.m
//  Pods
//
//  Created by Sean Yue on 16/8/23.
//
//

#import "QBSErrorHandler.h"

@implementation QBSErrorHandler

SynthesizeSingletonMethod(sharedHandler, QBSErrorHandler)

- (void)handleError:(NSError *)error {
    BOOL isErrorShown = NO;
    if (error) {
        QBSLog(@"QBStoreSDK error: %@", error.qbsErrorMessage);
        
        if ([error.domain isEqualToString:kQBSRESTErrorDomain]
            && error.code == kQBSRESTInvalidUserAccess) {
            
        } else if (error.qbsErrorMessage.length > 0) {
            [[QBSHUDManager sharedManager] showError:error.qbsErrorMessage];
            isErrorShown = YES;
        }
    }
    
    if (!isErrorShown) {
        if ([[QBSHUDManager sharedManager] isShown]) {
            [[QBSHUDManager sharedManager] hide];
        }
    }
}

@end
