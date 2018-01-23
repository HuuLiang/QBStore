//
//  QBSErrorHandler.h
//  Pods
//
//  Created by Sean Yue on 16/8/23.
//
//

#import <Foundation/Foundation.h>

@interface QBSErrorHandler : NSObject

DeclareSingletonMethod(sharedHandler)

- (void)handleError:(NSError *)error;

@end
