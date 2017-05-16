//
//  QBSHttpClient.h
//  Pods
//
//  Created by Sean Yue on 16/7/7.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QBSHttpMethodType) {
    QBSHttpMethodUnknown,
    QBSHttpMethodGET,
    QBSHttpMethodPOST
};

@interface QBSHttpClient : NSObject

DeclareSingletonMethod(sharedClient)
//DeclareSingletonMethod(paymentClient)

- (void)requestURL:(NSString *)urlPath
        withParams:(id)params
        methodType:(QBSHttpMethodType)methodtype
 completionHandler:(QBSCompletionHandler)completionHandler;


@end

extern NSString *const kQBSHttpClientArgErrorDomain;
